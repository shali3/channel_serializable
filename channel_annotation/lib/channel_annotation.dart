// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Provides annotation classes to use with
/// [channel_serializable](https://pub.dev/packages/channel_serializable).
///
/// Also contains helper functions and classes – prefixed with `$` used by
/// `channel_serializable` when the `use_wrappers` or `checked` options are
/// enabled.
library channel_annotation;

export 'src/channel_converter.dart';
export 'src/channel_key.dart';
export 'src/channel_serializable.dart';
