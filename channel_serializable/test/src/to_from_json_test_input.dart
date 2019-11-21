// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '_channel_serializable_test_input.dart';

int _toInt(bool input) => 42;

int _twoArgFunction(int a, int b) => 42;

dynamic _toDynamic(dynamic input) => null;

Object _toObject(Object input) => null;

@ShouldThrow(
  'Error with `@JsonKey` on `field`. The `fromJson` function `_toInt` '
  'return type `int` is not compatible with field type `String`.',
  element: 'field',
)
@ChannelSerializable()
class BadFromFuncReturnType {
  @JsonKey(fromJson: _toInt)
  String field;
}

@ShouldThrow(
  'Error with `@JsonKey` on `field`. The `fromJson` function '
  '`_twoArgFunction` must have one positional paramater.',
  element: 'field',
)
@ChannelSerializable()
class InvalidFromFunc2Args {
  @JsonKey(fromJson: _twoArgFunction)
  String field;
}

@ShouldGenerate(
  r'''
ValidToFromFuncClassStatic _$ValidToFromFuncClassStaticFromJson(
    Map<String, dynamic> json) {
  return ValidToFromFuncClassStatic()
    ..field = ValidToFromFuncClassStatic._staticFunc(json['field'] as String);
}

Map<String, dynamic> _$ValidToFromFuncClassStaticToJson(
        ValidToFromFuncClassStatic instance) =>
    <String, dynamic>{
      'field': ValidToFromFuncClassStatic._staticFunc(instance.field),
    };
''',
  configurations: ['default'],
)
@ChannelSerializable()
class ValidToFromFuncClassStatic {
  static String _staticFunc(String param) => null;

  @JsonKey(fromJson: _staticFunc, toJson: _staticFunc)
  String field;
}

@ShouldThrow(
  'Error with `@JsonKey` on `field`. The `toJson` function `_toInt` '
  'argument type `bool` is not compatible with field type `String`.',
  element: 'field',
)
@ChannelSerializable()
class BadToFuncReturnType {
  @JsonKey(toJson: _toInt)
  String field;
}

@ShouldThrow(
  'Error with `@JsonKey` on `field`. The `toJson` function '
  '`_twoArgFunction` must have one positional paramater.',
  element: 'field',
)
@ChannelSerializable()
class InvalidToFunc2Args {
  @JsonKey(toJson: _twoArgFunction)
  String field;
}

@ShouldGenerate(
  "_toObject(json['field'])",
  contains: true,
)
@ChannelSerializable()
class ObjectConvertMethods {
  @JsonKey(fromJson: _toObject, toJson: _toObject)
  String field;
}

@ShouldGenerate(
  "_toDynamic(json['field'])",
  contains: true,
  configurations: ['default'],
)
@ChannelSerializable()
class DynamicConvertMethods {
  @JsonKey(fromJson: _toDynamic, toJson: _toDynamic)
  String field;
}

String _toString(String input) => null;

@ShouldGenerate(
  "_toString(json['field'] as String)",
  contains: true,
  configurations: ['default'],
)
@ChannelSerializable()
class TypedConvertMethods {
  @JsonKey(fromJson: _toString, toJson: _toString)
  String field;
}

@ShouldGenerate(
  r'''
Map<String, dynamic> _$ToJsonNullableFalseIncludeIfNullFalseToJson(
    ToJsonNullableFalseIncludeIfNullFalse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('field', _toString(instance.field));
  return val;
}
''',
  expectedLogItems: [
    'The `JsonKey.nullable` value on '
        '`ToJsonNullableFalseIncludeIfNullFalse.field` will be ignored because '
        'a custom conversion function is being used.',
  ],
  configurations: ['default'],
)
@ChannelSerializable()
class ToJsonNullableFalseIncludeIfNullFalse {
  @JsonKey(toJson: _toString, includeIfNull: false, nullable: false)
  String field;
}

String _fromDynamicMap(Map input) => null;

String _fromDynamicList(List input) => null;

String _fromDynamicIterable(Iterable input) => null;

@ShouldGenerate(
  r'''
FromDynamicCollection _$FromDynamicCollectionFromJson(
    Map<String, dynamic> json) {
  return FromDynamicCollection()
    ..mapField = _fromDynamicMap(json['mapField'] as Map)
    ..listField = _fromDynamicList(json['listField'] as List)
    ..iterableField = _fromDynamicIterable(json['iterableField'] as List);
}
''',
  configurations: ['default'],
)
@ChannelSerializable()
class FromDynamicCollection {
  @JsonKey(fromJson: _fromDynamicMap)
  String mapField;
  @JsonKey(fromJson: _fromDynamicList)
  String listField;
  @JsonKey(fromJson: _fromDynamicIterable)
  String iterableField;
}

String _noArgs() => null;

@ShouldThrow(
  'Error with `@JsonKey` on `field`. The `fromJson` function '
  '`_noArgs` must have one positional paramater.',
  element: 'field',
)
@ChannelSerializable()
class BadNoArgs {
  @JsonKey(fromJson: _noArgs)
  String field;
}

String _twoArgs(a, b) => null;

@ShouldThrow(
  'Error with `@JsonKey` on `field`. The `fromJson` function '
  '`_twoArgs` must have one positional paramater.',
  element: 'field',
)
@ChannelSerializable()
class BadTwoRequiredPositional {
  @JsonKey(fromJson: _twoArgs)
  String field;
}

String _oneNamed({a}) => null;

@ShouldThrow(
  'Error with `@JsonKey` on `field`. The `fromJson` function '
  '`_oneNamed` must have one positional paramater.',
  element: 'field',
)
@ChannelSerializable()
class BadOneNamed {
  @JsonKey(fromJson: _oneNamed)
  String field;
}

String _oneNormalOnePositional(a, [b]) => null;

@ShouldGenerate("_oneNormalOnePositional(json['field'])", contains: true)
@ChannelSerializable()
class OkayOneNormalOptionalPositional {
  @JsonKey(fromJson: _oneNormalOnePositional)
  String field;
}

String _oneNormalOptionalNamed(a, {b}) => null;

@ShouldGenerate("_oneNormalOptionalNamed(json['field'])", contains: true)
@ChannelSerializable()
class OkayOneNormalOptionalNamed {
  @JsonKey(fromJson: _oneNormalOptionalNamed)
  String field;
}

String _onlyOptionalPositional([a, b]) => null;

@ShouldGenerate("_onlyOptionalPositional(json['field'])", contains: true)
@ChannelSerializable()
class OkayOnlyOptionalPositional {
  @JsonKey(fromJson: _onlyOptionalPositional)
  String field;
}
