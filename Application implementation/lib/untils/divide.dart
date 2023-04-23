import 'package:flutter/material.dart';
import 'package:food_app/common/constant.dart';

///自定义
class DuDivide extends StatelessWidget {
  final double? height;

  const DuDivide({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      width: double.infinity,
      height: height ?? padding,
    );
  }
}
