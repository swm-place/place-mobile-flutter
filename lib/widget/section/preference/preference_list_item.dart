import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class PreferenceItem extends StatelessWidget {
  final Function() onTap;

  PreferenceItem({
    required this.title,
    required this.onTap,
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
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
              child: showIcon ? const Icon(Icons.keyboard_arrow_right) : null,
            )
          ],
        ),
      ),
    );
  }
}