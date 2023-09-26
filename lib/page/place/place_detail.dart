import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/page/course/course_main.dart';
import 'package:place_mobile_flutter/page/magazine/magazine.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:place_mobile_flutter/widget/place/review/place_review.dart';

import 'dart:math' as math;

import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/section/topbar/picture_flexible.dart';
import 'package:place_mobile_flutter/widget/section/topbar/topbar_flexible_button.dart';
import 'package:place_mobile_flutter/widget/story/story_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlaceDetailPageState();
  }
}

class _PlaceDetailPageState extends State<PlaceDetailPage> with TickerProviderStateMixin {
  late final AnimationController _likeButtonController;
  late final AnimationController _bookmarkButtonController;

  late final TextEditingController _bookmarkNameController;

  late ScrollController _bookmarkScrollController;
  late ScrollController _commentScrollController;

  bool likePlace = false;
  bool bookmarkPlace = false;

  bool isTimeOpen = false;

  String? _bookmarkNameError;

  int? commentSortKey = 0;

  final List<Map<String, dynamic>> _commentData = [
    {
     "name": "민준",
     "date": "2023-08-05T14:29:20.725Z",
     "comment": "사려니 숲길은 제주도 여행의 필수 코스! 자연의 아름다움을 느낄 수 있어요.",
     "profileUrl": "https://source.unsplash.com/random",
     "likeCount": 3254546,
     "likeComment": false,
    },
    {
     "name": "Ethan",
     "date": "2023-08-04T14:29:20.725Z",
     "comment": "여행 중 가장 기억에 남는 곳이었어요. 특히 아침 일찍 방문해서 조용한 분위기를 느끼는 것을 추천합니다.",
     "profileUrl": "https://source.unsplash.com/random",
     "likeCount": 42355,
     "likeComment": true,
    },
    {
     "name": "Emma",
     "date": "2023-07-30T14:29:20.725Z",
     "comment": "가족과 함께 방문했는데, 아이들도 너무 좋아했어요. 자연과 함께하는 시간이 너무 소중했습니다.",
     "profileUrl": "https://source.unsplash.com/random",
     "likeCount": 534,
     "likeComment": false,
    },
    {
     "name": "예은",
     "date": "2023-07-26T14:29:20.725Z",
     "comment": "비오는 날은 미끄러울 수 있으니 조심하세요. 그래도 뷰는 최고!",
     "profileUrl": "https://source.unsplash.com/random",
     "likeCount": 356578,
     "likeComment": false,
    },
    {
     "name": "sdsfsfdsdcvb",
     "date": "2023-08-05T14:29:20.725Z",
     "comment": "사afddasfgsgsg! 자연의 아sgsfsdafds어요.",
     "profileUrl": "https://source.unsplash.com/random",
     "likeCount": 3254546,
     "likeComment": false,
    },
    {
     "name": "fsdgfvsgrw",
     "date": "2023-08-04T14:29:20.725Z",
     "comment": "여행adfadf남는 곳이었어요. 특히 sffeqfaf것을 추천합니다.",
     "profileUrl": "https://source.unsplash.com/random",
     "likeCount": 42355,
     "likeComment": true,
    },
    {
     "name": "rwgw4rgdsg",
     "date": "2023-07-30T14:29:20.725Z",
     "comment": "가dasdfsgsrgh너무 소중했습니다.",
     "profileUrl": "https://source.unsplash.com/random",
     "likeCount": 534,
     "likeComment": false,
    },
    {
     "name": "adsasra",
     "date": "2023-07-26T14:29:20.725Z",
     "comment": "asdefcfsfs",
     "profileUrl": "https://source.unsplash.com/random",
     "likeCount": 356578,
     "likeComment": false,
    },
  ];

  final List<Map<String, dynamic>> _relevantPlaceData = [
    {
      "imageUrl": "https://images.unsplash.com/photo-1619536095378-c96a5639ccc5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2370&q=80",
      "placeName": "소마카페",
      "placeType": "카페",
      "distance": 2930,
      "open": "영업중",
      "likeCount": 13924,
      "tags": [
        {"text": "조용한", "color": "#3232a8"},
        {"text": "넓은", "color": "#326da8"},
      ]
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1508737804141-4c3b688e2546?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=986&q=80",
      "placeName": "소마 디저트",
      "placeType": "디저트",
      "distance": 892,
      "open": "영업중",
      "likeCount": 55,
      "tags": [
        {"text": "조용한", "color": "#3232a8"},
        {"text": "넓은", "color": "#326da8"},
      ]
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1518998053901-5348d3961a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2274&q=80",
      "placeName": "소마 전시",
      "placeType": "전시회",
      "distance": 34567,
      "open": "영업종료",
      "likeCount": 22935,
      "tags": [
        {"text": "조용한", "color": "#3232a8"},
        {"text": "넓은", "color": "#326da8"},
      ]
    },
  ];

  final List<Map<String, dynamic>> _relevanceStoryData = [
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

  final List<Map<String, dynamic>> _bookmarkData = [
    {"name": "북마크", "include": true},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": true},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": true},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": true},
    {"name": "북마크", "include": true},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": true},
    {"name": "북마크", "include": true},
    {"name": "북마크", "include": true},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": false},
    {"name": "북마크", "include": false},
  ];

  @override
  void initState() {
    _likeButtonController = AnimationController(vsync: this);
    _bookmarkButtonController = AnimationController(vsync: this);
    _bookmarkScrollController = ScrollController();
    _commentScrollController = ScrollController();
    _bookmarkNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _likeButtonController.dispose();
    _bookmarkButtonController.dispose();
    _bookmarkScrollController.dispose();
    _commentScrollController.dispose();
    _bookmarkNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent
    // ));
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // print(constraints.maxWidth);
          double commentHeight = 58640 / (constraints.maxWidth - 96);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: FlexibleTopBarActionButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                    size: 18,
                  ),
                  iconPadding: Platform.isAndroid ? EdgeInsets.zero : const EdgeInsets.fromLTRB(6, 0, 0, 0),
                ),
                actions: [
                  FlexibleTopBarActionButton(
                      onPressed: () {

                      },
                      icon: Icon(Icons.ios_share, size: 18,)
                  )
                ],
                pinned: true,
                expandedHeight: 220.0,
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                flexibleSpace: const PictureFlexibleSpace(),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _detailHead(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Text(
                      "장소에 대한 소개글입니다 장소에대한 소개글입니다 장소에대한 소개글입니다",
                      style: SectionTextStyle.sectionContentLargeLine(Colors.black),
                    ),
                  ),
                  _detailInform(),
                  _detailReview(commentHeight),
                  _detailPicture(),
                  _detailRelevantPlace(),
                  _detailRelevantStory(),
                  SizedBox(height: 24,)
                ]),
              )
            ],
          );
        },
      )
    );
  }

  Widget _detailHead() => Padding(
    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "사려니 숲길",
                  style: PageTextStyle.headlineExtraLarge(Colors.black),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  TagChip(
                    text: "#자연",
                    textStyle: SectionTextStyle.labelMediumThick(Colors.white),
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                  ),
                  SizedBox(width: 4,),
                  TagChip(
                    text: "#자연",
                    textStyle: SectionTextStyle.labelMediumThick(Colors.white),
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                  ),
                  SizedBox(width: 4,),
                  TagChip(
                    text: "#자연",
                    textStyle: SectionTextStyle.labelMediumThick(Colors.white),
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                  ),
                ],
              )
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                __showBookmarkSelectionSheet();
                setState(() {
                  HapticFeedback.lightImpact();
                  bookmarkPlace = !bookmarkPlace;
                  if (bookmarkPlace) {
                    _bookmarkButtonController.animateTo(1);
                  } else {
                    _bookmarkButtonController.animateBack(0);
                  }
                });
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(4, 10, 4, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: 24,
                      // height: 24,
                      child: Lottie.asset(
                          "assets/lottie/animation_bookmark.json",
                          repeat: false,
                          reverse: false,
                          width: 24,
                          height: 24,
                          controller: _bookmarkButtonController,
                          onLoaded: (conposition) {
                            _bookmarkButtonController.duration = conposition.duration;
                            if (bookmarkPlace) {
                              _bookmarkButtonController.animateTo(1);
                            } else {
                              _bookmarkButtonController.animateBack(0);
                            }
                          }
                      ),
                    ),
                    Text("븍마크")
                  ],
                ),
              ),
            ),
            SizedBox(width: 12,),
            GestureDetector(
              onTap: () {
                setState(() {
                  HapticFeedback.lightImpact();
                  likePlace = !likePlace;
                  if (likePlace) {
                    _likeButtonController.animateTo(1);
                  } else {
                    _likeButtonController.animateBack(0);
                  }
                });
              },
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: 24,
                      // height: 24,
                      child: Lottie.asset(
                          "assets/lottie/animation_like_button.json",
                          repeat: false,
                          reverse: false,
                          width: 28,
                          height: 28,
                          controller: _likeButtonController,
                          onLoaded: (conposition) {
                            _likeButtonController.duration = conposition.duration;
                            if (likePlace) {
                              _likeButtonController.animateTo(1);
                            } else {
                              _likeButtonController.animateBack(0);
                            }
                          }
                      ),
                    ),
                    Text("1.2K")
                  ],
                ),
              ),
            )
          ],
        )
      ],
    ),
  );

  Widget _detailInform() => Padding(
    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
    child: MainSection(
      title: '정보',
      action: TextButton.icon(
        onPressed: () {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: 'our.email@gmail.com',
            query: 'subject=[오류제보] {장소이름} 정보 오류 제보&body=오류 내용: '
          );
          launchUrl(emailLaunchUri);
        },
        label: Text("오류 신고"),
        icon: Icon(MdiIcons.alertOctagon, size: 20,),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(30, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            iconColor: Colors.red,
            surfaceTintColor: Colors.red,
            foregroundColor: Colors.red
        ),
      ),
      content: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(MdiIcons.mapMarkerOutline, color: Colors.grey[700], size: 24,),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4,),
                      Text(
                        "제주 제주시 봉개동 산 64-5",
                        style: SectionTextStyle.sectionContent(Colors.black),
                      ),
                      Row(
                        children: [
                          Text("지번"),
                          SizedBox(width: 4,),
                          Text("제주 제주시 봉개동 산 64-5")
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 8,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(MdiIcons.clockOutline, color: Colors.grey[700], size: 24,),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4,),
                      Ink(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isTimeOpen = !isTimeOpen;
                              });
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "현재 운영중",
                                        style: SectionTextStyle.sectionContentLarge(Colors.green),
                                      ),
                                      Text("최근 1시간 동안 5명이 운영중이 아니라고 제보"),
                                      GestureDetector(
                                        child: Text("운영중 오류 제보하기"),
                                        onTap: () {
                                          __showTimeReportDialog();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                AnimatedCrossFade(
                                  duration: Duration(milliseconds: 250),
                                  crossFadeState: isTimeOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  firstChild: Icon(Icons.keyboard_arrow_down),
                                  secondChild: Icon(Icons.keyboard_arrow_up),
                                )
                              ],
                            ),
                          )
                      ),
                      AnimatedSize(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          child: Container(
                            height: isTimeOpen ? null : 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("월 10:00~22:00"),
                                Text("화 10:00~22:00"),
                                Text("수 10:00~22:00"),
                                Text("목 10:00~22:00"),
                                Text("금 10:00~22:00"),
                                Text("토 휴무"),
                                Text("일 휴무"),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 8,),
            GestureDetector(
              onTap: () {
                print("call");
                launchUrlString("tel:010-0000-0000");
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MdiIcons.phone, color: Colors.grey[700], size: 24,),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4,),
                        Text(
                          "010-0000-0000",
                          style: SectionTextStyle.sectionContent(Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    ),
  );

  Widget _detailReview(double commentHeight) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
        title: "한줄평",
        action: Ink(
          child: InkWell(
            onTap: () {
              __showCommentSheet(commentHeight);
            },
            child: Text(
              "더보기 (100)",
              style: SectionTextStyle.labelMedium(Colors.blue),
            ),
          ),
        ),
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: SizedBox(
            width: double.infinity,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                initialPage: 0,
                autoPlay: false,
                enableInfiniteScroll: false,
                height: commentHeight,
              ),
              itemCount: _commentData.length,
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                  child: ShortPlaceReviewCard(
                    vsync: this,
                    name: _commentData[index]['name'],
                    comment: _commentData[index]['comment'],
                    profileUrl: _commentData[index]['profileUrl'],
                    date: _commentData[index]['date'].split('T')[0].replaceAll('-', '.'),
                    likeComment: _commentData[index]['likeComment'],
                    likeCount: UnitConverter.formatNumber(_commentData[index]['likeCount']),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> __createImageTile() {
    List<Widget> tiles = [];
    for (int i = 0;i < 8;i++) {
      tiles.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://source.unsplash.com/random?sig=$i',
            fit: BoxFit.cover,
          ),
        )
      );
    }
    return tiles;
  }

  Widget _detailPicture() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
      child: MainSection(
        title: '사진',
        action: Ink(
          child: InkWell(
            onTap: () {
              __showPhotoSheet();
            },
            child: Text(
              "더보기 (100)",
              style: SectionTextStyle.labelMedium(Colors.blue),
            ),
          ),
        ),
        content: Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: GridView.custom(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverQuiltedGridDelegate(
                mainAxisSpacing: 6,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                crossAxisSpacing: 6,
                crossAxisCount: 4,
                pattern: [
                  QuiltedGridTile(2, 2),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 2),
                ]
            ),
            childrenDelegate: SliverChildListDelegate(__createImageTile()),
          ),
        ),
      ),
    );
  }

  Widget _detailRelevantPlace() {
    List<Widget> placeCards = [const SizedBox(width: 24,)];
    for (int i = 0;i < _relevantPlaceData.length;i++) {
      placeCards.add(
          RoundedRectanglePlaceCard(
            width: 250,
            aspectRatio: 18/14,
            tags: _relevantPlaceData[i]['tags'],
            imageUrl: _relevantPlaceData[i]['imageUrl'],
            placeName: _relevantPlaceData[i]['placeName'],
            placeType: _relevantPlaceData[i]['placeType'],
            distance: UnitConverter.formatDistance(_relevantPlaceData[i]['distance']),
            open: _relevantPlaceData[i]['open'],
            likeCount: UnitConverter.formatNumber(_relevantPlaceData[i]['likeCount']),
            onPressed: () {
              print("place");
              Get.to(() => PlaceDetailPage(), preventDuplicates: false);
            },
          )
      );
    }
    placeCards.add(const SizedBox(width: 24,));

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
      child: MainSection(
        title: "관련 장소",
        // action: Ink(
        //   child: InkWell(
        //     onTap: () {},
        //     child: Text(
        //       "더보기 (100)",
        //       style: SectionTextStyle.labelMedium(Colors.blue),
        //     ),
        //   ),
        // ),
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: placeCards,
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRelevantStory() {
    List<Widget> placeCards = [const SizedBox(width: 24,)];
    for (int i = 0;i < _relevantPlaceData.length;i++) {
      placeCards.add(
          RoundedRectangleStoryCard(
            title: _relevanceStoryData[i]['title'],
            message: _relevanceStoryData[i]['message'],
            location: _relevanceStoryData[i]['location'],
            imageUrl: _relevanceStoryData[i]['background'],
            width: 250,
            height: 194,
            onTap: () {
              Get.to(() => CourseMainPage());
            },
          )
      );
      placeCards.add(const SizedBox(width: 8,));
    }
    placeCards.add(const SizedBox(width: 16,));

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
      child: MainSection(
        title: "관련 스토리",
        // action: Ink(
        //   child: InkWell(
        //     onTap: () {},
        //     child: Text(
        //       "더보기 (100)",
        //       style: SectionTextStyle.labelMedium(Colors.blue),
        //     ),
        //   ),
        // ),
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: placeCards,
            ),
          )
        ),
      ),
    );
  }

  void __showBookmarkSelectionSheet() {
    bool stateFirst = true;
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter bottomState) {
              if (stateFirst) {
                _bookmarkScrollController.addListener(() {
                  if (_bookmarkScrollController.position.maxScrollExtent == _bookmarkScrollController.offset) {
                    stateFirst = false;
                    bottomState(() {
                      setState(() {
                        for (int i = 0;i < 20;i++) {
                          _bookmarkData.add({"name": "북마크", "include": math.Random().nextBool()});
                        }
                      });
                    });
                  }
                });
              }
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text("북마크 관리", style: SectionTextStyle.sectionTitle(),),),
                          Ink(
                            child: InkWell(
                                onTap: () {
                                  print('add bookmark');
                                  __showCreateBookmarkDialog();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.playlist_add),
                                    Text("북마크 추가")
                                  ],
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 18,),
                    Expanded(
                      child: Scrollbar(
                        controller: _bookmarkScrollController,
                        child: ListView.separated(
                          controller: _bookmarkScrollController,
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                          itemCount: _bookmarkData.length + 1,
                          itemBuilder: (context, index) {
                            if (index < _bookmarkData.length) {
                              return ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                title: Text("${_bookmarkData[index]['name']} $index"),
                                trailing: _bookmarkData[index]['include']
                                    ? Icon(Icons.check_box, color: lightColorScheme.primary,)
                                    : Icon(Icons.check_box_outline_blank),
                                onTap: () {
                                  bottomState(() {
                                    setState(() {
                                      _bookmarkData[index]['include'] = !_bookmarkData[index]['include'];
                                    });
                                  });
                                },
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: Center(child: CircularProgressIndicator(),),
                              );
                            }
                          },
                          separatorBuilder: (context, index) {
                            return Divider(height: 0, color: Colors.grey[250],);
                          },
                        ),
                      )
                    ),
                    // SizedBox(height: 18,),
                    Container(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 18),
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('닫기')
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
    ).whenComplete(() {
      _bookmarkScrollController.dispose();
      _bookmarkScrollController = ScrollController();
    });
  }

  void __showCreateBookmarkDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter dialogState) {
              return AlertDialog(
                title: Text("북마크 추가"),
                content: TextField(
                  maxLength: 50,
                  controller: _bookmarkNameController,
                  onChanged: (text) {
                    dialogState(() {
                      setState(() {
                        _bookmarkNameError = bookmarkTextFieldValidator(text);
                      });
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "북마크 이름",
                      errorText: _bookmarkNameError
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('취소', style: TextStyle(color: Colors.red),),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('만들기', style: TextStyle(color: Colors.blue),),
                  )
                ],
              );
            },
          );
        }
    );
  }

  void __showTimeReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("운영중 오류 제보"),
            content: Text("현재 운영 중으로 표시되어 있으나 실제로 운영 중이 아닌 경우, 제보하기 버튼을 눌러 제보해주시기 바랍니다."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text('취소', style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Get.showSnackbar(
                      const GetSnackBar(
                        backgroundColor: Colors.blue,
                        snackPosition: SnackPosition.BOTTOM,
                        titleText: Text(
                          "제보 완료",
                          style: TextStyle(color: Colors.white),
                        ),
                        messageText: Text(
                          "제보 감사합니다.",
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 2),
                      )
                  );
                },
                child: Text('제보하기', style: TextStyle(color: Colors.blue),),
              )
            ],
          );
        }
    );
  }

  void __showCommentSheet(double commentHeight) {
    bool stateFirst = true;
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            if (stateFirst) {
              _commentScrollController.addListener(() {
                if (_commentScrollController.position.maxScrollExtent == _commentScrollController.offset) {
                  stateFirst = false;
                  bottomState(() {
                    setState(() {
                      _commentData.addAll([
                        {
                          "name": "민준",
                          "date": "2023-08-05T14:29:20.725Z",
                          "comment": "사려니 숲길은 제주도 여행의 필수 코스! 자연의 아름다움을 느낄 수 있어요.",
                          "profileUrl": "https://source.unsplash.com/random",
                          "likeCount": 3254546,
                          "likeComment": false,
                        },
                        {
                          "name": "Ethan",
                          "date": "2023-08-04T14:29:20.725Z",
                          "comment": "여행 중 가장 기억에 남는 곳이었어요. 특히 아침 일찍 방문해서 조용한 분위기를 느끼는 것을 추천합니다.",
                          "profileUrl": "https://source.unsplash.com/random",
                          "likeCount": 42355,
                          "likeComment": true,
                        },
                        {
                          "name": "Emma",
                          "date": "2023-07-30T14:29:20.725Z",
                          "comment": "가족과 함께 방문했는데, 아이들도 너무 좋아했어요. 자연과 함께하는 시간이 너무 소중했습니다.",
                          "profileUrl": "https://source.unsplash.com/random",
                          "likeCount": 534,
                          "likeComment": false,
                        },
                        {
                          "name": "예은",
                          "date": "2023-07-26T14:29:20.725Z",
                          "comment": "비오는 날은 미끄러울 수 있으니 조심하세요. 그래도 뷰는 최고!",
                          "profileUrl": "https://source.unsplash.com/random",
                          "likeCount": 356578,
                          "likeComment": false,
                        },
                        {
                          "name": "sdsfsfdsdcvb",
                          "date": "2023-08-05T14:29:20.725Z",
                          "comment": "사afddasfgsgsg! 자연의 아sgsfsdafds어요.",
                          "profileUrl": "https://source.unsplash.com/random",
                          "likeCount": 3254546,
                          "likeComment": false,
                        },
                        {
                          "name": "fsdgfvsgrw",
                          "date": "2023-08-04T14:29:20.725Z",
                          "comment": "여행adfadf남는 곳이었어요. 특히 sffeqfaf것을 추천합니다.",
                          "profileUrl": "https://source.unsplash.com/random",
                          "likeCount": 42355,
                          "likeComment": true,
                        },
                        {
                          "name": "rwgw4rgdsg",
                          "date": "2023-07-30T14:29:20.725Z",
                          "comment": "가dasdfsgsrgh너무 소중했습니다.",
                          "profileUrl": "https://source.unsplash.com/random",
                          "likeCount": 534,
                          "likeComment": false,
                        },
                        {
                          "name": "adsasra",
                          "date": "2023-07-26T14:29:20.725Z",
                          "comment": "asdefcfsfs",
                          "profileUrl": "https://source.unsplash.com/random",
                          "likeCount": 356578,
                          "likeComment": false,
                        },
                      ]);
                    });
                  });
                }
              });
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Text("한줄평", style: SectionTextStyle.sectionTitle(),),),
                        SizedBox(
                          height: 30,
                          child: DropdownButton<int>(
                            padding: EdgeInsets.zero,
                            value: commentSortKey,
                            underline: SizedBox(),
                            items: [
                              DropdownMenuItem(child: Text('최신순'), value: 0,),
                              DropdownMenuItem(child: Text('좋아요순'), value: 1,),
                            ],
                            onChanged: (int? value) {
                              bottomState(() {
                                setState(() {
                                  commentSortKey = value!;
                                });
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 18,),
                  Expanded(
                    child: Scrollbar(
                      controller: _commentScrollController,
                      child: ListView.separated(
                        controller: _commentScrollController,
                        padding: EdgeInsets.zero,
                        itemCount: _commentData.length + 1,
                        itemBuilder: (context, index) {
                          if (index < _commentData.length) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                              child: ShortPlaceReviewCard(
                                vsync: this,
                                height: commentHeight,
                                name: _commentData[index]['name'],
                                comment: _commentData[index]['comment'],
                                profileUrl: _commentData[index]['profileUrl'],
                                date: _commentData[index]['date'].split('T')[0].replaceAll('-', '.'),
                                likeComment: _commentData[index]['likeComment'],
                                likeCount: UnitConverter.formatNumber(_commentData[index]['likeCount']),
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          }
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12,);
                        },
                      ),
                    )
                  ),
                  // SizedBox(height: 18,),
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 18),
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('닫기')
                    ),
                  )
                ],
              ),
            );
          },
        );
      }
    ).whenComplete(() {
      _commentScrollController.dispose();
      _commentScrollController = ScrollController();
    });
  }

  void __showPhotoSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.fromLTRB(24, 24, 24, 18),
            child: Column(
              children: [
                Expanded(
                  child: GridView.custom(
                    gridDelegate: SliverQuiltedGridDelegate(
                        mainAxisSpacing: 6,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        crossAxisSpacing: 6,
                        crossAxisCount: 4,
                        pattern: [
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 2),
                        ]
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://source.unsplash.com/random?sig=$index',
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                    ),
                  ),
                ),
                // SizedBox(height: 18,),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('닫기')
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
