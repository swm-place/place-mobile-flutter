import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin AsyncOperationMixin<T extends StatefulWidget> on State<T> {
  Completer<void>? _asyncTaskCompleter;

  Future<void> performAsyncOperationWithDialog(Future<void> Function(Map<String, dynamic>) asyncTask, Map<String, dynamic> arguments, String message) async {
    _asyncTaskCompleter = Completer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
          actionsPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 10),
              Text(message),
            ],
          ),
        );
      },
    );

    await asyncTask(arguments);
    print("task finish");

    _asyncTaskCompleter!.complete();

    if (mounted) {
      Navigator.pop(context);
      _asyncTaskCompleter = null;
    }
  }

  Future<void> performAsyncNoArgumentOperationWithDialog(Future<void> Function() asyncTask, String message) async {
    _asyncTaskCompleter = Completer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
          actionsPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 10),
              Text(message),
            ],
          ),
        );
      },
    );

    await asyncTask();

    _asyncTaskCompleter!.complete();

    if (mounted) {
      Navigator.pop(context);
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
