import 'package:flutter/material.dart';

import '../common/index.dart';
import '../untils/index.dart';

///气泡
class AirBubbleWidget extends StatelessWidget {
  final Icon icon;
  final String title;

  const AirBubbleWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: padding, vertical: padding / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: AirBubbleItemWidget(
        icon: icon,
        title: title,
      ),
    );
  }
}

///气泡子项
class AirBubbleItemWidget extends StatelessWidget {
  final Icon icon;
  final String title;

  const AirBubbleItemWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SpaceHorizontalWidget(
          space: 3,
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
