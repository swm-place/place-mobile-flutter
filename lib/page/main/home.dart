import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/magazine_provider.dart';
import 'package:place_mobile_flutter/api/provider/place_provider.dart';
import 'package:place_mobile_flutter/page/course/course_main.dart';
import 'package:place_mobile_flutter/page/magazine/magazine.dart';
import 'package:place_mobile_flutter/page/place/place_detail.dart';
import 'package:place_mobile_flutter/state/gis_controller.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_button.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';
import 'package:place_mobile_flutter/widget/story/story_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {

  final PlaceProvider _placeProvider = PlaceProvider();
  final MagazineProvider _magazineProvider = MagazineProvider();

  final List<Map<String, dynamic>> _recommendTagsData = [
    {'icon': Icons.add, 'title': 'test1', 'background': Colors.blue},
    {'icon': Icons.volume_mute, 'title': 'test2', 'background': Colors.red},
    {'icon': Icons.ac_unit, 'title': 'test3', 'background': Colors.grey},
    {'icon': Icons.add_a_photo, 'title': 'test4', 'background': Colors.amber},
    {'icon': Icons.account_balance_wallet, 'title': 'test5', 'background': Colors.cyan},
    {'icon': Icons.access_alarm, 'title': 'test6', 'background': Colors.orange},
    {'icon': Icons.accessibility, 'title': 'test7', 'background': Colors.pink},
  ];

  List<dynamic>? _magazineData = [];

  Map<String, dynamic>? _recommendData;

  int activeIndex = 0;

  int _loadRecommendData = -1;
  int _loadMagazineData = -1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _getPlaceRecommendationSection();
    _getMagazineSection();
    super.initState();
  }

  Widget __searchSection() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
    child: Column(
      children: [
        RoundedRectangleSearchBar(
          elevation: 2,
          borderRadius: 8,
          hintText: "장소/코스 검색",
          contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          onSuffixIconPressed: () {
            print("searchbar clicked");
          },
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: __createTag(),
        //     )
        //   ),
        // )
      ],
    ),
  );

  List<Widget> __createTag() {
    List<Widget> tags = [];
    for (int i = 0;i < _recommendTagsData.length;i++) {
      if (i > 0) tags.add(const SizedBox(width: 4,));
      tags.add(
          GestureDetector(
            child: TagChip(
              text: _recommendTagsData[i]['title'],
              // itemColor: Colors.white,
              backgroundColor: _recommendTagsData[i]['background'],
              textStyle: SectionTextStyle.labelMedium(Colors.white),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              // onPressed: () {
              //   print(_recommendTagsData[i]['title']);
              // },
            ),
            onTap: () {
              print(_recommendTagsData[i]['title']);
            },
          )
      );
    }
    return tags;
  }

  void _getMagazineSection() async {
    setState(() {
      _loadMagazineData = -1;
    });

    List<dynamic>? data = await _magazineProvider.getMagazineList();
    if (data == null) {
      _magazineData = null;
      setState(() {
        _loadMagazineData = 0;
      });
      return null;
    }

    for (int i = 0;i < data.length;i++) {
      String? imgUrl;
      if (data[i]['imgUrl'] != null) {
        imgUrl = ImageParser.parseImageUrl(data[i]['imgUrl']);
      }
      data[i]['imgUrl'] = imgUrl;
    }

    _magazineData = data;

    setState(() {
      _loadMagazineData = 1;
    });
  }

  Widget __magazineSection() {
    if (_loadMagazineData == 0) return Container();

    Widget body;
    if (_loadMagazineData == 1) {
      if (_magazineData == null) return Container();
      if (_magazineData!.isEmpty) return Container();

      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                  initialPage: 0,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  autoPlay: true,
                  aspectRatio: 16 / 8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }),
              itemCount: _magazineData!.length,
              itemBuilder: (context, index, realIndex) {
                return RoundedRectangleMagazineCard(
                  imageUrl: _magazineData![index]['imgUrl'],
                  title: _magazineData![index]['title'],
                  message: _magazineData![index]['contents'],
                  titleStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1,
                  ),
                  messageStyle: SectionTextStyle.sectionContent(Colors.white),
                  onTap: () {
                    Get.to(() => Magazine(
                      magazineId: _magazineData![index]['id'],
                      imageUrl: _magazineData![index]['imgUrl'],
                    ));
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: _magazineData!.length,
            effect: const JumpingDotEffect(dotHeight: 10, dotWidth: 10),
          )
        ],
      );
    } else {
      body = Shimmer.fromColors(
          baseColor: const Color.fromRGBO(240, 240, 240, 1),
          highlightColor: Colors.grey[300]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const AnimatedSmoothIndicator(
              activeIndex: 0,
              count: 3,
              effect: JumpingDotEffect(dotHeight: 10, dotWidth: 10),
            )
          ],
        )
      );
    }

    return SizedBox(
      width: double.infinity,
      child: MainSection(
        title: "매거진",
        // message: "마음에 드는 스토리를 찾아보세요",
        content: body,
      ),
    );
  }

  Widget __courseSection(Map<String, dynamic> data) => SizedBox(
    width: double.infinity,
    child: MainSection(
      title: data['title'],
      message: data["summary"],
      content: SizedBox(
        height: 160,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: data['courses'].length + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0 || index == data['courses'].length + 1) {
              return const SizedBox(width: 24,);
            } else {
              index -= 1;
              return RoundedRectangleMagazineCard(
                title: data['courses'][index]['title'],
                message: data['courses'][index]['message'],
                location: data['courses'][index]['location'],
                imageUrl: data['courses'][index]['background'],
                width: 250,
                height: 194,
                titleStyle: SectionTextStyle.lineContentExtraLarge(Colors.white),
                messageStyle: SectionTextStyle.labelMedium(Colors.white),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                onTap: () {
                  // Get.to(() => CourseMainPage());
                },
              );
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: 8,);
          },
        ),
      ),
    ),
  );

  Widget __recommendSection(Map<String, dynamic> data) {
    return SizedBox(
      width: double.infinity,
      child: MainSection(
          title: data['title'],
          message: data["summary"],
          content: SizedBox(
            height: 195,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: data['places'].length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 || index == data['places'].length + 1) {
                  return const SizedBox(width: 16,);
                } else {
                  index -= 1;
                  String? imgUrl;
                  if (data['places'][index]['photos'] != null && data['places'][index]['photos'].length > 0) {
                    imgUrl = ImageParser.parseImageUrl(data['places'][index]['photos'][0]['url']);
                  }

                  String? openString;
                  if (data['places'][index]['opening_hours'] != null) {
                    final now = DateTime.now();
                    final currentWeekday = now.weekday - 1;
                    final currentTime = int.parse(DateFormat('HHmm').format(now));

                    final currentDayHours = data['places'][index]['opening_hours'].firstWhere(
                          (hours) => hours["weekday"] == currentWeekday,
                      orElse: () => null,
                    );

                    if (currentDayHours != null) {
                      final openTime = currentDayHours["open"];
                      final closeTime = currentDayHours["close"];

                      if (currentTime >= openTime && currentTime <= closeTime) {
                        openString = '영업중';
                      } else {
                        openString = '영업중 아님';
                      }
                    }
                  }

                  return RoundedRectanglePlaceCard(
                    width: 250,
                    aspectRatio: 18/14,
                    tags: List<Map<String, dynamic>>.from(data["places"][index]['hashtags']),
                    // imageUrl: data["places"][index]['imageUrl'],
                    imageUrl: imgUrl,
                    placeName: data["places"][index]['name'],
                    placeType: data["places"][index]['category'],
                    distance: data["places"][index]['distance'] == null ?
                      null : UnitConverter.formatDistance(data["places"][index]['distance']),
                    // distance: UnitConverter.formatDistance(Random().nextInt(10000)),
                    // open: data["places"][index]['open'],
                    open: openString,
                    // likeCount: UnitConverter.formatNumber(data["places"][index]['likeCount']),
                    likeCount: UnitConverter.formatNumber(0),
                    onPressed: () {
                      print(data["places"][index]['id']);
                      Get.to(() => PlaceDetailPage(
                        placeId: data["places"][index]['id'],
                      ));
                    },
                  );
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 4,);
              },
            ),
          ),
      ),
    );
  }

  void _getPlaceRecommendationSection() async {
    setState(() {
      _loadRecommendData = -1;
    });
    Map<String, dynamic>? data = await _placeProvider.getPlaceRecommendNowSection();

    if (data == null) {
      _recommendData = null;
      setState(() {
        _loadRecommendData = 0;
      });
      return null;
    }

    for (int c = 0;c < data['collections'].length;c++) {
      for (int index = 0;index < data['collections'][c]["places"].length;index++) {
        for (int i = 0;i < data['collections'][c]["places"][index]['hashtags'].length;i++) {
          String name = data['collections'][c]["places"][index]['hashtags'][i];
          data['collections'][c]["places"][index]['hashtags'][i] = {
            "text": name,
            "color": RandomGenerator.generateRandomDarkHexColor()
          };
        }
        if (GISController.to.userPosition.value == null) {
          data['collections'][c]["places"][index]['distance'] = null;
        } else {
          double lat2 = data['collections'][c]["places"][index]['location']['lat'];
          double lon2 = data['collections'][c]["places"][index]['location']['lon'];
          data['collections'][c]["places"][index]['distance'] = GISController.to.haversineDistance(lat2, lon2);
        }
      }
    }
    _recommendData = data;
    setState(() {
      _loadRecommendData = 1;
    });
  }

  Widget _createRecommendShimmer() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 0.0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromRGBO(240, 240, 240, 1),
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 160,
                  height: 20,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.circular(40)
                  ),
                ),
                const SizedBox(
                    height: 6
                ),
                Container(
                  width: 119,
                  height: 20,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.circular(40)
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: 145,
                  height: 20,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.circular(40)
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _loadPlaceRecommendSection() {
    if (_loadRecommendData == 0) return Container();

    if (_loadRecommendData == 1) {
      if (_recommendData == null) return Container();
      if (_recommendData!.isEmpty) return Container();

      List<Widget> items = [];
      for (int i = 0;i < _recommendData!['collections'].length;i++) {
        items.add(__recommendSection(_recommendData!['collections'][i]));
        items.add(const SizedBox(height: 24,));
      }
      return Column(
        children: items,
      );
    } else {
      return Column(
        children: [
          Shimmer.fromColors(
            baseColor: const Color.fromRGBO(240, 240, 240, 1),
            highlightColor: Colors.grey[300]!,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 25,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(240, 240, 240, 1),
                        borderRadius: BorderRadius.circular(40)
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 195,
                    child: Row(
                      children: [
                        _createRecommendShimmer(),
                        const SizedBox(width: 16,),
                        _createRecommendShimmer(),
                        const SizedBox(width: 16,),
                        _createRecommendShimmer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  List<Widget> _createSection() {
    List<Widget> section = [
      // __searchSection(),
      // const SizedBox(height: 24,),
      __magazineSection(),
      const SizedBox(height: 24,)
    ];
    // section.addAll([
    //   __courseSection(_courseData),
    //   const SizedBox(height: 24,)
    // ]);
    section.add(_loadPlaceRecommendSection());
    // for (int i = 0;i < _recommendData.length;i++) {
    //   section.add(__recommendSection(_recommendData[i]));
    //   // section.add(const SizedBox(height: 24,));
    // }
    return section;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _getPlaceRecommendationSection();
            _getMagazineSection();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Column(
                children: _createSection(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}