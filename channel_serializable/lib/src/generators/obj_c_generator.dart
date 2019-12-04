import 'dart:async';
import 'dart:math';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:channel_annotation/channel_annotation.dart';
import 'package:source_gen/source_gen.dart';

import '../channel_key_utils.dart';
import '../field_helpers.dart';

const String kClassPrefix = 'CNL'; //TODO: move to config

enum ObjCFileType { H, M }

class ObjCGenerator extends Generator {
  final ObjCFileType fileType;
  static const String _deserializeMethodName = 'initWithChannelDict';
  static const String _serializeMethodName = 'toChannelDict';

  ObjCGenerator(this.fileType);

  TypeChecker get channelSerializableChecker =>
      const TypeChecker.fromRuntime(ChannelSerializable);

  TypeChecker get dateTimeChecker => const TypeChecker.fromRuntime(DateTime);

  TypeChecker get durationChecker => const TypeChecker.fromRuntime(Duration);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final values = <String>[];

    if (fileType == ObjCFileType.H) {
      values
        ..addAll(generateForAllElements(
            library, buildStep, generateForwardDeclarationForAnnotatedElement));
      values
        ..addAll(generateForAllElements(
            library, buildStep, generateInterfaceForAnnotatedElement));
    } else {
      if (library.annotatedWith(channelSerializableChecker).isNotEmpty) {
        values.add('#import "${buildStep.inputId.package}.g.h"');
      }
      values
        ..addAll(generateForAllElements(
            library, buildStep, generateImplementationForAnnotatedElement));
    }

    return values.join('\n\n');
  }

  Iterable<String> generateForwardDeclarationForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) sync* {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the ChannelSerializable annotation from `$name`.',
          element: element);
    }

    yield '@class ${_getSerializableClassName(element)};';
  }

  Iterable<String> generateInterfaceForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) sync* {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the ChannelSerializable annotation from `$name`.',
          element: element);
    }

    yield* _generateHFile(element as ClassElement);
  }

  Iterable<String> generateImplementationForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) sync* {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the ChannelSerializable annotation from `$name`.',
          element: element);
    }

    yield* _generateMFile(element as ClassElement);
  }

  Iterable<String> _generateHFile(ClassElement element) sync* {
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
      } else if (channelKeyForField(field, const ChannelSerializable())
          .ignore) {
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

- (instancetype) $_deserializeMethodName:(NSDictionary *)dict;
- (NSDictionary *) $_serializeMethodName;
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
  }

  Iterable<String> _generateMFile(ClassElement element) sync* {
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
      } else if (channelKeyForField(field, const ChannelSerializable())
          .ignore) {
        unavailableReasons[field.name] = 'It is assigned to an ignored field.';
      } else {
        assert(!map.containsKey(field.name));
        map[field.name] = field;
      }

      return map;
    });

    final accessibleFieldSet = accessibleFields.values.toSet();

    yield '''
@implementation ${_getSerializableClassName(element)}

- (instancetype) $_deserializeMethodName:(NSDictionary *)dict {
  self = [super init];
  if (self) {
${_generateInitWithChannelDict('    ', 'dict', accessibleFieldSet)}
  }
  return self;

}
- (NSDictionary *) $_serializeMethodName {
${_generateToChannelDict('  ', 'dict', accessibleFieldSet)}
}

${_generateCollectionsBuilders(accessibleFieldSet)}
@end
    ''';
  }

  String _getObjCType(DartType dartType,
      {Element field, bool valueTypeAllowed = true}) {
    if (dartType.isDartCoreString) {
      return 'NSString *';
    } else if (dateTimeChecker.isExactlyType(dartType)) {
      return 'NSDate *';
    } else if (durationChecker.isExactlyType(dartType)) {
      return valueTypeAllowed ? 'NSTimeInterval' : 'NSNumber *';
    } else if (dartType.isDartCoreInt) {
      return valueTypeAllowed ? 'long' : 'NSNumber *';
    } else if (dartType.isDartCoreBool) {
      return valueTypeAllowed ? 'BOOL' : 'NSNumber *';
    } else if (dartType.isDartCoreDouble) {
      return valueTypeAllowed ? 'double' : 'NSNumber *';
    } else if (dartType.isDartCoreSet) {
      final listElementsType = _getObjCType(
          (dartType as ParameterizedType).typeArguments[0],
          field: field,
          valueTypeAllowed: false);
      return 'NSSet<$listElementsType> *';
    } else if (dartType.isDartCoreList) {
      final listElementsType = _getObjCType(
          (dartType as ParameterizedType).typeArguments[0],
          field: field,
          valueTypeAllowed: false);
      return 'NSArray<$listElementsType> *';
    } else if (dartType.isDartCoreMap) {
      final arguments = (dartType as ParameterizedType).typeArguments;
      final keyType =
          _getObjCType(arguments[0], field: field, valueTypeAllowed: false);
      final valueType =
          _getObjCType(arguments[1], field: field, valueTypeAllowed: false);
      return 'NSDictionary<$keyType,$valueType> *';
    } else if (channelSerializableChecker
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

  String _generateInitWithChannelDict(
      String indent, String varName, Set<FieldElement> accessibleFieldSet) {
    return accessibleFieldSet.map((field) {
      return '${indent}self.${field.name} = ${_getFieldFromDict(varName, field.type, field: field)};';
    }).join('\n');
  }

  String _generateToChannelDict(
      String indent, String varName, Set<FieldElement> accessibleFieldSet) {
    return '''
${indent}return @{
${accessibleFieldSet.map((field) {
      return '$indent  @"${field.name}": ${_serializeSingleField(field)}';
    }).join(',\n')}
$indent};''';
  }

  String _serializeSingleField(FieldElement field) {
    return _serializeValue(field.type, 'self.${field.name}', true, field);
  }

  String _getFieldFromDict(String varName, DartType dartType,
      {Element field, bool valueTypeAllowed = true}) {
    final value = '$varName[@"${field.name}"]';
    return _deserializeValue(dartType, value, valueTypeAllowed, field);
  }

  String _deserializeValue(DartType dartType, String valueToDeserialize,
      bool valueTypeAllowed, Element field) {
    if (dartType.isDartCoreString) {
      return valueToDeserialize;
    } else if (dateTimeChecker.isExactlyType(dartType)) {
      return '[[NSDate alloc] initWithTimeIntervalSince1970:[$valueToDeserialize longValue]/1000000.0]';
    } else if (durationChecker.isExactlyType(dartType)) {
      final asNSTimeInterval = '[$valueToDeserialize longValue]/1000000.0';
      return valueTypeAllowed ? asNSTimeInterval : '@($asNSTimeInterval)';
    } else if (dartType.isDartCoreInt) {
      return valueTypeAllowed
          ? '[$valueToDeserialize longValue]'
          : valueToDeserialize;
    } else if (dartType.isDartCoreBool) {
      return valueTypeAllowed
          ? '[$valueToDeserialize boolValue]'
          : valueToDeserialize;
    } else if (dartType.isDartCoreDouble) {
      return valueTypeAllowed
          ? '[$valueToDeserialize doubleValue]'
          : valueToDeserialize;
    } else if (_isCollectionType(dartType)) {
      return '[self ${_deserializeFieldMethodName(field)}:$valueToDeserialize]';
    } else if (channelSerializableChecker
        .annotationsOf(dartType.element)
        .isNotEmpty) {
      return '[[${_getSerializableClassName(dartType.element)} alloc] $_deserializeMethodName:$valueToDeserialize]';
    } else {
      throw InvalidGenerationSourceError('Generator cannot target `$dartType`.',
          todo: 'Apply the ChannelSerializable annotation on `$dartType`.',
          element: field);
    }
  }

  String _serializeValue(DartType dartType, String valueToSerialize,
      bool valueTypeAllowed, Element field) {
    if (dartType.isDartCoreString) {
      return valueToSerialize;
    } else if (dateTimeChecker.isExactlyType(dartType)) {
      return '@($valueToSerialize.timeIntervalSince1970*1000000)';
    } else if (durationChecker.isExactlyType(dartType)) {
      final asValueType = valueTypeAllowed
          ? valueToSerialize
          : '[$valueToSerialize doubleValue]';
      return '@($asValueType*1000000)';
    } else if (dartType.isDartCoreInt ||
        dartType.isDartCoreBool ||
        dartType.isDartCoreDouble) {
      return valueTypeAllowed ? '@($valueToSerialize)' : valueToSerialize;
    } else if (_isCollectionType(dartType)) {
      return '[self ${_serializeFieldMethodName(field)}]';
    } else if (channelSerializableChecker
        .annotationsOf(dartType.element)
        .isNotEmpty) {
      return '[$valueToSerialize $_serializeMethodName]';
    } else {
      throw InvalidGenerationSourceError('Generator cannot target `$dartType`.',
          todo: 'Apply the ChannelSerializable annotation on `$dartType`.',
          element: field);
    }
  }

  bool _isCollectionType(DartType dartType) {
    return dartType.isDartCoreSet ||
        dartType.isDartCoreList ||
        dartType.isDartCoreMap;
  }

  String _deserializeFieldMethodName(Element field) {
    return 'deserialize_${field.name}';
  }

  String _serializeFieldMethodName(Element field) {
    return 'serialize_${field.name}';
  }

  String _generateCollectionsBuilders(Set<FieldElement> accessibleFieldSet) {
    return accessibleFieldSet
        .where((e) => _isCollectionType(e.type))
        .map((field) {
      final objCType = _getObjCType(field.type, field: field);
      final mutableObjCTypeName = _mutableObjCTypeName(field);
      final serializedType =
          field.type.isDartCoreMap ? 'NSDictionary *' : 'NSArray *';
      final collectionVarName = field.type.isDartCoreMap ? 'dict' : 'array';
      final objCField = 'self.${field.name}';
      final itemVarName = field.type.isDartCoreMap ? 'key' : 'item';
      final retVal = 'retVal';
      return '''-($objCType) ${_deserializeFieldMethodName(field)}:($serializedType)$collectionVarName {
  $mutableObjCTypeName * $retVal = [$mutableObjCTypeName new];
  for (id $itemVarName in $collectionVarName) {
${_generateDeserializeIterationCode(retVal, itemVarName, collectionVarName, field, '    ')}
  }
  return $retVal;
}

-($serializedType) ${_serializeFieldMethodName(field)} {
  $mutableObjCTypeName * $retVal = [$mutableObjCTypeName new];
  for (id $itemVarName in $objCField) {
${_generateSerializeIterationCode(retVal, itemVarName, objCField, field, '    ')}
  }
  return $retVal;
}
''';
    }).join('\n');
  }

  String _generateDeserializeIterationCode(String retVal, String itemVarName,
      String collectionVarName, FieldElement field, String indent) {
    final type = field.type;
    if (type.isDartCoreMap) {
      final arguments = (type as ParameterizedType).typeArguments;
      final keyType = arguments[0];
      final valueType = arguments[1];
      return '''${indent}id deserializedKey = ${_deserializeValue(keyType, itemVarName, false, field)};
${indent}id deserializedVal = ${_deserializeValue(valueType, '$collectionVarName[$itemVarName]', false, field)};      
$indent$retVal[deserializedKey] = deserializedVal;''';
    } else {
      final genericType = (type as ParameterizedType).typeArguments[0];
      return '$indent[$retVal addObject:${_deserializeValue(genericType, itemVarName, false, field)}];';
    }
  }

  String _generateSerializeIterationCode(String retVal, String itemVarName,
      String collectionVarName, FieldElement field, String indent) {
    final type = field.type;
    if (type.isDartCoreMap) {
      final arguments = (type as ParameterizedType).typeArguments;
      final keyType = arguments[0];
      final valueType = arguments[1];
      return '''${indent}id serializedKey = ${_serializeValue(keyType, itemVarName, false, field)};
${indent}id serializedVal = ${_serializeValue(valueType, '$collectionVarName[$itemVarName]', false, field)};      
$indent$retVal[serializedKey] = serializedVal;''';
    } else {
      final genericType = (type as ParameterizedType).typeArguments[0];
      return '$indent[$retVal addObject:${_serializeValue(genericType, itemVarName, false, field)}];';
    }
  }

  _mutableObjCTypeName(FieldElement field) {
    final type = field.type;
    if (type.isDartCoreMap) {
      return 'NSMutableDictionary';
    } else if (type.isDartCoreSet) {
      return 'NSMutableSet';
    } else if (type.isDartCoreList) {
      return 'NSMutableArray';
    } else {
      throw InvalidGenerationSourceError('`$type` is not a collection.',
          todo: 'Apply the ChannelSerializable annotation on `$type`.',
          element: field);
    }
  }

  List<String> generateForAllElements(
      LibraryReader library,
      BuildStep buildStep,
      Iterable<String> Function(
              Element element, ConstantReader annotation, BuildStep buildStep)
          generatorForAnnotatedElement) {
    final values = <String>[];

    for (var annotatedElement
        in library.annotatedWith(channelSerializableChecker)) {
      final generatedValue = generatorForAnnotatedElement(
          annotatedElement.element, annotatedElement.annotation, buildStep);
      for (var value in generatedValue) {
        assert(value == null);
        value = value.trim();
        values.add(value);
      }
    }
    return values;
  }
}
