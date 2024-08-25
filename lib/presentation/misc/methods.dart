import 'package:flutter/material.dart';

Map<double, SizedBox> _verticalSpace = {};
Map<double, SizedBox> _horizontalSpace = {};

SizedBox verticalSpace(double height) {
  if (!_verticalSpace.containsKey(height)) {
    _verticalSpace[height] = SizedBox(
      height: height,
    );
  }

  return _verticalSpace[height]!;
}

SizedBox horizontalSpace(double width) {
  if (!_horizontalSpace.containsKey(width)) {
    _horizontalSpace[width] = SizedBox(
      width: width,
    );
  }

  return _horizontalSpace[width]!;
}
