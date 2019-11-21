[![Pub Package](https://img.shields.io/pub/v/channel_serializable.svg)](https://pub.dev/packages/channel_serializable)

Provides [Dart Build System] builders for handling JSON.

The builders generate code when they find members annotated with classes defined
in [package:channel_annotation].

- To generate to/from JSON code for a class, annotate it with
  `@ChannelSerializable`. You can provide arguments to `ChannelSerializable` to
  configure the generated code. You can also customize individual fields
  by annotating them with `@ChannelKey` and providing custom arguments.
  See the table below for details on the
  [annotation values](#annotation-values).

- To generate a Dart field with the contents of a file containing JSON, use the
  `JsonLiteral` annotation.

To configure your project for the latest released version of,
`channel_serializable` see the [example].

## Example

Given a library `example.dart` with an `Person` class annotated with
`@ChannelSerializable()`:

```dart
import 'package:channel_annotation/channel_annotation.dart';

part 'example.g.dart';

@ChannelSerializable(nullable: false)
class Person {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  Person({this.firstName, this.lastName, this.dateOfBirth});
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
```

Building creates the corresponding part `example.g.dart`:

```dart
part of 'example.dart';

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
    };
```

# Annotation values

The only annotation required to use this package is `@ChannelSerializable`. When
applied to a class (in a correctly configured package), `toJson` and `fromJson`
code will be generated when you build. There are three ways to control how code
is generated:

1. Set properties on `@ChannelSerializable`.
2. Add a `@ChannelKey` annotation to a field and set properties there.
3. Add configuration to `build.yaml` – [see below](#build-configuration). 

| `build.yaml` key           | ChannelSerializable                            | ChannelKey                     |
| -------------------------- | ------------------------------------------- | --------------------------- |
| any_map                    | [ChannelSerializable.anyMap]                   |                             |
| checked                    | [ChannelSerializable.checked]                  |                             |
| create_factory             | [ChannelSerializable.createFactory]            |                             |
| create_to_json             | [ChannelSerializable.createToJson]             |                             |
| disallow_unrecognized_keys | [ChannelSerializable.disallowUnrecognizedKeys] |                             |
| explicit_to_json           | [ChannelSerializable.explicitToJson]           |                             |
| field_rename               | [ChannelSerializable.fieldRename]              |                             |
| ignore_unannotated         | [ChannelSerializable.ignoreUnannotated]        |                             |
| include_if_null            | [ChannelSerializable.includeIfNull]            | [ChannelKey.includeIfNull]     |
| nullable                   | [ChannelSerializable.nullable]                 | [ChannelKey.nullable]          |
|                            |                                             | [ChannelKey.defaultValue]      |
|                            |                                             | [ChannelKey.disallowNullValue] |
|                            |                                             | [ChannelKey.fromJson]          |
|                            |                                             | [ChannelKey.ignore]            |
|                            |                                             | [ChannelKey.name]              |
|                            |                                             | [ChannelKey.required]          |
|                            |                                             | [ChannelKey.toJson]            |
|                            |                                             | [ChannelKey.unknownEnumValue]  |

[ChannelSerializable.anyMap]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/anyMap.html
[ChannelSerializable.checked]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/checked.html
[ChannelSerializable.createFactory]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/createFactory.html
[ChannelSerializable.createToJson]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/createToJson.html
[ChannelSerializable.disallowUnrecognizedKeys]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/disallowUnrecognizedKeys.html
[ChannelSerializable.explicitToJson]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/explicitToJson.html
[ChannelSerializable.fieldRename]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/fieldRename.html
[ChannelSerializable.ignoreUnannotated]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/ignoreUnannotated.html
[ChannelSerializable.includeIfNull]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/includeIfNull.html
[ChannelKey.includeIfNull]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/includeIfNull.html
[ChannelSerializable.nullable]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelSerializable/nullable.html
[ChannelKey.nullable]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/nullable.html
[ChannelKey.defaultValue]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/defaultValue.html
[ChannelKey.disallowNullValue]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/disallowNullValue.html
[ChannelKey.fromJson]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/fromJson.html
[ChannelKey.ignore]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/ignore.html
[ChannelKey.name]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/name.html
[ChannelKey.required]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/required.html
[ChannelKey.toJson]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/toJson.html
[ChannelKey.unknownEnumValue]: https://pub.dev/documentation/channel_annotation/latest/channel_annotation/ChannelKey/unknownEnumValue.html

> Note: every `ChannelSerializable` field is configurable via `build.yaml` –
  see the table for the corresponding key.
  If you find you want all or most of your classes with the same configuration,
  it may be easier to specify values once in the YAML file. Values set
  explicitly on `@ChannelSerializable` take precedence over settings in
  `build.yaml`.

> Note: There is some overlap between fields on `ChannelKey` and
  `ChannelSerializable`. In these cases, if a value is set explicitly via `ChannelKey`
  it will take precedence over any value set on `ChannelSerializable`.

# Build configuration

Besides setting arguments on the associated annotation classes, you can also
configure code generation by setting values in `build.yaml`.

```yaml
targets:
  $default:
    builders:
      channel_serializable:
        options:
          # Options configure how source code is generated for every
          # `@ChannelSerializable`-annotated class in the package.
          #
          # The default value for each is listed.
          any_map: false
          checked: false
          create_factory: true
          create_to_json: true
          disallow_unrecognized_keys: false
          explicit_to_json: false
          field_rename: none
          ignore_unannotated: false
          include_if_null: true
          nullable: true
```

[example]: https://github.com/dart-lang/channel_serializable/blob/master/example
[Dart Build System]: https://github.com/dart-lang/build
[package:channel_annotation]: https://pub.dev/packages/channel_annotation
