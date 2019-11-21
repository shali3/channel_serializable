part of '_channel_serializable_test_input.dart';

@ShouldThrow(
  r'''
Could not generate `fromJson` code for `mapView`.
None of the provided `TypeHelper` instances support the defined type.''',
  todo: 'Make sure all of the types are serializable.',
  element: 'mapView',
)
@ChannelSerializable()
class UnsupportedMapField {
  MapView mapView;
}

@ShouldThrow(
  r'''
Could not generate `fromJson` code for `listView`.
None of the provided `TypeHelper` instances support the defined type.''',
  todo: 'Make sure all of the types are serializable.',
  element: 'listView',
)
@ChannelSerializable()
class UnsupportedListField {
  UnmodifiableListView listView;
}

@ShouldThrow(
  r'''
Could not generate `fromJson` code for `customSet`.
None of the provided `TypeHelper` instances support the defined type.''',
  todo: 'Make sure all of the types are serializable.',
  element: 'customSet',
)
@ChannelSerializable()
class UnsupportedSetField {
  _CustomSet customSet;
}

abstract class _CustomSet implements Set {}

@ShouldThrow(
  r'''
Could not generate `fromJson` code for `customDuration`.
None of the provided `TypeHelper` instances support the defined type.''',
  todo: 'Make sure all of the types are serializable.',
  element: 'customDuration',
)
@ChannelSerializable()
class UnsupportedDurationField {
  _CustomDuration customDuration;
}

abstract class _CustomDuration implements Duration {}

@ShouldThrow(
  r'''
Could not generate `fromJson` code for `customUri`.
None of the provided `TypeHelper` instances support the defined type.''',
  todo: 'Make sure all of the types are serializable.',
  element: 'customUri',
)
@ChannelSerializable()
class UnsupportedUriField {
  _CustomUri customUri;
}

abstract class _CustomUri implements Uri {}

@ShouldThrow(
  r'''
Could not generate `fromJson` code for `customDateTime`.
None of the provided `TypeHelper` instances support the defined type.''',
  todo: 'Make sure all of the types are serializable.',
  element: 'customDateTime',
)
@ChannelSerializable()
class UnsupportedDateTimeField {
  _CustomDateTime customDateTime;
}

abstract class _CustomDateTime implements DateTime {}
