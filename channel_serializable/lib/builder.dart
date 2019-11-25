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
import 'package:source_gen/source_gen.dart';

import 'src/channel_part_builder.dart';
import 'src/generators/obj_c_generator.dart';

/// Supports `package:build_runner` creation and configuration of
/// `channel_serializable`.
///
/// Not meant to be invoked by hand-authored code.
Builder channelSerializable(BuilderOptions options) {
  final config = const ChannelSerializable().withDefaults();
  return channelPartBuilder(config: config);
}

Builder copyBuilder([_]) => LibraryBuilder(
      ObjCGenerator(),
      generatedExtension: '.g.h',
      formatOutput: (_) => _,
    );

/// A really simple [Builder], it just makes copies of .txt files!
class CopyBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.g.h']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
//    // Each `buildStep` has a single input.
//    final inputId = buildStep.inputId;
//
//    // Create a new target `AssetId` based on the old one.
//
//    final copy = inputId.changeExtension('.g.h');
//    final contents = await buildStep.readAsString(inputId);
//
//    // Write out the new asset.
//    await buildStep.writeAsString(copy, contents);
  }
}
