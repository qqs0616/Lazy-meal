import 'package:flutter/material.dart';

///ListTitle
class ListTitleWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const ListTitleWidget({Key? key, this.title, this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        Text(subTitle ?? "",
            style: TextStyle(fontSize: 15, color: Colors.grey[600])),
      ],
    );
  }
}
