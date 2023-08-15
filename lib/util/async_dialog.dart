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

mixin AsyncOperationMixin<T extends StatefulWidget> on State<T> {
  Completer<void>? _asyncTaskCompleter;

  AlertDialog __createDialog(String message) => AlertDialog(
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
  );

  Future<void> performAsyncOperationWithDialog(
      Future<void> Function(Map<String, dynamic>) asyncTask,
      Map<String, dynamic> arguments,
      String message,
      bool closeDialog) async {
    _asyncTaskCompleter = Completer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => __createDialog(message),
    );

    await asyncTask(arguments);
    print("task finish");

    _asyncTaskCompleter!.complete();

    if (closeDialog) {
      if (mounted) {
        print('pop dialog');
        Navigator.pop(context);
        _asyncTaskCompleter = null;
      }
    } else {
      _asyncTaskCompleter = null;
    }
  }

  Future<void> performAsyncNoArgumentOperationWithDialog(
      Future<void> Function() asyncTask,
      String message,
      bool closeDialog) async {
    _asyncTaskCompleter = Completer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => __createDialog(message),
    );

    await asyncTask();

    _asyncTaskCompleter!.complete();

    if (closeDialog) {
      if (mounted) {
        print('pop dialog no argument');
        if (ModalRoute.of(context)?.isCurrent != true) Navigator.pop(context);
        _asyncTaskCompleter = null;
      }
    } else {
      _asyncTaskCompleter = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_asyncTaskCompleter != null && _asyncTaskCompleter!.isCompleted) {
      Navigator.pop(context);
      _asyncTaskCompleter = null;
    }
  }
}
