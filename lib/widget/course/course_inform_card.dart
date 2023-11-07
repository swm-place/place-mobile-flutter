import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';

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
    required this.placesName,
    required this.placesImageUrls,
    required this.courseName,
    required this.regionName,
    required this.distance,
    required this.placeCount,
    this.width=double.infinity,
    this.height=double.infinity,
    Key? key
  }) : super(key: key);

  double width;
  double height;

  List<String> placesName = [];
  List<String> placesImageUrls = [];

  String courseName;
  String regionName;

  int distance;
  int placeCount;

  @override
  State<StatefulWidget> createState() => CourseListCardItemState();
}

class CourseListCardItemState extends State<CourseListCardItem> {

  late final PageController _pageController;
  String place = '';

  List<Widget> _generatePlaceImage() {
    List<Widget> images = [];
    for (int i = 0;i < widget.placesImageUrls.length;i++) {
      images.add(
        Image.network('$baseUrlDev${widget.placesImageUrls[i]}', fit: BoxFit.cover)
      );
    }
    return images;
  }

  bool visibleLeft = false;
  bool visibleRight = false;

  @override
  void initState() {
    place = widget.placesName[0];

    _pageController = PageController();
    _pageController.addListener(() {
      int now = _pageController.page!.round().toInt();
      if (now < 0) now = 0;
      if (now > 2) now = 2;
      setState(() {
        place = widget.placesName[now];
        visibleLeft = _pageController.page!.round() > 0;
        visibleRight = _pageController.page!.round() < 2;
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
                  IgnorePointer(
                    child: Container(
                      height: 130,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(17, 0, 12, 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: visibleLeft,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 20,
                                ),
                              ),
                              Visibility(
                                visible: visibleRight,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.courseName,
                    overflow: TextOverflow.ellipsis,
                    style: SectionTextStyle.sectionContentExtraLarge(Colors.black),
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(MdiIcons.mapMarkerOutline, size: 18, color: Colors.grey[700],),
                          Text(
                            widget.regionName,
                            style: SectionTextStyle.labelSmall(Colors.grey[700]!),
                          )
                        ],
                      ),
                      const SizedBox(width: 8,),
                      Row(
                        children: [
                          Icon(Icons.route, size: 18, color: Colors.grey[700]),
                          Text(
                            UnitConverter.formatDistance(widget.distance),
                            style: SectionTextStyle.labelSmall(Colors.grey[700]!),
                          )
                        ],
                      ),
                      const SizedBox(width: 8,),
                      Row(
                        children: [
                          Icon(Icons.signpost, size: 18, color: Colors.grey[700]),
                          Text(
                            '${widget.placeCount}곳',
                            style: SectionTextStyle.labelSmall(Colors.grey[700]!),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
