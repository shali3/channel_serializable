// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';

import 'constants.dart';
import 'helper_core.dart';
import 'unsupported_type_error.dart';

abstract class EncodeHelper implements HelperCore {
  String _fieldAccess(FieldElement field) => '$_toMapParamName.${field.name}';

  Iterable<String> createToMap(Set<FieldElement> accessibleFields) sync* {
    final buffer = StringBuffer();

    final functionName = '${prefix}ToMap${genericClassArgumentsImpl(true)}';
    buffer.write('Map<String, dynamic> $functionName'
        '($targetClassReference $_toMapParamName) ');

    final writeNaive = accessibleFields.every(_writeJsonValueNaive);

    if (writeNaive) {
      // write simple `toJson` method that includes all keys...
      _writeToMapSimple(buffer, accessibleFields);
    } else {
      // At least one field should be excluded if null
      _writeToMapWithNullChecks(buffer, accessibleFields);
    }

    yield buffer.toString();
  }

  void _writeToMapSimple(StringBuffer buffer, Iterable<FieldElement> fields) {
    buffer.writeln('=> <String, dynamic>{');

    buffer.writeAll(fields.map((field) {
      final access = _fieldAccess(field);
      final value =
          '${safeNameAccess(field)}: ${_serializeField(field, access)}';
      return '        $value,\n';
    }));

    buffer.writeln('};');
  }

  static const _toMapParamName = 'instance';

  void _writeToMapWithNullChecks(
      StringBuffer buffer, Iterable<FieldElement> fields) {
    buffer.writeln('{');

    buffer.writeln('    final $generatedLocalVarName = <String, dynamic>{');

    // Note that the map literal is left open above. As long as target fields
    // don't need to be intercepted by the `only if null` logic, write them
    // to the map literal directly. In theory, should allow more efficient
    // serialization.
    var directWrite = true;

    for (final field in fields) {
      var safeFieldAccess = _fieldAccess(field);
      final safeChannelKeyString = safeNameAccess(field);

      // If `fieldName` collides with one of the local helpers, prefix
      // access with `this.`.
      if (safeFieldAccess == generatedLocalVarName ||
          safeFieldAccess == toJsonMapHelperName) {
        safeFieldAccess = 'this.$safeFieldAccess';
      }

      final expression = _serializeField(field, safeFieldAccess);
      if (_writeJsonValueNaive(field)) {
        if (directWrite) {
          buffer.writeln('      $safeChannelKeyString: $expression,');
        } else {
          buffer.writeln(
              '    $generatedLocalVarName[$safeChannelKeyString] = $expression;');
        }
      } else {
        if (directWrite) {
          // close the still-open map literal
          buffer.writeln('    };');
          buffer.writeln();

          // write the helper to be used by all following null-excluding
          // fields
          buffer.writeln('''
    void $toJsonMapHelperName(String key, dynamic value) {
      if (value != null) {
        $generatedLocalVarName[key] = value;
      }
    }
''');
          directWrite = false;
        }
        buffer.writeln(
            '    $toJsonMapHelperName($safeChannelKeyString, $expression);');
      }
    }

    buffer.writeln('    return $generatedLocalVarName;');
    buffer.writeln('  }');
  }

  String _serializeField(FieldElement field, String accessExpression) {
    try {
      return getHelperContext(field)
          .serialize(field.type, accessExpression)
          .toString();
    } on UnsupportedTypeError catch (e) {
      throw createInvalidGenerationError('toJson', field, e);
    }
  }

  /// Returns `true` if the field can be written to JSON 'naively' – meaning
  /// we can avoid checking for `null`.
  bool _writeJsonValueNaive(FieldElement field) {
    return true; // we always need to check for null.
//    final jsonKey = jsonKeyFor(field);
//    return jsonKey.includeIfNull ||
//        (!jsonKey.nullable && !_fieldHasCustomEncoder(field));
  }

//  /// Returns `true` if [field] has a user-defined encoder.
//  ///
//  /// This can be either a `toJson` function in [ChannelKey] or a [ChannelConverter]
//  /// annotation.
//  bool _fieldHasCustomEncoder(FieldElement field) {
//    final helperContext = getHelperContext(field);
//    return helperContext.serializeConvertData != null ||
//        const JsonConverterHelper()
//                .serialize(field.type, 'test', helperContext) !=
//            null;
//  }
}
