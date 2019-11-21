// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Configuration for using `package:build`-compatible build systems.
///
/// See:
/// * [build_runner](https://pub.dev/packages/build_runner)
///
/// This library is **not** intended to be imported by typical end-users unless
/// you are creating a custom compilation pipeline. See documentation for
/// details, and `build.yaml` for how these builders are configured by default.
library channel_serializable.builder;

import 'package:build/build.dart';
import 'package:channel_annotation/channel_annotation.dart';

import 'src/channel_part_builder.dart';

/// Supports `package:build_runner` creation and configuration of
/// `channel_serializable`.
///
/// Not meant to be invoked by hand-authored code.
Builder channelSerializable(BuilderOptions options) {
  final config = const ChannelSerializable().withDefaults();
  return channelPartBuilder(config: config);
}
