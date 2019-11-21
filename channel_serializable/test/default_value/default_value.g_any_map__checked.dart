// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: annotate_overrides

import 'package:channel_annotation/channel_annotation.dart';

import 'default_value_interface.dart' as dvi hide Greek;
import 'default_value_interface.dart' show Greek;

part 'default_value.g_any_map__checked.g.dart';

const _intValue = 42;

dvi.DefaultValue fromJson(Map<String, dynamic> json) =>
    _$DefaultValueFromJson(json);

@ChannelSerializable(
  checked: true,
  anyMap: true,
)
class DefaultValue implements dvi.DefaultValue {
  @ChannelKey(defaultValue: true)
  bool fieldBool;

  @ChannelKey(defaultValue: 'string', includeIfNull: false)
  String fieldString;

  @ChannelKey(defaultValue: _intValue)
  int fieldInt;

  @ChannelKey(defaultValue: 3.14)
  double fieldDouble;

  @ChannelKey(defaultValue: [])
  List fieldListEmpty;

  @ChannelKey(defaultValue: {})
  Map fieldMapEmpty;

  @ChannelKey(defaultValue: [1, 2, 3])
  List<int> fieldListSimple;

  @ChannelKey(defaultValue: {'answer': 42})
  Map<String, int> fieldMapSimple;

  @ChannelKey(defaultValue: {
    'root': ['child']
  })
  Map<String, List<String>> fieldMapListString;

  @ChannelKey(defaultValue: Greek.beta)
  Greek fieldEnum;

  DefaultValue();

  factory DefaultValue.fromJson(Map<String, dynamic> json) =>
      _$DefaultValueFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultValueToJson(this);
}
