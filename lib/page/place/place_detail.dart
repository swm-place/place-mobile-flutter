import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/unit_converter.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:place_mobile_flutter/widget/place/review/place_review.dart';

import 'dart:math' as math;

import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
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

  late ScrollController _bookmarkScrollController;

  bool likePlace = false;
  bool bookmarkPlace = false;

  bool isTimeOpen = false;

  final List<Map<String, dynamic>> _commentData = [
    {
     "name": "민준",
     "date": "2023-08-05T14:29:20.725Z",
     "comment": "사려니 숲길은 제주도 여행의 필수 코스! 자연의 아름다움을 느낄 수 있어요.",
     "profileUrl": "https://plus.unsplash.com/premium_photo-1683134601449-752ec64f5a0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1760&q=80",
     "likeCount": 3254546,
     "likeComment": false,
    },
    {
     "name": "Ethan",
     "date": "2023-08-04T14:29:20.725Z",
     "comment": "여행 중 가장 기억에 남는 곳이었어요. 특히 아침 일찍 방문해서 조용한 분위기를 느끼는 것을 추천합니다.",
     "profileUrl": "https://plus.unsplash.com/premium_photo-1683134601449-752ec64f5a0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1760&q=80",
     "likeCount": 42355,
     "likeComment": true,
    },
    {
     "name": "Emma",
     "date": "2023-07-30T14:29:20.725Z",
     "comment": "가족과 함께 방문했는데, 아이들도 너무 좋아했어요. 자연과 함께하는 시간이 너무 소중했습니다.",
     "profileUrl": "https://plus.unsplash.com/premium_photo-1683134601449-752ec64f5a0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1760&q=80",
     "likeCount": 534,
     "likeComment": false,
    },
    {
     "name": "예은",
     "date": "2023-07-26T14:29:20.725Z",
     "comment": "비오는 날은 미끄러울 수 있으니 조심하세요. 그래도 뷰는 최고!",
     "profileUrl": "https://plus.unsplash.com/premium_photo-1683134601449-752ec64f5a0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1760&q=80",
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
    super.initState();
  }

  @override
  void dispose() {
    _likeButtonController.dispose();
    _bookmarkButtonController.dispose();
    _bookmarkScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent
    // ));
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading:IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Ink(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: Platform.isAndroid ? EdgeInsets.zero : EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: Icon(
                    Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                    size: 18,
                  ),
                ),
              ),
            ),
            pinned: true,
            expandedHeight: 220.0,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            flexibleSpace: _PlacePictureFlexibleSpace(),
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
              _detailReview(),
              _detailPicture(),
              _detailRelevantPlace(),
              _detailRelevantStory(),
              SizedBox(height: 24,)
            ]),
          )
        ],
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
                showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter bottomState) {
                        _bookmarkScrollController.addListener(() {
                          if (_bookmarkScrollController.position.maxScrollExtent == _bookmarkScrollController.offset) {
                            bottomState(() {
                              setState(() {
                                for (int i = 0;i < 20;i++) {
                                  _bookmarkData.add({"name": "북마크", "include": math.Random().nextBool()});
                                }
                              });
                            });
                          }
                        });
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
                              Text("북마크 관리", style: SectionTextStyle.sectionTitle(),),
                              SizedBox(height: 18,),
                              Expanded(
                                child: ListView.builder(
                                  controller: _bookmarkScrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount: _bookmarkData.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < _bookmarkData.length) {
                                      return ListTile(
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
                                ),
                              ),
                              SizedBox(height: 18,),
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
                      },
                    );
                  }
                ).whenComplete(() {
                  _bookmarkScrollController.dispose();
                  _bookmarkScrollController = ScrollController();
                });
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
                                        child: Text("잘못된 운영중 제보하기"),
                                        onTap: () {
                                          print("object");
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

  // Widget _detailInform() => Padding(
  //   padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
  //   child: Column(
  //     children: [
  //       SizedBox(
  //         width: double.infinity,
  //         child: Text(
  //           "정보",
  //           style: SectionTextStyle.sectionTitle(),
  //         ),
  //       ),
  //       SizedBox(height: 14,),
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(MdiIcons.mapMarkerOutline, color: Colors.grey[700], size: 24,),
  //           SizedBox(width: 10,),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 4,),
  //                 Text(
  //                   "제주 제주시 봉개동 산 64-5",
  //                   style: SectionTextStyle.sectionContent(Colors.black),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text("지번"),
  //                     SizedBox(width: 4,),
  //                     Text("제주 제주시 봉개동 산 64-5")
  //                   ],
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //       SizedBox(height: 8,),
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(MdiIcons.clockOutline, color: Colors.grey[700], size: 24,),
  //           SizedBox(width: 10,),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 4,),
  //                 Ink(
  //                   child: InkWell(
  //                     onTap: () {
  //                       setState(() {
  //                         isTimeOpen = !isTimeOpen;
  //                       });
  //                     },
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "현재 운영중",
  //                                 style: SectionTextStyle.sectionContent(Colors.green),
  //                               ),
  //                               Text("최근 1시간 동안 5명이 운영중이 아니라고 제보"),
  //                             ],
  //                           ),
  //                         ),
  //                         AnimatedCrossFade(
  //                           duration: Duration(milliseconds: 250),
  //                           crossFadeState: isTimeOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
  //                           firstChild: Icon(Icons.keyboard_arrow_down),
  //                           secondChild: Icon(Icons.keyboard_arrow_up),
  //                         )
  //                       ],
  //                     ),
  //                   )
  //                 ),
  //                 AnimatedSize(
  //                   duration: const Duration(milliseconds: 500),
  //                   curve: Curves.fastOutSlowIn,
  //                   child: Container(
  //                     height: isTimeOpen ? null : 0,
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text("월 10:00~22:00"),
  //                         Text("화 10:00~22:00"),
  //                         Text("수 10:00~22:00"),
  //                         Text("목 10:00~22:00"),
  //                         Text("금 10:00~22:00"),
  //                         Text("토 휴무"),
  //                         Text("일 휴무"),
  //                       ],
  //                     ),
  //                   )
  //                 ),
  //                 TextButton.icon(
  //                   onPressed: () {
  //
  //                   },
  //                   label: Text("오류 신고"),
  //                   icon: Icon(MdiIcons.alertOctagon, size: 20,),
  //                   style: TextButton.styleFrom(
  //                     padding: EdgeInsets.zero,
  //                     minimumSize: Size(50, 30),
  //                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                     alignment: Alignment.centerLeft,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8)
  //                     ),
  //                     iconColor: Colors.red,
  //                     surfaceTintColor: Colors.red,
  //                     foregroundColor: Colors.red
  //                   ),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //       SizedBox(height: 8,),
  //       GestureDetector(
  //         onTap: () {
  //           print("call");
  //           launchUrlString("tel:010-0000-0000");
  //         },
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Icon(MdiIcons.phone, color: Colors.grey[700], size: 24,),
  //             SizedBox(width: 10,),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(height: 4,),
  //                   Text(
  //                     "010-0000-0000",
  //                     style: SectionTextStyle.sectionContent(Colors.black),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   ),
  // );

  Widget _detailReview() => Column(
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "한줄평",
                style: SectionTextStyle.sectionTitle(),
              ),
            ),
            Ink(
              child: InkWell(
                onTap: () {

                },
                child: Text(
                  "더보기 (100)",
                  style: SectionTextStyle.labelMedium(Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 14,),
      SizedBox(
        width: double.infinity,
        child: CarouselSlider.builder(
          options: CarouselOptions(
            initialPage: 0,
            // enlargeCenterPage: true,
            autoPlay: false,
            enableInfiniteScroll: false,
            aspectRatio: 18/6,
            // onPageChanged: (index, reason) {
            //   setState(() {
            //     activeIndex = index;
            //   });
            // }
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
    ],
  );

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

  Widget _detailPicture() => Column(
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "사진",
                style: SectionTextStyle.sectionTitle(),
              ),
            ),
            Ink(
              child: InkWell(
                onTap: () {

                },
                child: Text(
                  "더보기 (100)",
                  style: SectionTextStyle.labelMedium(Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 14,),
      Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
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
      )
    ],
  );

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

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 28, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "관련 장소",
                  style: SectionTextStyle.sectionTitle(),
                ),
              ),
              Ink(
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    "더보기 (100)",
                    style: SectionTextStyle.labelMedium(Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 14,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: placeCards,
          ),
        )
      ],
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
          )
      );
      placeCards.add(const SizedBox(width: 8,));
    }
    placeCards.add(const SizedBox(width: 16,));

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 28, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "관련 스토리",
                  style: SectionTextStyle.sectionTitle(),
                ),
              ),
              Ink(
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    "더보기 (100)",
                    style: SectionTextStyle.labelMedium(Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 14,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: placeCards,
          ),
        )
      ],
    );
  }
}

class _PlacePictureFlexibleSpace extends StatelessWidget {
  const _PlacePictureFlexibleSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Opacity(
          opacity: opacity,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  width: double.infinity,
                  child: Image.network(
                    'https://source.unsplash.com/random',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
