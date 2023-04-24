import 'package:flutter/material.dart';

import '../untils/index.dart';

///popMenu封装
class PopMenuWidget extends StatelessWidget {
  final List<PopupMenuItem>? items;
  final PopupMenuItemSelected? onSelected;
  final Icon icon;
  final String title;
  final String? initialValue;

  const PopMenuWidget(
      {Key? key,
      this.items,
      this.onSelected,
      required this.icon,
      required this.title,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: initialValue,
      offset: const Offset(0, 10),
      position: PopupMenuPosition.under,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return items ?? [];
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SpaceHorizontalWidget(
            space: 5,
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
