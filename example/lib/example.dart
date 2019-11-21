// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:channel_annotation/channel_annotation.dart';

part 'example.g.dart';

@ChannelSerializable()
class Person {
  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime dateOfBirth;
  final DateTime lastOrder;
  List<Order> orders;

  Person(this.firstName, this.lastName, this.dateOfBirth,
      {this.middleName, this.lastOrder, List<Order> orders})
      : orders = orders ?? <Order>[];

  factory Person.fromMap(Map<String, dynamic> json) => _$PersonFromMap(json);

  Map<String, dynamic> toMap() => _$PersonToMap(this);
}

@ChannelSerializable()
class Order {
  int count;
  int itemNumber;
  bool isRushed;
  Item item;
  Duration prepTime;
  final DateTime date;

  Order(this.date);

  factory Order.fromMap(Map<String, dynamic> map) => _$OrderFromMap(map);

  Map<String, dynamic> toMap() => _$OrderToMap(this);
}

@ChannelSerializable()
class Item {
  int count;
  int itemNumber;
  bool isRushed;

  Item();

  factory Item.fromMap(Map<String, dynamic> map) => _$ItemFromMap(map);

  Map<String, dynamic> toMap() => _$ItemToMap(this);
}
