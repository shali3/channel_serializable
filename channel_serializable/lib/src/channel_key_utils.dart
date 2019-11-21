// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:channel_annotation/channel_annotation.dart';

import 'utils.dart';

final _channelKeyExpando = Expando<ChannelKey>();

ChannelKey channelKeyForField(
        FieldElement field, ChannelSerializable classAnnotation) =>
    _channelKeyExpando[field] ??= _from(field, classAnnotation);

ChannelKey _from(FieldElement element, ChannelSerializable classAnnotation) {
  final obj = channelKeyAnnotation(element);

  if (obj == null) {
    return _populateChannelKey(
      ignore: classAnnotation.ignoreUnannotated,
    );
  }

  return _populateChannelKey(
    ignore: obj.getField('ignore').toBoolValue(),
  );
}

ChannelKey _populateChannelKey({
  bool ignore,
}) {
  final channelKey = ChannelKey(
    ignore: ignore ?? false,
  );

  return channelKey;
}
