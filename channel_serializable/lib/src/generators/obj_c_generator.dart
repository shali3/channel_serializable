import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:channel_annotation/channel_annotation.dart';
import 'package:source_gen/source_gen.dart';

import '../../type_helper.dart';
import '../decode_helper.dart';
import '../encoder_helper.dart';
import '../field_helpers.dart';
import '../helper_core.dart';
import '../utils.dart';

const String kClassPrefix = 'CNL'; //TODO: move to config
final _channelSerializableChecker =
    const TypeChecker.fromRuntime(ChannelSerializable);

final _dateTimeChecker = const TypeChecker.fromRuntime(DateTime);

final _durationChecker = const TypeChecker.fromRuntime(Duration);

class ObjCGenerator extends GeneratorForAnnotation<ChannelSerializable> {
  @override
  Iterable<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the ChannelSerializable annotation from `$name`.',
          element: element);
    }

    final classElement = element as ClassElement;
    final helper = _GeneratorHelper(this, classElement, annotation);
    return helper._generate();
  }

  ObjCGenerator();
}

class _GeneratorHelper extends HelperCore with EncodeHelper, DecodeHelper {
  final ObjCGenerator _generator;
  final _addedMembers = <String>{};

  _GeneratorHelper(
      this._generator, ClassElement element, ConstantReader annotation)
      : super(element,
            mergeConfig(ChannelSerializable().withDefaults(), annotation));

  @override
  void addMember(String memberContent) {
    _addedMembers.add(memberContent);
  }

  @override
  Iterable<TypeHelper> get allTypeHelpers => [];

  Iterable<String> _generate() sync* {
    assert(_addedMembers.isEmpty);
    final sortedFields = createSortedFieldSet(element);

    // Used to keep track of why a field is ignored. Useful for providing
    // helpful errors when generating constructor calls that try to use one of
    // these fields.
    final unavailableReasons = <String, String>{};

    final accessibleFields = sortedFields.fold<Map<String, FieldElement>>(
        <String, FieldElement>{}, (map, field) {
      if (!field.isPublic) {
        unavailableReasons[field.name] = 'It is assigned to a private field.';
      } else if (field.getter == null) {
        assert(field.setter != null);
        unavailableReasons[field.name] =
            'Setter-only properties are not supported.';
        log.warning('Setters are ignored: ${element.name}.${field.name}');
      } else if (channelKeyFor(field).ignore) {
        unavailableReasons[field.name] = 'It is assigned to an ignored field.';
      } else {
        assert(!map.containsKey(field.name));
        map[field.name] = field;
      }

      return map;
    });

    final accessibleFieldSet = accessibleFields.values.toSet();

    final buffer = StringBuffer();

    buffer.writeln('''
@interface ${_getSerializableClassName(element)} : NSObject

- (instancetype) initWithChannelDict:(NSDictionary *)dict;
- (NSDictionary *) toChannelDict;
    ''');

    buffer.writeAll(accessibleFieldSet.map((field) {
      var objCType = _getObjCType(field.type, field: field);
      if (objCType.substring(objCType.length - 1) != '*') {
        objCType += ' ';
      }
      return '@property(nonatomic) $objCType${field.name};\n';
    }));

    buffer.writeln('@end');

    yield buffer.toString();

    yield* _addedMembers;
  }

  String _getObjCType(DartType dartType,
      {Element field, bool allowValueTypes = true}) {
    if (dartType.isDartCoreString) {
      return 'NSString *';
    } else if (_dateTimeChecker.isExactlyType(dartType)) {
      return 'NSDate *';
    } else if (_durationChecker.isExactlyType(dartType)) {
      return allowValueTypes ? 'NSTimeInterval' : 'NSNumber *';
    } else if (dartType.isDartCoreInt) {
      return allowValueTypes ? 'long' : 'NSNumber *';
    } else if (dartType.isDartCoreBool) {
      return allowValueTypes ? 'bool' : 'NSNumber *';
    } else if (dartType.isDartCoreDouble) {
      return allowValueTypes ? 'double' : 'NSNumber *';
    } else if (dartType.isDartCoreSet) {
      final listElementsType = _getObjCType(
          (dartType as ParameterizedType).typeArguments[0],
          field: field,
          allowValueTypes: false);
      return 'NSSet<$listElementsType> *';
    } else if (dartType.isDartCoreList) {
      final listElementsType = _getObjCType(
          (dartType as ParameterizedType).typeArguments[0],
          field: field,
          allowValueTypes: false);
      return 'NSArray<$listElementsType> *';
    } else if (dartType.isDartCoreMap) {
      final arguments = (dartType as ParameterizedType).typeArguments;
      final keyType =
          _getObjCType(arguments[0], field: field, allowValueTypes: false);
      final valueType =
          _getObjCType(arguments[1], field: field, allowValueTypes: false);
      return 'NSDictionary<$keyType,$valueType> *';
    } else if (_channelSerializableChecker
        .annotationsOf(dartType.element)
        .isNotEmpty) {
      return '${_getSerializableClassName(dartType.element)} *';
    } else {
      throw InvalidGenerationSourceError('Generator cannot target `$dartType`.',
          todo: 'Apply the ChannelSerializable annotation on `$dartType`.',
          element: field);
    }
  }

  String _getSerializableClassName(Element element) {
    return '$kClassPrefix${element.name}';
  }
}
