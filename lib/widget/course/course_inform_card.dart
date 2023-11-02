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

class CourseListCardItem extends StatefulWidget {
  CourseListCardItem({
    this.width=double.infinity,
    this.height=double.infinity,
    Key? key
  }) : super(key: key);

  double width;
  double height;

  @override
  State<StatefulWidget> createState() => CourseListCardItemState();
}

class CourseListCardItemState extends State<CourseListCardItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      // height: widget.height,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        surfaceTintColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 130,
              child: PageView(
                children: [
                  Image.network('https://source.unsplash.com/random?sig=1', fit: BoxFit.cover,),
                  Image.network('https://source.unsplash.com/random?sig=2', fit: BoxFit.cover),
                  Image.network('https://source.unsplash.com/random?sig=3', fit: BoxFit.cover),
                ],
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '코스 이름',
                    overflow: TextOverflow.ellipsis,
                    style: SectionTextStyle.sectionContentExtraLarge(Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
