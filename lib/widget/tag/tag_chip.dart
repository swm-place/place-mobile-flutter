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
        padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
        child: Text(
          "ssss",
          style: placeTagText,
        ),
      ),
    );
  }
}