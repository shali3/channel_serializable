// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: hash_and_equals
import 'dart:collection';

import 'package:channel_annotation/channel_annotation.dart';

import 'json_test_common.dart';

part 'json_test_example.g_non_nullable.g.dart';

@ChannelSerializable(
  nullable: false,
)
class Person {
  final String firstName, middleName, lastName;
  final DateTime dateOfBirth;
  @ChannelKey(name: '\$house')
  final Category house;

  Order order;

  MyList<Order> customOrders;

  Map<String, Category> houseMap;
  Map<Category, int> categoryCounts;

  Person(this.firstName, this.lastName, this.house,
      {this.middleName, this.dateOfBirth});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Person &&
      firstName == other.firstName &&
      middleName == other.middleName &&
      lastName == other.lastName &&
      dateOfBirth == other.dateOfBirth &&
      house == other.house &&
      deepEquals(houseMap, other.houseMap);
}

@ChannelSerializable(
  nullable: false,
)
class Order {
  /// Used to test that `disallowNullValues: true` forces `includeIfNull: false`
  @ChannelKey(disallowNullValue: true)
  int count;
  bool isRushed;

  Duration duration;

  @ChannelKey(nullable: false)
  final Category category;
  final UnmodifiableListView<Item> items;
  Platform platform;
  Map<String, Platform> altPlatforms;

  Uri homepage;

  @ChannelKey(
    name: 'status_code',
    defaultValue: StatusCode.success,
    nullable: true,
    unknownEnumValue: StatusCode.unknown,
  )
  StatusCode statusCode;

  @ChannelKey(ignore: true)
  String get platformValue => platform?.description;

  set platformValue(String value) {
    throw UnimplementedError('not impld');
  }

  // Ignored getter without value set in ctor
  int get price => items.fold(0, (total, item) => item.price + total);

  @ChannelKey(ignore: true)
  bool shouldBeCached;

  Order(this.category, [Iterable<Item> items])
      : items = UnmodifiableListView<Item>(
            List<Item>.unmodifiable(items ?? const <Item>[]));

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Order &&
      count == other.count &&
      isRushed == other.isRushed &&
      deepEquals(items, other.items) &&
      deepEquals(altPlatforms, other.altPlatforms);
}

@ChannelSerializable(
  nullable: false,
)
class Item extends ItemCore {
  @ChannelKey(includeIfNull: false, name: 'item-number')
  int itemNumber;
  List<DateTime> saleDates;
  List<int> rates;

  Item([int price]) : super(price);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Item &&
      price == other.price &&
      itemNumber == other.itemNumber &&
      deepEquals(saleDates, other.saleDates);
}

@ChannelSerializable(
  nullable: false,
)
class Numbers {
  List<int> ints;
  List<num> nums;
  List<double> doubles;

  @ChannelKey(nullable: false)
  List<double> nnDoubles;

  @ChannelKey(fromJson: durationFromInt, toJson: durationToInt)
  Duration duration;

  @ChannelKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime date;

  Numbers();

  factory Numbers.fromJson(Map<String, dynamic> json) =>
      _$NumbersFromJson(json);

  Map<String, dynamic> toJson() => _$NumbersToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Numbers &&
      deepEquals(ints, other.ints) &&
      deepEquals(nums, other.nums) &&
      deepEquals(doubles, other.doubles) &&
      deepEquals(nnDoubles, other.nnDoubles) &&
      deepEquals(duration, other.duration) &&
      deepEquals(date, other.date);
}

@ChannelSerializable(
  nullable: false,
)
class MapKeyVariety {
  Map<int, int> intIntMap;
  Map<Uri, int> uriIntMap;
  Map<DateTime, int> dateTimeIntMap;
  Map<BigInt, int> bigIntMap;

  MapKeyVariety();

  factory MapKeyVariety.fromJson(Map<String, dynamic> json) =>
      _$MapKeyVarietyFromJson(json);

  Map<String, dynamic> toJson() => _$MapKeyVarietyToJson(this);

  @override
  bool operator ==(Object other) =>
      other is MapKeyVariety &&
      deepEquals(other.intIntMap, intIntMap) &&
      deepEquals(other.uriIntMap, uriIntMap) &&
      deepEquals(other.dateTimeIntMap, dateTimeIntMap) &&
      deepEquals(other.bigIntMap, bigIntMap);
}
