import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ProgressDialogState {
  show, hide
}

class ProgressDialogHelper {
  ProgressDialogState _progressDialogStatus = ProgressDialogState.hide;

  void showProgressDialog(String message) {
    _progressDialogStatus = ProgressDialogState.show;
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
    _progressDialogStatus = ProgressDialogState.hide;
    Get.back();
  }

  ProgressDialogState dialogState() {
    return _progressDialogStatus;
  }
}
