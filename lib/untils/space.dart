import 'package:flutter/material.dart';
///水平间距
class SpaceHorizontalWidget extends StatelessWidget {
  final double? space;

  const SpaceHorizontalWidget({Key? key, this.space}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space ?? 10,
    );
  }
}

///垂直间距
class SpaceVerticalWidget extends StatelessWidget {
  final double? space;

  const SpaceVerticalWidget({Key? key, this.space}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space ?? 10,
    );
  }
}
