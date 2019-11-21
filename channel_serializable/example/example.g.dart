// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// ChannelSerializableGenerator
// **************************************************************************

Person _$PersonFromMap(Map<String, dynamic> map) {
  return Person(
    firstName: map['firstName'] as String,
    lastName: map['lastName'] as String,
    dateOfBirth: map['dateOfBirth'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
  );
}

Map<String, dynamic> _$PersonToMap(Person instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.millisecondsSinceEpoch,
    };
