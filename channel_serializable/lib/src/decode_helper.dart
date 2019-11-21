// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'helper_core.dart';
import 'unsupported_type_error.dart';
import 'utils.dart';

class CreateFactoryResult {
  final String output;
  final Set<String> usedFields;

  CreateFactoryResult(this.output, this.usedFields);
}

abstract class DecodeHelper implements HelperCore {
  final StringBuffer _buffer = StringBuffer();

  CreateFactoryResult createFactory(Map<String, FieldElement> accessibleFields,
      Map<String, String> unavailableReasons) {
    assert(config.createFactory);
    assert(_buffer.isEmpty);

    final mapType = 'Map<String, dynamic>';
    _buffer.write('$targetClassReference '
        '${prefix}FromMap${genericClassArgumentsImpl(true)}'
        '($mapType map) {\n');

    String deserializeFun(String paramOrFieldName,
            {ParameterElement ctorParam}) =>
        _deserializeForField(accessibleFields[paramOrFieldName],
            ctorParam: ctorParam);

    _ConstructorData data;
    data = _writeConstructorInvocation(
        element,
        accessibleFields.keys,
        accessibleFields.values
            .where((fe) => !fe.isFinal)
            .map((fe) => fe.name)
            .toList(),
        unavailableReasons,
        deserializeFun);

    _buffer.write('''
return ${data.content}''');
    for (final field in data.fieldsToSet) {
      _buffer.writeln();
      _buffer.write('    ..$field = ');
      _buffer.write(deserializeFun(field));
    }
    _buffer.writeln(';\n}');
    _buffer.writeln();

    return CreateFactoryResult(
        _buffer.toString(), data.usedCtorParamsAndFields);
  }

  String _deserializeForField(FieldElement field,
      {ParameterElement ctorParam, bool checkedProperty}) {
    checkedProperty ??= false;
    final channelKeyName = safeNameAccess(field);
    final targetType = ctorParam?.type ?? field.type;
    final contextHelper = getHelperContext(field);

    String value;
    try {
      assert(!checkedProperty,
          'should only be true if `_generator.checked` is true.');

      value = contextHelper
          .deserialize(targetType, 'map[$channelKeyName]')
          .toString();
    } on UnsupportedTypeError catch (e) {
      throw createInvalidGenerationError('fromMap', field, e);
    }

    return value;
  }
}

/// [availableConstructorParameters] is checked to see if it is available. If
/// [availableConstructorParameters] does not contain the parameter name,
/// an [UnsupportedError] is thrown.
///
/// To improve the error details, [unavailableReasons] is checked for the
/// unavailable constructor parameter. If the value is not `null`, it is
/// included in the [UnsupportedError] message.
///
/// [writableFields] are also populated, but only if they have not already
/// been defined by a constructor parameter with the same name.
_ConstructorData _writeConstructorInvocation(
    ClassElement classElement,
    Iterable<String> availableConstructorParameters,
    Iterable<String> writableFields,
    Map<String, String> unavailableReasons,
    String deserializeForField(String paramOrFieldName,
        {ParameterElement ctorParam})) {
  final className = classElement.name;

  final ctor = classElement.unnamedConstructor;
  if (ctor == null) {
    // TODO(kevmoo): support using another ctor - dart-lang/channel_serializable#50
    throw InvalidGenerationSourceError(
        'The class `$className` has no default constructor.',
        element: classElement);
  }

  final usedCtorParamsAndFields = <String>{};
  final constructorArguments = <ParameterElement>[];
  final namedConstructorArguments = <ParameterElement>[];

  for (final arg in ctor.parameters) {
    if (!availableConstructorParameters.contains(arg.name)) {
      if (arg.isNotOptional) {
        var msg = 'Cannot populate the required constructor '
            'argument: ${arg.name}.';

        final additionalInfo = unavailableReasons[arg.name];

        if (additionalInfo != null) {
          msg = '$msg $additionalInfo';
        }

        throw InvalidGenerationSourceError(msg, element: ctor);
      }

      continue;
    }

    // TODO: validate that the types match!
    if (arg.isNamed) {
      namedConstructorArguments.add(arg);
    } else {
      constructorArguments.add(arg);
    }
    usedCtorParamsAndFields.add(arg.name);
  }

  // fields that aren't already set by the constructor and that aren't final
  final remainingFieldsForInvocationBody =
      writableFields.toSet().difference(usedCtorParamsAndFields);

  final buffer = StringBuffer();
  buffer.write('$className${genericClassArguments(classElement, false)}(');
  if (constructorArguments.isNotEmpty) {
    buffer.writeln();
    buffer.writeAll(constructorArguments.map((paramElement) {
      final content =
          deserializeForField(paramElement.name, ctorParam: paramElement);
      return '      $content,\n';
    }));
  }
  if (namedConstructorArguments.isNotEmpty) {
    buffer.writeln();
    buffer.writeAll(namedConstructorArguments.map((paramElement) {
      final value =
          deserializeForField(paramElement.name, ctorParam: paramElement);
      return '      ${paramElement.name}: $value,\n';
    }));
  }

  buffer.write(')');

  usedCtorParamsAndFields.addAll(remainingFieldsForInvocationBody);

  return _ConstructorData(buffer.toString(), remainingFieldsForInvocationBody,
      usedCtorParamsAndFields);
}

class _ConstructorData {
  final String content;
  final Set<String> fieldsToSet;
  final Set<String> usedCtorParamsAndFields;

  _ConstructorData(
      this.content, this.fieldsToSet, this.usedCtorParamsAndFields);
}

/// Returns a [String] representing a valid Dart literal for [value].
String jsonLiteralAsDart(dynamic value) {
  if (value == null) return 'null';

  if (value is String) return escapeDartString(value);

  if (value is bool || value is num) return value.toString();

  if (value is List) {
    final listItems = value.map(jsonLiteralAsDart).join(', ');
    return '[$listItems]';
  }

  if (value is Map) return jsonMapAsDart(value);

  throw StateError(
      'Should never get here – with ${value.runtimeType} - `$value`.');
}

String jsonMapAsDart(Map value) {
  final buffer = StringBuffer();
  buffer.write('{');

  var first = true;
  value.forEach((k, v) {
    if (first) {
      first = false;
    } else {
      buffer.writeln(',');
    }
    buffer.write(escapeDartString(k as String));
    buffer.write(': ');
    buffer.write(jsonLiteralAsDart(v));
  });

  buffer.write('}');

  return buffer.toString();
}
