import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/api/provider/place_provider.dart';
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
  PlaceDetailPage({
    required this.placeId,
    Key? key
  }) : super(key: key);

  String placeId;

  @override
  State<StatefulWidget> createState() {
    return _PlaceDetailPageState();
  }
}

class _PlaceDetailPageState extends State<PlaceDetailPage> with TickerProviderStateMixin {
  final PlaceProvider _placeProvider = PlaceProvider();

  late final AnimationController _likeButtonController;
  late final AnimationController _bookmarkButtonController;

  late final TextEditingController _bookmarkNameController;

  late ScrollController _bookmarkScrollController;
  late ScrollController _commentScrollController;

  bool likePlace = false;
  bool bookmarkPlace = false;

  bool isTimeOpen = false;
  bool nowOpen = false;

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
    // {
    //  "name": "Emma",
    //  "date": "2023-07-30T14:29:20.725Z",
    //  "comment": "가족과 함께 방문했는데, 아이들도 너무 좋아했어요. 자연과 함께하는 시간이 너무 소중했습니다.",
    //  "profileUrl": "https://source.unsplash.com/random",
    //  "likeCount": 534,
    //  "likeComment": false,
    // },
    // {
    //  "name": "예은",
    //  "date": "2023-07-26T14:29:20.725Z",
    //  "comment": "비오는 날은 미끄러울 수 있으니 조심하세요. 그래도 뷰는 최고!",
    //  "profileUrl": "https://source.unsplash.com/random",
    //  "likeCount": 356578,
    //  "likeComment": false,
    // },
    // {
    //  "name": "sdsfsfdsdcvb",
    //  "date": "2023-08-05T14:29:20.725Z",
    //  "comment": "사afddasfgsgsg! 자연의 아sgsfsdafds어요.",
    //  "profileUrl": "https://source.unsplash.com/random",
    //  "likeCount": 3254546,
    //  "likeComment": false,
    // },
    // {
    //  "name": "fsdgfvsgrw",
    //  "date": "2023-08-04T14:29:20.725Z",
    //  "comment": "여행adfadf남는 곳이었어요. 특히 sffeqfaf것을 추천합니다.",
    //  "profileUrl": "https://source.unsplash.com/random",
    //  "likeCount": 42355,
    //  "likeComment": true,
    // },
    // {
    //  "name": "rwgw4rgdsg",
    //  "date": "2023-07-30T14:29:20.725Z",
    //  "comment": "가dasdfsgsrgh너무 소중했습니다.",
    //  "profileUrl": "https://source.unsplash.com/random",
    //  "likeCount": 534,
    //  "likeComment": false,
    // },
    // {
    //  "name": "adsasra",
    //  "date": "2023-07-26T14:29:20.725Z",
    //  "comment": "asdefcfsfs",
    //  "profileUrl": "https://source.unsplash.com/random",
    //  "likeCount": 356578,
    //  "likeComment": false,
    // },
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

  int _loadData = -1;

  late final Map<String, dynamic> placeData;

  @override
  void initState() {
    _likeButtonController = AnimationController(vsync: this);
    _bookmarkButtonController = AnimationController(vsync: this);
    _bookmarkScrollController = ScrollController();
    _commentScrollController = ScrollController();
    _bookmarkNameController = TextEditingController();
    getPlaceData();
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

  void getPlaceData() async {
    Map<String, dynamic>? result = await _placeProvider.getPlaceData(widget.placeId);
    if (result != null) {
      placeData = result;
      for (int i = 0;i < placeData['hashtags'].length;i++) {
        placeData['hashtags'][i] = {'name': placeData['hashtags'][i], 'color': RandomGenerator.generateRandomDarkHexColor()};
      }
      setState(() {
        _loadData = 1;
      });
    } else {
      setState(() {
        _loadData = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent
    // ));
    if (_loadData != -1) {
      if (_loadData == 1) {
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
                      flexibleSpace: PictureFlexibleSpace(
                        imageUrl: placeData['photos'] != null && placeData['photos'].length > 0 ?
                        "https://been-dev.yeoksi.com/api-recommender/place-photo/?${placeData['photos'][0]['url'].split('?')[1]}&max_width=480" :
                        null,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        _detailHead(),
                        if (placeData['summary'] != null)
                          Padding(
                            padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: Text(
                              placeData['summary'],
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
      } else {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text('오류 발생')
          ),
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  List<Widget> __generateTags() {
    List<Widget> tags = [];
    for (int i = 0;i < placeData['hashtags'].length;i++) {
      tags.add(
        TagChip(
          text: "#${placeData['hashtags'][i]['name']}",
          textStyle: SectionTextStyle.labelMediumThick(Colors.white),
          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
          backgroundColor: UnitConverter.hexToColor(placeData['hashtags'][i]['color']),
        )
      );
    }
    return tags;
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
                child: AutoSizeText(
                  placeData['name'],
                  style: PageTextStyle.headlineExtraLarge(Colors.black),
                  maxLines: 1,
                  minFontSize: 24,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              SizedBox(
                height: 25.5,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return TagChip(
                      text: "#${placeData['hashtags'][index]['name']}",
                      textStyle: SectionTextStyle.labelMediumThick(Colors.white),
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      backgroundColor: UnitConverter.hexToColor(placeData['hashtags'][index]['color']),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 4,);
                  },
                  itemCount: placeData['hashtags'].length,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 6,),
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

  List<Widget> _generateSchedule() {
    Map<int, Text> scheduleList = {
      0: Text("일 휴무"),
      1: Text("월 휴무"),
      2: Text("화 휴무"),
      3: Text("수 휴무"),
      4: Text("목 휴무"),
      5: Text("금 휴무"),
      6: Text("토 휴무"),
    };

    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday % 7;
    bool checkOpen = false;

    for (var data in placeData['opening_hours']) {
      String open = data['open'].toString().padLeft(4, '0').replaceRange(2, 2, ':');
      String close = data['close'].toString().padLeft(4, '0').replaceRange(2, 2, ':');
      if (close.startsWith('00')) close = close.replaceRange(0, 2, '24');
      scheduleList[data['weekday']] = Text(scheduleList[data['weekday']]!.data!.replaceAll('휴무', '$open ~ $close'));
      if (!checkOpen && dayOfWeek == data['weekday']) {
        checkOpen = true;
        DateTime startTime = DateTime(now.year, now.month, now.day,
            int.parse(open.split(":")[0]), int.parse(open.split(":")[1]));
        DateTime endTime = DateTime(now.year, now.month, now.day,
            int.parse(close.split(":")[0]), int.parse(close.split(":")[1]));

        nowOpen = now.isAfter(startTime) && now.isBefore(endTime);
      }
    }

    if (!checkOpen) {
      nowOpen = false;
    }
    return scheduleList.values.toList();
  }

  Widget _detailInform() {
    List<Widget>? timeList;
    if (placeData['opening_hours'] != null) timeList = _generateSchedule();
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
          title: '정보',
          action: TextButton.icon(
            onPressed: () {
              final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'our.email@gmail.com',
                  query: 'subject=[오류제보] ${placeData["name"]} 정보 오류 제보&body=오류 내용: '
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
                    Icon(MdiIcons.mapMarkerOutline, color: Colors.grey[700],
                      size: 24,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4,),
                          Text(
                            placeData['road_address'],
                            style: SectionTextStyle.sectionContent(
                                Colors.black),
                          ),
                          if (placeData['address'] != null)
                            Row(
                              children: [
                                Text("지번"),
                                SizedBox(width: 4,),
                                Text(placeData['address'])
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8,),
                if (placeData['opening_hours'] != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(MdiIcons.clockOutline, color: Colors.grey[700],
                        size: 24,),
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
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            nowOpen ? Text(
                                              "현재 운영중",
                                              style: SectionTextStyle
                                                  .sectionContentLarge(
                                                  Colors.green),
                                            ) : Text(
                                              "현재 운영중 아님",
                                              style: SectionTextStyle
                                                  .sectionContentLarge(
                                                  Colors.red),
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
                                        crossFadeState: isTimeOpen
                                            ? CrossFadeState.showSecond
                                            : CrossFadeState.showFirst,
                                        firstChild: Icon(
                                            Icons.keyboard_arrow_down),
                                        secondChild: Icon(
                                            Icons.keyboard_arrow_up),
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
                                    children: timeList!,
                                  ),
                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                if (placeData['opening_hours'] != null)
                  SizedBox(height: 8,),
                if (placeData['phone_number'] != null)
                  GestureDetector(
                    onTap: () {
                      print("call");
                      launchUrlString("tel:${placeData['phone_number']}");
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
                                placeData['phone_number'],
                                style: SectionTextStyle.sectionContent(
                                    Colors.black),
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
  }

  void _openWriteCommentSection() {
    double bottomPad = MediaQuery.of(context).viewPadding.bottom;
    if (bottomPad == 0) {
      bottomPad = 24;
    } else {
      // bottomPad = 0;
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPad),
          child: Wrap(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(child: Text("한줄평 작성", style: SectionTextStyle.sectionTitle(),),),
                        Visibility(
                          child: IconButton(onPressed: () {
                            print('clicked');
                          }, icon: Icon(Icons.delete)),
                          visible: true,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                        )
                      ],
                    )
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    minLines: 3,
                    maxLength: 250,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                      hintText: "자신의 경험을 공유해주세요!"
                    ),
                  ),
                  SizedBox(height: 12,),
                  Container(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('저장')
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }

  Widget _detailReview(double commentHeight) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
        title: "한줄평",
        action: Ink(
          child: InkWell(
            onTap: () {
              _openWriteCommentSection();
            },
            child: Text(
              "한줄평 작성",
              style: SectionTextStyle.labelMedium(Colors.blue),
            ),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: SizedBox(
            width: double.infinity,
            child: _commentData.isNotEmpty ?
              CarouselSlider.builder(
                options: CarouselOptions(
                  initialPage: 0,
                  autoPlay: false,
                  enableInfiniteScroll: false,
                  height: commentHeight,
                ),
                itemCount: _commentData.length + 1,
                itemBuilder: (context, index, realIndex) {
                  if (index == _commentData.length) {
                    return GestureDetector(
                      onTap: () {
                        __showCommentSheet(commentHeight);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                height: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.navigate_next),
                                    Text("더보기")
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
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
                  }
                },
              ) :
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300]
                  ),
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text("아직 작성된 한줄평이 없습니다 :("),
                  ),
                ),
              )
            ,
          ),
        ),
      ),
    );
  }

  List<Widget> __createImageTile() {
    List<Widget> tiles = [];
    int imgCount = placeData['photos'].length;
    if (imgCount > 8) imgCount = 8;
    for (int i = 0;i < imgCount;i++) {
      tiles.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            "https://been-dev.yeoksi.com/api-recommender/place-photo/?${placeData['photos'][i]['url'].split('?')[1]}&max_width=480",
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
        // action: Ink(
        //   child: InkWell(
        //     onTap: () {
        //       __showPhotoSheet();
        //     },
        //     child: Text(
        //       "더보기 (100)",
        //       style: SectionTextStyle.labelMedium(Colors.blue),
        //     ),
        //   ),
        // ),
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
                  // QuiltedGridTile(1, 1),
                  // QuiltedGridTile(1, 1),
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
              // Get.to(() => PlaceDetailPage(), preventDuplicates: false);
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
    bool loadVisibility = false;
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            if (stateFirst) {
              _commentScrollController.addListener(() {
                print('fff');
                if (_commentScrollController.position.maxScrollExtent == _commentScrollController.offset) {
                  stateFirst = false;
                  bottomState(() {
                    setState(() {
                      loadVisibility = true;
                    });
                  });
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
                      loadVisibility = false;
                    });
                  });
                }
              });
            }
            return Container(
              decoration: const BoxDecoration(
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
                            underline: const SizedBox(),
                            items: const [
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
                  const SizedBox(height: 18,),
                  Expanded(
                    child: Scrollbar(
                      controller: _commentScrollController,
                      child: ListView.separated(
                        controller: _commentScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
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
                            return Visibility(
                              visible: loadVisibility,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: Center(child: CircularProgressIndicator(),),
                              ),
                            );
                          }
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12,);
                        },
                      ),
                    )
                  ),
                  // SizedBox(height: 18,),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
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
