import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future toastInfo(
    {required String msg,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black}) async {
  // EasyLoading.instance
  //   ..backgroundColor = backgroundColor
  //   ..textColor = textColor;

  return await EasyLoading.showToast(
    msg,
    toastPosition: EasyLoadingToastPosition.bottom,
  );
}
