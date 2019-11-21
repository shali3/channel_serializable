// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:channel_annotation/channel_annotation.dart';

part 'generic_class.g.dart';

@ChannelSerializable()
class GenericClass<T extends num, S> {
  @ChannelKey(fromJson: _dataFromJson, toJson: _dataToJson)
  Object fieldObject;

  @ChannelKey(fromJson: _dataFromJson, toJson: _dataToJson)
  dynamic fieldDynamic;

  @ChannelKey(fromJson: _dataFromJson, toJson: _dataToJson)
  int fieldInt;

  @ChannelKey(fromJson: _dataFromJson, toJson: _dataToJson)
  T fieldT;

  @ChannelKey(fromJson: _dataFromJson, toJson: _dataToJson)
  S fieldS;

  GenericClass();

  factory GenericClass.fromJson(Map<String, dynamic> json) =>
      _$GenericClassFromJson<T, S>(json);

  Map<String, dynamic> toJson() => _$GenericClassToJson(this);

  static T _dataFromJson<T, S, U>(Map<String, dynamic> input,
          [S other1, U other2]) =>
      input['value'] as T;

  static Map<String, dynamic> _dataToJson<T, S, U>(T input,
          [S other1, U other2]) =>
      {'value': input};
}

@ChannelSerializable()
@_DurationMillisecondConverter()
@_DurationListMillisecondConverter()
class GenericClassWithConverter<T extends num, S> {
  @_SimpleConverter()
  Object fieldObject;

  @_SimpleConverter()
  dynamic fieldDynamic;

  @_SimpleConverter()
  int fieldInt;

  @_SimpleConverter()
  T fieldT;

  @_SimpleConverter()
  S fieldS;

  Duration duration;

  List<Duration> listDuration;

  GenericClassWithConverter();

  factory GenericClassWithConverter.fromJson(Map<String, dynamic> json) =>
      _$GenericClassWithConverterFromJson<T, S>(json);

  Map<String, dynamic> toJson() => _$GenericClassWithConverterToJson(this);
}

class _SimpleConverter<T> implements ChannelConverter<T, Map<String, dynamic>> {
  const _SimpleConverter();

  @override
  T fromJson(Map<String, dynamic> json) => json['value'] as T;

  @override
  Map<String, dynamic> toJson(T object) => {'value': object};
}

class _DurationMillisecondConverter implements ChannelConverter<Duration, int> {
  const _DurationMillisecondConverter();

  const _DurationMillisecondConverter.named();

  @override
  Duration fromJson(int json) =>
      json == null ? null : Duration(milliseconds: json);

  @override
  int toJson(Duration object) => object?.inMilliseconds;
}

class _DurationListMillisecondConverter
    implements ChannelConverter<List<Duration>, int> {
  const _DurationListMillisecondConverter();

  @override
  List<Duration> fromJson(int json) => [Duration(milliseconds: json)];

  @override
  int toJson(List<Duration> object) => object?.fold<int>(0, (sum, obj) {
        return sum + obj.inMilliseconds;
      });
}
