import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class TagChip extends StatelessWidget {
  TagChip({
    required this.text,
    this.backgroundColor=Colors.red,
    Key? key,
  }) : super(key: key);

  String text;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
        child: Text(
          text,
          style: placeTagText,
        ),
      ),
    );
  }
}