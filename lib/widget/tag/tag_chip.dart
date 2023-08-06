import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class TagChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.red
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
        child: Text(
          "배고파",
          style: placeTagText,
          // textAlign: TextAlign.center,
        ),
      ),
    );
  }
}