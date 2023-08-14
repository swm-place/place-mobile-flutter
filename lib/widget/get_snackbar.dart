import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomGetSnackBar {
  static const int GET_SNACKBAR_DURATION_SHORT = 1;
  static const int GET_SNACKBAR_DURATION_MEDIUM = 2;
  static const int GET_SNACKBAR_DURATION_LONG = 4;
}

class SuccessGetSnackBar extends GetSnackBar {
  SuccessGetSnackBar({
    required this.title,
    required this.message,
    this.showDuration=CustomGetSnackBar.GET_SNACKBAR_DURATION_MEDIUM,
    Key? key
  }) : super(
    backgroundColor: Colors.blue,
    titleText: Text(title, style: TextStyle(color: Colors.white),),
    messageText: Text(message, style: TextStyle(color: Colors.white),),
    duration: Duration(seconds: showDuration),
    key: key
  );

  String title;
  String message;
  int showDuration;
}

class ErrorGetSnackBar extends GetSnackBar {
  ErrorGetSnackBar({
    required this.title,
    required this.message,
    this.showDuration=CustomGetSnackBar.GET_SNACKBAR_DURATION_MEDIUM,
    Key? key
  }) : super(
    backgroundColor: Colors.red,
    titleText: Text(title, style: TextStyle(color: Colors.white),),
    messageText: Text(message, style: TextStyle(color: Colors.white),),
    duration: Duration(seconds: showDuration),
    key: key
  );

  String title;
  String message;
  int showDuration;
}

class WarnGetSnackBar extends GetSnackBar {
  WarnGetSnackBar({
    required this.title,
    required this.message,
    this.showDuration=CustomGetSnackBar.GET_SNACKBAR_DURATION_MEDIUM,
    Key? key
  }) : super(
    backgroundColor: Colors.yellow,
    titleText: Text(title, style: TextStyle(color: Colors.white),),
    messageText: Text(message, style: TextStyle(color: Colors.white),),
    duration: Duration(seconds: showDuration),
    key: key
  );

  String title;
  String message;
  int showDuration;
}