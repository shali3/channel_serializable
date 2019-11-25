import 'package:analyzer/dart/element/element.dart';
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

const String kClassPrefix = 'TST'; //TODO: move to config
final _channelSerializableChecker = const TypeChecker.fromRuntime(ChannelSerializable);

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

    var accessibleFieldSet = accessibleFields.values.toSet();
//    if (config.createFactory) {
//      final createResult = createFactory(accessibleFields, unavailableReasons);
//      yield createResult.output;
//
//      accessibleFieldSet = accessibleFields.entries
//          .where((e) => createResult.usedFields.contains(e.key))
//          .map((e) => e.value)
//          .toSet();
//    }

    final buffer = StringBuffer();

    buffer.writeln('@interface $kClassPrefix${element.name} : NSObject');

    buffer.writeAll(accessibleFieldSet.map((field) {
      return '    @property(nonatomic) ${_getObjCType(field)} ${field.name};\n';
    }));

    buffer.writeln('@end');

    yield buffer.toString();

    yield* _addedMembers;
  }

  String _getObjCType(FieldElement field) {
    if (field.type.isDartCoreString) {
      return 'NSString *';
    }
    _channelSerializableChecker.anno
    field.
    return 'id';
  }
}
