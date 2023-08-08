import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class TagChip extends StatelessWidget {
  TagChip({
    required this.text,
    this.backgroundColor=Colors.red,
    this.textStyle,
    this.padding=const EdgeInsets.fromLTRB(6, 4, 6, 4),
    Key? key,
  }) : super(key: key);

  String text;
  Color backgroundColor;
  TextStyle? textStyle;
  EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    textStyle ??= SectionTextStyle.labelSmall(Colors.white);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor
      ),
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}