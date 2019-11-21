import 'package:channel_annotation/channel_annotation.dart';

@ChannelSerializable()
class ConfigurationImplicitDefaults {
  int field;
}

@ChannelSerializable(
  createFactory: true,
  ignoreUnannotated: false,
)
class ConfigurationExplicitDefaults {
  int field;
}

@ChannelSerializable()
class IncludeIfNullAll {
  @ChannelKey(includeIfNull: true)
  int number;
  String str;
}

@ChannelSerializable()
class FromJsonOptionalParameters {
  final ChildWithFromJson child;

  FromJsonOptionalParameters(this.child);
}

class ChildWithFromJson {
  //ignore: avoid_unused_constructor_parameters
  ChildWithFromJson.fromJson(json, {initValue = false});
}

@ChannelSerializable()
class ParentObject {
  int number;
  String str;
  ChildObject child;
}

@ChannelSerializable()
class ChildObject {
  int number;
  String str;
}

@ChannelSerializable()
class ParentObjectWithChildren {
  int number;
  String str;
  List<ChildObject> children;
}

@ChannelSerializable()
class ParentObjectWithDynamicChildren {
  int number;
  String str;
  List<dynamic> children;
}

@ChannelSerializable(, explicitToJson: true)
class TrivialNestedNullable {
  TrivialNestedNullable child;
  int otherField;
}

@ChannelSerializable(
    , nullable: false, explicitToJson: true)
class TrivialNestedNonNullable {
  TrivialNestedNonNullable child;
  int otherField;
}
