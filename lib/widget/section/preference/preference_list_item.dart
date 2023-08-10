import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class PreferenceItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text("설정이름", style: SectionTextStyle.sectionContentLine(Colors.black),),
          ),
          SizedBox(
            width: 24,
            height: 24,
            child: Ink(
              child: InkWell(
                child: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          )
        ],
      ),
    );
  }
}