import 'package:flutter/material.dart';

import '../common/index.dart';

///带选择器的图片
class CheckPlanWidget extends StatelessWidget {
  final String src;
  final GestureTapCallback? onTap;
  final bool isCheck;

  const CheckPlanWidget(
      {Key? key, required this.src, this.onTap, this.isCheck = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(padding * 2),
          child: Image.network(
            src,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: padding,
          top: padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: InkWell(
              onTap: onTap,
              child: Icon(
                Icons.done,
                size: 25,
                color: isCheck ? Colors.red : Colors.grey,
              ),
            ),
          ),
        )
      ],
    );
  }
}