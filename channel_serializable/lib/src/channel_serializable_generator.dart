// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:channel_annotation/channel_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'decode_helper.dart';
import 'encoder_helper.dart';
import 'field_helpers.dart';
import 'helper_core.dart';
import 'type_helper.dart';
import 'type_helpers/big_int_helper.dart';
import 'type_helpers/channel_serializable_types_helper.dart';
import 'type_helpers/convert_helper.dart';
import 'type_helpers/date_time_helper.dart';
import 'type_helpers/duration_helper.dart';
import 'type_helpers/enum_helper.dart';
import 'type_helpers/iterable_helper.dart';
import 'type_helpers/json_converter_helper.dart';
import 'type_helpers/map_helper.dart';
import 'type_helpers/uri_helper.dart';
import 'type_helpers/value_helper.dart';
import 'utils.dart';

class ChannelSerializableGenerator
    extends GeneratorForAnnotation<ChannelSerializable> {
  static const _coreHelpers = <TypeHelper>[
    IterableHelper(),
    MapHelper(),
    EnumHelper(),
    ValueHelper(),
  ];

  static const _defaultHelpers = <TypeHelper>[
    BigIntHelper(),
    DateTimeHelper(),
    DurationHelper(),
    ChannelSerializableTypesHelper(),
    UriHelper(),
  ];

  final List<TypeHelper> _typeHelpers;

  Iterable<TypeHelper> get _allHelpers => const <TypeHelper>[
        ConvertHelper(),
        JsonConverterHelper()
      ].followedBy(_typeHelpers).followedBy(_coreHelpers);

  final ChannelSerializable _config;

  ChannelSerializable get config => _config.withDefaults();

  /// Creates an instance of [ChannelSerializableGenerator].
  ///
  /// If [typeHelpers] is not provided, the built-in helpers are used:
  /// [BigIntHelper], [DateTimeHelper], [DurationHelper], [ChannelSerializableTypesHelper], and
  /// [UriHelper].
  const ChannelSerializableGenerator({
    ChannelSerializable config,
    List<TypeHelper> typeHelpers,
  })  : _config = config ?? ChannelSerializable.defaults,
        _typeHelpers = typeHelpers ?? _defaultHelpers;

  /// Creates an instance of [ChannelSerializableGenerator].
  ///
  /// [typeHelpers] provides a set of [TypeHelper] that will be used along with
  /// the built-in helpers:
  /// [BigIntHelper], [DateTimeHelper], [DurationHelper], [ChannelSerializableTypesHelper], and
  /// [UriHelper].
  factory ChannelSerializableGenerator.withDefaultHelpers(
          Iterable<TypeHelper> typeHelpers,
          {ChannelSerializable config}) =>
      ChannelSerializableGenerator(
          config: config,
          typeHelpers:
              List.unmodifiable(typeHelpers.followedBy(_defaultHelpers)));

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
}

class _GeneratorHelper extends HelperCore with EncodeHelper, DecodeHelper {
  final ChannelSerializableGenerator _generator;
  final _addedMembers = <String>{};

  _GeneratorHelper(
      this._generator, ClassElement element, ConstantReader annotation)
      : super(element, mergeConfig(_generator.config, annotation));

  @override
  void addMember(String memberContent) {
    _addedMembers.add(memberContent);
  }

  @override
  Iterable<TypeHelper> get allTypeHelpers => _generator._allHelpers;

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
    if (config.createFactory) {
      final createResult = createFactory(accessibleFields, unavailableReasons);
      yield createResult.output;

      accessibleFieldSet = accessibleFields.entries
          .where((e) => createResult.usedFields.contains(e.key))
          .map((e) => e.value)
          .toSet();
    }

    yield* createToMap(accessibleFieldSet);

    yield* _addedMembers;
  }
}
