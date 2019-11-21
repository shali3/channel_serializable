// Copyright (c) 2017, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:channel_annotation/channel_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'channel_serializable_generator.dart';

/// Returns a [Builder] for use within a `package:build_runner`
/// `BuildAction`.
///
/// [formatOutput] is called to format the generated code. If not provided,
/// the default Dart code formatter is used.
Builder channelPartBuilder(
        {String formatOutput(String code), ChannelSerializable config}) =>
    SharedPartBuilder([
      ChannelSerializableGenerator(config: config),
    ], 'channel_serializable', formatOutput: formatOutput);
