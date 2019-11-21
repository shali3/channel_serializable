// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An annotation used to specify how a field is serialized.
class ChannelKey {
  /// `true` if the generator should ignore this field completely.
  ///
  /// If `null` (the default) or `false`, the field will be considered for
  /// serialization.
  final bool ignore;

  /// Creates a new [ChannelKey] instance.
  ///
  /// Only required when the default behavior is not desired.
  const ChannelKey({
    this.ignore,
  });
}
