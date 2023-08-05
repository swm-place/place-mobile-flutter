import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/tag/tag_button.dart';
import 'package:place_mobile_flutter/widget/tag/tag_search_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  final GlobalKey _tagSection = GlobalKey();

  final List<Widget> _recommendTags = [];

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

  Widget __searchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          TagSearchBar(
            elevation: 2,
            borderRadius: 8,
            hintText: "장소/코스 검색",
            contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            onSuffixIconPressed: () {
              print("searchbar clicked");
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
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
  }

  Widget _storyCarouselItem(String imageUrl, String location, String title, String message) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: GestureDetector(
      onTap: () => {
        print("$title, $message, $location")
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(imageUrl, fit: BoxFit.cover,),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromARGB(102, 1, 1, 1),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      location,
                      style: storyLocation,
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          title,
                          style: storyTitle,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                            message,
                            style: storyMessage
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget __storySection() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
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
                    return _storyCarouselItem(
                        _storyData[index]['background'],
                        _storyData[index]['location'],
                        _storyData[index]['title'],
                        _storyData[index]['message']
                    );
                  },
                ),
              ),
              SizedBox(height: 8,),
              AnimatedSmoothIndicator(
                activeIndex: activeIndex,
                count: _storyData.length,
                effect: JumpingDotEffect(
                  dotHeight: 10,
                  dotWidth: 10
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              __searchSection(),
              __storySection()
            ],
          ),
        ),
      ),
    );
  }
}