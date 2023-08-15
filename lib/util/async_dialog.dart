import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialogHelper {
  void showProgressDialog(String message) {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
        actionsPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 24),
            Text(message),
          ],
        ),
      )
    );
  }

  void hideProgressDialog() {
    Get.back();
  }
}
