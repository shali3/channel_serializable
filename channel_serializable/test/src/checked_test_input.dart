part of '_channel_serializable_test_input.dart';

@ShouldGenerate(r'''
WithANonCtorGetterChecked _$WithANonCtorGetterCheckedFromJson(
    Map<String, dynamic> json) {
  return $checkedNew('WithANonCtorGetterChecked', json, () {
    $checkKeys(json,
        allowedKeys: const ['items'],
        requiredKeys: const ['items'],
        disallowNullValues: const ['items']);
    final val = WithANonCtorGetterChecked(
      $checkedConvert(
          json, 'items', (v) => (v as List)?.map((e) => e as String)?.toList()),
    );
    return val;
  });
}
''')
@ChannelSerializable(
  disallowUnrecognizedKeys: true,
  checked: true,
)
class WithANonCtorGetterChecked {
  @JsonKey(required: true, disallowNullValue: true)
  final List<String> items;

  int get length => items.length;

  WithANonCtorGetterChecked(this.items);
}

@ShouldGenerate(r'''
WithANonCtorGetter _$WithANonCtorGetterFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      allowedKeys: const ['items'],
      requiredKeys: const ['items'],
      disallowNullValues: const ['items']);
  return WithANonCtorGetter(
    (json['items'] as List)?.map((e) => e as String)?.toList(),
  );
}
''')
@ChannelSerializable(disallowUnrecognizedKeys: true)
class WithANonCtorGetter {
  @JsonKey(required: true, disallowNullValue: true)
  final List<String> items;

  int get length => items.length;

  WithANonCtorGetter(this.items);
}
