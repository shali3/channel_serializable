// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// ChannelSerializableGenerator
// **************************************************************************

Person _$PersonFromMap(Map<String, dynamic> map) {
  return Person(
    map['firstName'] as String,
    map['lastName'] as String,
    map['dateOfBirth'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(map['dateOfBirth'] as int),
    middleName: map['middleName'] as String,
    lastOrder: map['lastOrder'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(map['lastOrder'] as int),
    orders: (map['orders'] as List)
        ?.map(
            (e) => e == null ? null : Order.fromMap(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PersonToMap(Person instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.microsecondsSinceEpoch,
      'lastOrder': instance.lastOrder?.microsecondsSinceEpoch,
      'orders': instance.orders?.map((e) => e.toMap())?.toList(),
    };

Order _$OrderFromMap(Map<String, dynamic> map) {
  return Order(
    map['date'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(map['date'] as int),
  )
    ..count = map['count'] as int
    ..itemNumber = map['itemNumber'] as int
    ..isRushed = map['isRushed'] as bool
    ..item = map['item'] == null
        ? null
        : Item.fromMap(map['item'] as Map<String, dynamic>)
    ..prepTime = map['prepTime'] == null
        ? null
        : Duration(microseconds: map['prepTime'] as int);
}

Map<String, dynamic> _$OrderToMap(Order instance) => <String, dynamic>{
      'count': instance.count,
      'itemNumber': instance.itemNumber,
      'isRushed': instance.isRushed,
      'item': instance.item.toMap(),
      'prepTime': instance.prepTime?.inMicroseconds,
      'date': instance.date?.microsecondsSinceEpoch,
    };

Item _$ItemFromMap(Map<String, dynamic> map) {
  return Item()
    ..count = map['count'] as int
    ..itemNumber = map['itemNumber'] as int
    ..isRushed = map['isRushed'] as bool;
}

Map<String, dynamic> _$ItemToMap(Item instance) => <String, dynamic>{
      'count': instance.count,
      'itemNumber': instance.itemNumber,
      'isRushed': instance.isRushed,
    };
