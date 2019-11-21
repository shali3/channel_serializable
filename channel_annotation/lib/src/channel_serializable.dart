// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An annotation used to specify a class to generate code for.
class ChannelSerializable {
  /// If `true` (the default), a private, static `_$ExampleFromJson` method
  /// is created in the generated part file.
  ///
  /// Call this method from a factory constructor added to the source class:
  ///
  /// ```dart
  /// @ChannelSerializable()
  /// class Example {
  ///   // ...
  ///   factory Example.fromJson(Map<String, dynamic> json) =>
  ///     _$ExampleFromJson(json);
  /// }
  /// ```
  final bool createFactory;

  /// When `true`, only fields annotated with [ChannelKey] will have code
  /// generated.
  ///
  /// It will have the same effect as if those fields had been annotated with
  /// `@ChannelKey(ignore: true)`.
  final bool ignoreUnannotated;

  /// Creates a new [ChannelSerializable] instance.
  const ChannelSerializable({
    this.createFactory,
    this.ignoreUnannotated,
  });

  /// An instance of [ChannelSerializable] with all fields set to their default
  /// values.
  static const defaults = ChannelSerializable(
    createFactory: true,
    ignoreUnannotated: false,
  );

  /// Returns a new [ChannelSerializable] instance with fields equal to the
  /// corresponding values in `this`, if not `null`.
  ///
  /// Otherwise, the returned value has the default value as defined in
  /// [defaults].
  ChannelSerializable withDefaults() => ChannelSerializable(
        createFactory: createFactory ?? defaults.createFactory,
        ignoreUnannotated: ignoreUnannotated ?? defaults.ignoreUnannotated,
      );
}
