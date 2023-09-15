import 'dart:io';

import 'package:flutter/material.dart';

class FlexibleTopBarActionButton extends StatelessWidget {
  final Function() onPressed;

  FlexibleTopBarActionButton({
    required this.onPressed,
    required this.icon,
    this.width = 32,
    this.height = 32,
    this.iconSize = 18,
    this.backgroundColor = Colors.white,
    this.iconPadding = EdgeInsets.zero,
    Key? key
  }) : super(key: key);

  double width;
  double height;
  double iconSize;
  Color backgroundColor;

  EdgeInsets iconPadding;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Padding(
          padding: iconPadding,
          child: icon,
        ),
      ),
    );
  }
}