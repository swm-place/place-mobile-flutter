import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class CourseInformationCard extends StatelessWidget {
  CourseInformationCard({
    required this.title,
    required this.content,
    Key? key
  }) : super(key: key);

  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300]
        ),
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: SectionTextStyle.labelMedium(Colors.grey[600]!),),
            const SizedBox(height: 2,),
            AutoSizeText(
              content,
              style: SectionTextStyle.sectionContent(Colors.black),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}