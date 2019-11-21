// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';
import 'package:source_gen_test/annotations.dart';

part 'checked_test_input.dart';
part 'core_subclass_type_input.dart';
part 'default_value_input.dart';
part 'field_namer_input.dart';
part 'generic_test_input.dart';
part 'inheritance_test_input.dart';
part 'json_converter_test_input.dart';
part 'map_key_variety_test_input.dart';
part 'setter_test_input.dart';
part 'to_from_json_test_input.dart';
part 'unknown_enum_value_test_input.dart';art';

part 'unknown_type_test_input.dart';

@ShouldThrow('Generator cannot target `theAnswer`.',
    todo: 'Remove the ChannelSerializable annotation from `theAnswer`.')
@ChannelSerializable()
const theAnswer = 42;

@ShouldThrow('Generator cannot target `annotatedMethod`.',
    todo: 'Remove the ChannelSerializable annotation from `annotatedMethod`.')
@ChannelSerializable()
void annotatedMethod() => null;

@ShouldGenerate(
  r'''
OnlyStaticMembers _$OnlyStaticMembersFromJson(Map<String, dynamic> json) {
  return OnlyStaticMembers();
}

Map<String, dynamic> _$OnlyStaticMembersToJson(OnlyStaticMembers instance) =>
    <String, dynamic>{};
''',
  configurations: ['default'],
)
@ChannelSerializable()
class OnlyStaticMembers {
  // To ensure static members are not considered for serialization.
  static const answer = 42;
  static final reason = 42;

  static int get understand => 42;
}

@ShouldGenerate(r'''
GeneralTestClass1 _$GeneralTestClass1FromJson(Map<String, dynamic> json) {
  return GeneralTestClass1()
    ..firstName = json['firstName'] as String
    ..lastName = json['lastName'] as String
    ..height = json['h'] as int
    ..dateOfBirth = json['dateOfBirth'] == null
        ? null
        : DateTime.parse(json['dateOfBirth'] as String)
    ..dynamicType = json['dynamicType']
    ..varType = json['varType']
    ..listOfInts = (json['listOfInts'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$GeneralTestClass1ToJson(GeneralTestClass1 instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'h': instance.height,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'dynamicType': instance.dynamicType,
      'varType': instance.varType,
      'listOfInts': instance.listOfInts,
    };
''')
@ChannelSerializable()
class GeneralTestClass1 {
  String firstName, lastName;
  @JsonKey(name: 'h')
  int height;
  DateTime dateOfBirth;
  dynamic dynamicType;

  //ignore: prefer_typing_uninitialized_variables
  var varType;
  List<int> listOfInts;
}

@ShouldGenerate(r'''
GeneralTestClass2 _$GeneralTestClass2FromJson(Map<String, dynamic> json) {
  return GeneralTestClass2(
    json['height'] as int,
    json['firstName'] as String,
    json['lastName'] as String,
  )..dateOfBirth = json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String);
}

Map<String, dynamic> _$GeneralTestClass2ToJson(GeneralTestClass2 instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'height': instance.height,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };
''')
@ChannelSerializable()
class GeneralTestClass2 {
  final String firstName, lastName;
  int height;
  DateTime dateOfBirth;

  GeneralTestClass2(this.height, String firstName, [this.lastName])
      :
        // ignore: prefer_initializing_formals
        firstName = firstName;
}

@ShouldGenerate(r'''
FinalFields _$FinalFieldsFromJson(Map<String, dynamic> json) {
  return FinalFields(
    json['a'] as int,
  );
}

Map<String, dynamic> _$FinalFieldsToJson(FinalFields instance) =>
    <String, dynamic>{
      'a': instance.a,
    };
''')
@ChannelSerializable()
class FinalFields {
  final int a;

  int get b => 4;

  FinalFields(this.a);
}

@ShouldGenerate(
  r'''
FinalFieldsNotSetInCtor _$FinalFieldsNotSetInCtorFromJson(
    Map<String, dynamic> json) {
  return FinalFieldsNotSetInCtor();
}

Map<String, dynamic> _$FinalFieldsNotSetInCtorToJson(
        FinalFieldsNotSetInCtor instance) =>
    <String, dynamic>{};
''',
  configurations: ['default'],
)
@ChannelSerializable()
class FinalFieldsNotSetInCtor {
  final int a = 1;

  FinalFieldsNotSetInCtor();
}

@ShouldGenerate(r'''
SetSupport _$SetSupportFromJson(Map<String, dynamic> json) {
  return SetSupport(
    (json['values'] as List)?.map((e) => e as int)?.toSet(),
  );
}

Map<String, dynamic> _$SetSupportToJson(SetSupport instance) =>
    <String, dynamic>{
      'values': instance.values?.toList(),
    };
''')
@ChannelSerializable()
class SetSupport {
  final Set<int> values;

  SetSupport(this.values);
}

@ShouldThrow(
  'Could not generate `toJson` code for `watch`.\n'
  'None of the provided `TypeHelper` instances support the defined type.',
  configurations: ['default'],
)
@ChannelSerializable()
class NoSerializeFieldType {
  Stopwatch watch;
}

@ShouldThrow(
  'Could not generate `fromJson` code for `watch`.\n'
  'None of the provided `TypeHelper` instances support the defined type.',
  configurations: ['default'],
)
@ChannelSerializable()
class NoDeserializeFieldType {
  Stopwatch watch;
}

@ShouldThrow(
  '''
Could not generate `toJson` code for `durationDateTimeMap` because of type `Duration`.
Map keys must be one of: Object, dynamic, enum, String, BigInt, DateTime, int, Uri.''',
  configurations: ['default'],
)
@ChannelSerializable()
class NoSerializeBadKey {
  Map<Duration, DateTime> durationDateTimeMap;
}

@ShouldThrow(
  '''
Could not generate `fromJson` code for `durationDateTimeMap` because of type `Duration`.
Map keys must be one of: Object, dynamic, enum, String, BigInt, DateTime, int, Uri.''',
  configurations: ['default'],
)
@ChannelSerializable()
class NoDeserializeBadKey {
  Map<Duration, DateTime> durationDateTimeMap;
}

@ShouldGenerate(
  r'''
Map<String, dynamic> _$IncludeIfNullOverrideToJson(
    IncludeIfNullOverride instance) {
  final val = <String, dynamic>{
    'number': instance.number,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('str', instance.str);
  return val;
}
''',
  configurations: ['default'],
)
@ChannelSerializable(, includeIfNull: false)
class IncludeIfNullOverride {
  @JsonKey(includeIfNull: true)
  int number;
  String str;
}

// https://github.com/dart-lang/channel_serializable/issues/7 regression
@ShouldThrow(
  'The class `NoCtorClass` has no default constructor.',
  configurations: ['default'],
)
@ChannelSerializable()
class NoCtorClass {
  final int member;

  //ignore: avoid_unused_constructor_parameters
  factory NoCtorClass.fromJson(Map<String, dynamic> json) => null;
}

@ShouldThrow(
  'More than one field has the JSON key `str`.',
  todo: 'Check the `JsonKey` annotations on fields.',
  element: 'str',
)
@ChannelSerializable()
class KeyDupesField {
  @JsonKey(name: 'str')
  int number;

  String str;
}

@ShouldThrow(
  'More than one field has the JSON key `a`.',
  todo: 'Check the `JsonKey` annotations on fields.',
  element: 'str',
)
@ChannelSerializable()
class DupeKeys {
  @JsonKey(name: 'a')
  int number;

  @JsonKey(name: 'a')
  String str;
}

@ShouldGenerate(r'''
Map<String, dynamic> _$IgnoredFieldClassToJson(IgnoredFieldClass instance) =>
    <String, dynamic>{
      'ignoredFalseField': instance.ignoredFalseField,
      'ignoredNullField': instance.ignoredNullField,
    };
''')
@ChannelSerializable()
class IgnoredFieldClass {
  @JsonKey(ignore: true)
  int ignoredTrueField;

  @JsonKey(ignore: false)
  int ignoredFalseField;

  int ignoredNullField;
}

@ShouldThrow(
  'Cannot populate the required constructor argument: '
  'ignoredTrueField. It is assigned to an ignored field.',
  element: '',
)
@ChannelSerializable()
class IgnoredFieldCtorClass {
  @JsonKey(ignore: true)
  int ignoredTrueField;

  IgnoredFieldCtorClass(this.ignoredTrueField);
}

@ShouldThrow(
  'Cannot populate the required constructor argument: '
  '_privateField. It is assigned to a private field.',
  element: '',
)
@ChannelSerializable()
class PrivateFieldCtorClass {
  // ignore: unused_field
  final int _privateField;

  PrivateFieldCtorClass(this._privateField);
}

@ShouldThrow(
  'Error with `@JsonKey` on `field`. '
  'Cannot set both `disallowNullvalue` and `includeIfNull` to `true`. '
  'This leads to incompatible `toJson` and `fromJson` behavior.',
  element: 'field',
)
@ChannelSerializable()
class IncludeIfNullDisallowNullClass {
  @JsonKey(includeIfNull: true, disallowNullValue: true)
  int field;
}

@ShouldThrow(
  'The `JsonValue` annotation on `BadEnum.value` does not have a value '
  'of type String, int, or null.',
  element: 'value',
)
@ChannelSerializable()
class JsonValueWithBool {
  BadEnum field;
}

enum BadEnum {
  @JsonValue(true)
  value
}

@ShouldGenerate(r'''const _$GoodEnumEnumMap = {
  GoodEnum.noAnnotation: 'noAnnotation',
  GoodEnum.stringAnnotation: 'string annotation',
  GoodEnum.stringAnnotationWeird: r"string annotation with $ funky 'values'",
  GoodEnum.intValue: 42,
  GoodEnum.nullValue: null,
};
''', contains: true)
@ChannelSerializable()
class JsonValueValid {
  GoodEnum field;
}

enum GoodEnum {
  noAnnotation,
  @JsonValue('string annotation')
  stringAnnotation,
  @JsonValue("string annotation with \$ funky 'values'")
  stringAnnotationWeird,
  @JsonValue(42)
  intValue,
  @JsonValue(null)
  nullValue
}

@ShouldGenerate(r'''
FieldWithFromJsonCtorAndTypeParams _$FieldWithFromJsonCtorAndTypeParamsFromJson(
    Map<String, dynamic> json) {
  return FieldWithFromJsonCtorAndTypeParams()
    ..customOrders = json['customOrders'] == null
        ? null
        : MyList.fromJson((json['customOrders'] as List)
            ?.map((e) => e == null
                ? null
                : GeneralTestClass2.fromJson(e as Map<String, dynamic>))
            ?.toList());
}
''')
@ChannelSerializable()
class FieldWithFromJsonCtorAndTypeParams {
  MyList<GeneralTestClass2, int> customOrders;
}

class MyList<T, Q> extends ListBase<T> {
  final List<T> _data;

  MyList(Iterable<T> source) : _data = source.toList() ?? [];

  factory MyList.fromJson(List<T> items) => MyList(items);

  @override
  int get length => _data.length;

  @override
  set length(int value) {
    _data.length = value;
  }

  @override
  T operator [](int index) => _data[index];

  @override
  void operator []=(int index, T value) {
    _data[index] = value;
  }
}

mixin _PropInMixinI448RegressionMixin {
  @JsonKey(nullable: true)
  int nullable;
}

@ShouldGenerate(r'''
PropInMixinI448Regression _$PropInMixinI448RegressionFromJson(
    Map<String, dynamic> json) {
  return PropInMixinI448Regression()
    ..nullable = json['nullable'] as int
    ..notNullable = json['notNullable'] as int;
}

Map<String, dynamic> _$PropInMixinI448RegressionToJson(
        PropInMixinI448Regression instance) =>
    <String, dynamic>{
      'nullable': instance.nullable,
      'notNullable': instance.notNullable,
    };
''')
@ChannelSerializable()
class PropInMixinI448Regression with _PropInMixinI448RegressionMixin {
  @JsonKey(nullable: false)
  int notNullable;
}

@ShouldGenerate(
  r'''
IgnoreUnannotated _$IgnoreUnannotatedFromJson(Map<String, dynamic> json) {
  return IgnoreUnannotated()..annotated = json['annotated'] as int;
}

Map<String, dynamic> _$IgnoreUnannotatedToJson(IgnoreUnannotated instance) =>
    <String, dynamic>{
      'annotated': instance.annotated,
    };
''',
)
@ChannelSerializable(ignoreUnannotated: true)
class IgnoreUnannotated {
  @JsonKey()
  int annotated;

  int unannotated;
}
