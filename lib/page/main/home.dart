import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/api/provider/place_provider.dart';
import 'package:place_mobile_flutter/page/place/place_detail.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_button.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';
import 'package:place_mobile_flutter/widget/story/story_card.dart';
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
  final GlobalKey _tagSection = GlobalKey();

  final List<Widget> _recommendTags = [];

  final PlaceProvider _placeProvider = PlaceProvider();

  final List<Map<String, dynamic>> _recommendTagsData = [
    {'icon': Icons.add, 'title': 'test1', 'background': Colors.blue},
    {'icon': Icons.volume_mute, 'title': 'test2', 'background': Colors.red},
    {'icon': Icons.ac_unit, 'title': 'test3', 'background': Colors.grey},
    {'icon': Icons.add_a_photo, 'title': 'test4', 'background': Colors.amber},
    {'icon': Icons.account_balance_wallet, 'title': 'test5', 'background': Colors.cyan},
    {'icon': Icons.access_alarm, 'title': 'test6', 'background': Colors.orange},
    {'icon': Icons.accessibility, 'title': 'test7', 'background': Colors.pink},
  ];

  final List<Map<String, dynamic>> _storyData = [
    {
      'background': "https://images.unsplash.com/photo-1495567720989-cebdbdd97913?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2370&q=80",
      'title': '감성여행',
      'message': '바쁜 일상에 지친 마음을 회복',
      'location': '대부도, 안산'
    },
    {
      'background': "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2560&q=80",
      'title': '피톤치드',
      'message': '도심에서는 느낄수 없는 맑은 공기',
      'location': '사려니 숲길, 제주도'
    },
    {
      'background': "https://images.unsplash.com/photo-1548115184-bc6544d06a58?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2370&q=80",
      'title': '전통',
      'message': '한국의 전통적인 아름다움',
      'location': '한옥마을, 전주'
    },
  ];

  Map<String, dynamic>? _recommendData;
  // List<Map<String, dynamic>>? _recommendData = [
    // {
    //   "title": "연인과 함께",
    //   "summary": "데이트 장소 추천",
    //   "places": [
    //     {
    //       "imageUrl": "https://images.unsplash.com/photo-1619536095378-c96a5639ccc5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2370&q=80",
    //       "placeName": "소마카페",
    //       "placeType": "카페",
    //       "distance": 2930,
    //       "open": "영업중",
    //       "likeCount": 13924,
    //       "tags": [
    //         {"text": "조용한", "color": "#3232a8"},
    //         {"text": "넓은", "color": "#326da8"},
    //       ]
    //     },
    //     {
    //       "imageUrl": "https://images.unsplash.com/photo-1508737804141-4c3b688e2546?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=986&q=80",
    //       "placeName": "소마 디저트",
    //       "placeType": "디저트",
    //       "distance": 892,
    //       "open": "영업중",
    //       "likeCount": 55,
    //       "tags": [
    //         {"text": "조용한", "color": "#3232a8"},
    //         {"text": "넓은", "color": "#326da8"},
    //       ]
    //     },
    //     {
    //       "imageUrl": "https://images.unsplash.com/photo-1518998053901-5348d3961a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2274&q=80",
    //       "placeName": "소마 전시",
    //       "placeType": "전시회",
    //       "distance": 34567,
    //       "open": "영업종료",
    //       "likeCount": 22935,
    //       "tags": [
    //         {"text": "조용한", "color": "#3232a8"},
    //         {"text": "넓은", "color": "#326da8"},
    //       ]
    //     },
    //   ]
    // }
  // ];

  int activeIndex = 0;

  @override
  bool get wantKeepAlive => true;

  void __createTagSection() {
    final RenderBox tagRow = _tagSection.currentContext!.findRenderObject() as RenderBox;
    final double tagCount = tagRow.size.width / 75;
    for (int i = 0;i < tagCount;i++) {
      _recommendTags.add(
        RoundedRectangleTagButton(
          width: 60,
          height: 60,
          text: _recommendTagsData[i]['title'],
          icon: _recommendTagsData[i]['icon'],
          itemColor: Colors.white,
          backgroundColor: _recommendTagsData[i]['background'],
          onPressed: () {
            print(_recommendTagsData[i]['title']);
          },
        )
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        __createTagSection();
      });
    });
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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: Container(
            key: _tagSection,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _recommendTags,
            ),
          ),
        )
      ],
    ),
  );

  Widget __storySection() => SizedBox(
    width: double.infinity,
    child: MainSection(
      title: "스토리",
      message: "마음에 드는 스토리를 찾아보세요",
      content: Column(
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
                  aspectRatio: 16/8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }
              ),
              itemCount: _storyData.length,
              itemBuilder: (context, index, realIndex) {
                return RoundedRectangleStoryCard(
                    imageUrl: _storyData[index]['background'],
                    location: _storyData[index]['location'],
                    title: _storyData[index]['title'],
                    message: _storyData[index]['message']
                );
              },
            ),
          ),
          const SizedBox(height: 8,),
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: _storyData.length,
            effect: const JumpingDotEffect(
                dotHeight: 10,
                dotWidth: 10
            ),
          )
        ],
      ),
    ),
  );

  Widget __recommendSection(Map<String, dynamic> data) {
    for (int index = 0;index < data["places"].length;index++) {
      for (int i = 0;i < data["places"][index]['hashtags'].length;i++) {
        String name = data["places"][index]['hashtags'][i];
        data["places"][index]['hashtags'][i] = {
          "text": name,
          "color": RandomGenerator.generateRandomDarkHexColor()
        };
      }
    }
    return SizedBox(
      width: double.infinity,
      child: MainSection(
          title: data['title'],
          message: data["summary"],
          content: SizedBox(
            height: 195,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: data['places'].length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 || index == data['places'].length + 1) {
                  return const SizedBox(width: 24,);
                } else {
                  index -= 1;
                  return RoundedRectanglePlaceCard(
                    width: 250,
                    aspectRatio: 18/14,
                    tags: List<Map<String, dynamic>>.from(data["places"][index]['hashtags']),
                    // imageUrl: data["places"][index]['imageUrl'],
                    imageUrl: 'https://source.unsplash.com/random?seq=$index',
                    placeName: data["places"][index]['name'],
                    placeType: data["places"][index]['category'],
                    // distance: UnitConverter.formatDistance(data["places"][index]['distance']),
                    distance: UnitConverter.formatDistance(Random().nextInt(10000)),
                    // open: data["places"][index]['open'],
                    open: Random().nextBool() ? '영업중' : '영업종료',
                    // likeCount: UnitConverter.formatNumber(data["places"][index]['likeCount']),
                    likeCount: UnitConverter.formatNumber(Random().nextInt(1000000)),
                    onPressed: () {
                      Get.to(() => PlaceDetailPage(

                      ));
                    },
                  );
                }
              },
            ),
          ),
      ),
    );
  }

  Widget _loadPlaceRecommendSection() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _placeProvider.getPlaceRecommendSection(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Widget> items = [];
          _recommendData = snapshot.data;
          if (_recommendData != null) {
            for (int i = 0;i < _recommendData!['collections'].length;i++) {
              items.add(__recommendSection(_recommendData!['collections'][i]));
              items.add(const SizedBox(height: 24,));
            }
            return Column(
              children: items,
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  List<Widget> _createSection() {
    List<Widget> section = [
      __searchSection(),
      const SizedBox(height: 24,),
      // __storySection(),
      // const SizedBox(height: 24,)
    ];
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: Column(
              children: _createSection(),
            ),
          ),
        ),
      ),
    );
  }
}