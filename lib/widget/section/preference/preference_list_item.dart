import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class PreferenceItem extends StatelessWidget {
  PreferenceItem({
    required this.title,
    this.textColor=Colors.black,
    this.showIcon=true,
    Key? key,
  }) : super(key: key);

  String title;
  Color textColor;
  bool showIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("object");
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: SectionTextStyle.sectionContent(textColor),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: showIcon ? Icon(Icons.keyboard_arrow_right) : null,
            )
          ],
        ),
      ),
    );
  }
}