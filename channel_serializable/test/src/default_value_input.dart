// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '_channel_serializable_test_input.dart';

@ShouldThrow(
  'Error with `@JsonKey` on `field`. '
  '`defaultValue` is `Symbol`, it must be a literal.',
  element: 'field',
)
@ChannelSerializable()
class DefaultWithSymbol {
  @JsonKey(defaultValue: #symbol)
  Object field;

  DefaultWithSymbol();
}

int _function() => 42;

@ShouldThrow(
  'Error with `@JsonKey` on `field`. '
  '`defaultValue` is `Function`, it must be a literal.',
  element: 'field',
)
@ChannelSerializable()
class DefaultWithFunction {
  @JsonKey(defaultValue: _function)
  Object field;

  DefaultWithFunction();
}

@ShouldThrow(
  'Error with `@JsonKey` on `field`. '
  '`defaultValue` is `Type`, it must be a literal.',
  element: 'field',
)
@ChannelSerializable()
class DefaultWithType {
  @JsonKey(defaultValue: Object)
  Object field;

  DefaultWithType();
}

@ShouldThrow(
  'Error with `@JsonKey` on `field`. '
  '`defaultValue` is `Duration`, it must be a literal.',
  element: 'field',
)
@ChannelSerializable()
class DefaultWithConstObject {
  @JsonKey(defaultValue: Duration())
  Object field;

  DefaultWithConstObject();
}

enum Enum { value }

@ShouldThrow(
  'Error with `@JsonKey` on `field`. '
  '`defaultValue` is `List > Enum`, it must be a literal.',
  element: 'field',
)
@ChannelSerializable()
class DefaultWithNestedEnum {
  @JsonKey(defaultValue: [Enum.value])
  Object field;

  DefaultWithNestedEnum();
}

@ShouldThrow(
  'Error with `@JsonKey` on `field`. '
  'Cannot use `defaultValue` on a field with `nullable` false.',
  element: 'field',
)
@ChannelSerializable()
class DefaultWithNonNullableField {
  @JsonKey(defaultValue: 42, nullable: false)
  Object field;

  DefaultWithNonNullableField();
}

@ShouldThrow(
  'Error with `@JsonKey` on `field`. '
  'Cannot use `defaultValue` on a field with `nullable` false.',
  element: 'field',
)
@ChannelSerializable(nullable: false)
class DefaultWithNonNullableClass {
  @JsonKey(defaultValue: 42)
  Object field;

  DefaultWithNonNullableClass();
}

@ShouldGenerate(
  r'''
DefaultWithToJsonClass _$DefaultWithToJsonClassFromJson(
    Map<String, dynamic> json) {
  return DefaultWithToJsonClass()
    ..fieldDefaultValueToJson = DefaultWithToJsonClass._fromJson(
            json['fieldDefaultValueToJson'] as String) ??
        7;
}
''',
  expectedLogItems: [
    '''
The field `fieldDefaultValueToJson` has both `defaultValue` and `fromJson` defined which likely won't work for your scenario.
Instead of using `defaultValue`, set `nullable: false` and handle `null` in the `fromJson` function.'''
  ],
)
@ChannelSerializable()
class DefaultWithToJsonClass {
  @JsonKey(defaultValue: 7, fromJson: _fromJson)
  int fieldDefaultValueToJson;

  DefaultWithToJsonClass();

  static int _fromJson(String input) => 41;
}

@ShouldGenerate(r'''
DefaultWithDisallowNullRequiredClass
    _$DefaultWithDisallowNullRequiredClassFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['theField'], disallowNullValues: const ['theField']);
  return DefaultWithDisallowNullRequiredClass()
    ..theField = json['theField'] as int ?? 7;
}
''', expectedLogItems: [
  'The `defaultValue` on field `theField` will have no effect because both `disallowNullValue` and `required` are set to `true`.'
])
@ChannelSerializable()
class DefaultWithDisallowNullRequiredClass {
  @JsonKey(defaultValue: 7, disallowNullValue: true, required: true)
  int theField;

  DefaultWithDisallowNullRequiredClass();
}
