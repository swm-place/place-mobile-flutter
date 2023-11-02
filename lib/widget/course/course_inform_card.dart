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

  late final PageController _pageController;

  List<String> placeName = ['장소1', '장소2', '장소3'];
  String place = '';

  List<Widget> _generatePlaceImage() {
    List<Widget> images = [];
    for (int i = 0;i < 3;i++) {
      images.add(
        Image.network('https://source.unsplash.com/random?sig=$i', fit: BoxFit.cover)
      );
    }
    return images;
  }

  @override
  void initState() {
    place = placeName[0];

    _pageController = PageController();
    _pageController.addListener(() {
      int now = _pageController.page!.round().toInt();
      if (now < 0) now = 0;
      if (now > 2) now = 2;
      setState(() {
        place = placeName[now];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
              child: Stack(
                children: [
                  SizedBox(
                    height: 130,
                    child: PageView(
                      controller: _pageController,
                      children: _generatePlaceImage(),
                    ),
                  ),
                  IgnorePointer(
                    child: Container(
                      height: 130,
                      color: const Color.fromARGB(102, 1, 1, 1),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                place,
                                style: SectionTextStyle.sectionContent(Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
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
