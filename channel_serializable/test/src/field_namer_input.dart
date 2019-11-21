part of '_channel_serializable_test_input.dart';

@ShouldGenerate(r'''
Map<String, dynamic> _$FieldNamerNoneToJson(FieldNamerNone instance) =>
    <String, dynamic>{
      'theField': instance.theField,
      'NAME_OVERRIDE': instance.nameOverride,
    };
''')
@ChannelSerializable(
  fieldRename: FieldRename.none,
)
class FieldNamerNone {
  String theField;

  @JsonKey(name: 'NAME_OVERRIDE')
  String nameOverride;
}

@ShouldGenerate(r'''
Map<String, dynamic> _$FieldNamerKebabToJson(FieldNamerKebab instance) =>
    <String, dynamic>{
      'the-field': instance.theField,
      'NAME_OVERRIDE': instance.nameOverride,
    };
''')
@ChannelSerializable(
  fieldRename: FieldRename.kebab,
)
class FieldNamerKebab {
  String theField;

  @JsonKey(name: 'NAME_OVERRIDE')
  String nameOverride;
}

@ShouldGenerate(r'''
Map<String, dynamic> _$FieldNamerPascalToJson(FieldNamerPascal instance) =>
    <String, dynamic>{
      'TheField': instance.theField,
      'NAME_OVERRIDE': instance.nameOverride,
    };
''')
@ChannelSerializable(
  fieldRename: FieldRename.pascal,
)
class FieldNamerPascal {
  String theField;

  @JsonKey(name: 'NAME_OVERRIDE')
  String nameOverride;
}

@ShouldGenerate(r'''
Map<String, dynamic> _$FieldNamerSnakeToJson(FieldNamerSnake instance) =>
    <String, dynamic>{
      'the_field': instance.theField,
      'NAME_OVERRIDE': instance.nameOverride,
    };
''')
@ChannelSerializable(
  fieldRename: FieldRename.snake,
)
class FieldNamerSnake {
  String theField;

  @JsonKey(name: 'NAME_OVERRIDE')
  String nameOverride;
}
