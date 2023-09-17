import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class CourseInformationCard extends StatelessWidget {
  const CourseInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300]
        ),
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('지역', style: SectionTextStyle.labelMedium(Colors.grey[600]!),),
            AutoSizeText('서울시 강남구', style: SectionTextStyle.sectionContent(Colors.black),),
          ],
        ),
      ),
    );
  }
}