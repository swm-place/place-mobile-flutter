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
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/place_provider.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/page/course/course_main.dart';
import 'package:place_mobile_flutter/page/magazine/magazine.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/state/bookmark_controller.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';
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
  final UserProvider _userProvider = UserProvider();
  final BookmarkController _bookmarkController = BookmarkController();

  late final AnimationController _likeButtonController;
  late final AnimationController _bookmarkButtonController;

  late final TextEditingController _bookmarkNameController;

  late TextEditingController _commentEditingController;

  late ScrollController _bookmarkScrollController;
  late ScrollController _commentScrollController;

  bool likePlace = false;
  bool asyncLike = false;
  bool bookmarkPlace = false;

  bool isTimeOpen = false;
  bool nowOpen = false;

  String? _bookmarkNameError;

  int? commentSortKey = 0;

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

  int _loadData = -1;

  late final Map<String, dynamic> placeData;

  List<dynamic> _commentData = [];

  void _loadComments() async {
    _commentData.clear();
    List<dynamic>? result = await _placeProvider.getPlaceReviewData(widget.placeId, 'likes', 0, 5, false);
    if (result != null) {
      setState(() {
        _commentData = result;
      });
    }
  }

  @override
  void initState() {
    _likeButtonController = AnimationController(vsync: this);
    _bookmarkButtonController = AnimationController(vsync: this);
    _bookmarkScrollController = ScrollController();
    _commentScrollController = ScrollController();
    _bookmarkNameController = TextEditingController();
    _commentEditingController = TextEditingController();
    _loadComments();
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
    _commentEditingController.dispose();
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
        likePlace = placeData['is_favorite'];
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
                          ImageParser.parseImageUrl(placeData['photos'][0]['url']):
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
                        // _detailRelevantPlace(),
                        // _detailRelevantStory(),
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
          body: const Center(
            child: Text('오류 발생')
          ),
        );
      }
    } else {
      return const Scaffold(
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

  void like() async {
    asyncLike = true;

    bool result;
    if (!likePlace) {
      result = await _placeProvider.postPlaceLike(widget.placeId);
    } else {
      result = await _placeProvider.deletePlaceLike(widget.placeId);
    }

    if (result) {
      HapticFeedback.lightImpact();
      likePlace = !likePlace;
      if (likePlace) {
        _likeButtonController.animateTo(1);
      } else {
        _likeButtonController.animateBack(0);
      }
    }

    asyncLike = false;
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
              if (placeData['hashtags'] != null && placeData['hashtags'].isNotEmpty)
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
                HapticFeedback.lightImpact();
                __showBookmarkSelectionSheet();
                // setState(() {
                  // bookmarkPlace = !bookmarkPlace;
                  // if (bookmarkPlace) {
                  //   _bookmarkButtonController.animateTo(1);
                  // } else {
                  //   _bookmarkButtonController.animateBack(0);
                  // }
                // });
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
                  if (asyncLike) return;
                  like();
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
                          // SizedBox(height: 4,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("도로명"),
                              SizedBox(width: 4,),
                              Expanded(
                                child: Text(
                                  placeData['road_address'] ?? '-',
                                  style: SectionTextStyle.sectionContent(
                                      Colors.black),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("지번 "),
                              SizedBox(width: 4,),
                              Expanded(
                                child: Text(
                                  placeData['address'] ?? '-',
                                ),
                              )
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
                            // SizedBox(height: 4,),
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
                                            // Text("최근 1시간 동안 5명이 운영중이 아니라고 제보"),
                                            // GestureDetector(
                                            //   child: Text("운영중 오류 제보하기"),
                                            //   onTap: () {
                                            //     __showTimeReportDialog();
                                            //   },
                                            // )
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
    _commentEditingController.text = '';

    showModalBottomSheet(
      context: context,
        isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24, 16, 24, bottomPad + MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text("한줄평 작성", style: SectionTextStyle.sectionTitle(),)
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _commentEditingController,
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
                        onPressed: () async {
                          String content = _commentEditingController.text.toString();
                          if (content == '') {
                            Navigator.of(context).pop();
                            return;
                          }

                          Map<String, dynamic>? result = await _placeProvider.postPlaceReviewData(widget.placeId, content);
                          if (result != null) {
                            setState(() {
                              _commentData.insert(0, result);
                              if (_commentData.length > 5) _commentData.removeLast();
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('게시')
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
              if (AuthController.to.user.value == null) {
                Get.showSnackbar(
                    WarnGetSnackBar(
                        title: "로그인 필요",
                        message: "한줄평 작성은 로그인이 필요합니다."
                    )
                );
                return;
              }
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
                    bool myReview = false;
                    if (AuthController.to.user.value != null) {
                      myReview = AuthController.to.user.value!.uid == _commentData[index]['user']['id'];
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                      child: ShortPlaceReviewCard(
                        vsync: this,
                        name: _commentData[index]['user']['nickname'],
                        comment: _commentData[index]['contents'],
                        profileUrl: _commentData[index]['user']['img_url'],
                        date: _commentData[index]['created_at'].split('T')[0].replaceAll('-', '.'),
                        likeComment: _commentData[index]['is_liked'],
                        likeCount: _commentData[index]['likes'],
                        myReview: myReview,
                        placeId: widget.placeId,
                        reviewId: _commentData[index]['id'],
                        onDeletePressed: () async {
                          Get.dialog(
                            const AlertDialog(
                              contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                              actionsPadding: EdgeInsets.zero,
                              titlePadding: EdgeInsets.zero,
                              content: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 24),
                                  Text("삭제중..."),
                                ],
                              ),
                            ),
                            barrierDismissible: false,
                          );
                          bool result = await _placeProvider.deletePlaceReview(widget.placeId, _commentData[index]['id']);
                          if (result) {
                            _loadComments();
                            Get.back();
                          } else {
                            Get.back();
                            Get.dialog(
                              AlertDialog(
                                contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                                titlePadding: EdgeInsets.zero,
                                content: const Text("한줄평 삭제 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
                                actions: [
                                  TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
                                ],
                              ),
                            );
                            // Get.showSnackbar(
                            //     ErrorGetSnackBar(
                            //         title: "삭제 실패",
                            //         message: "한줄평 삭제 중 오류가 발생했습니다.",
                            //       showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_SHORT,
                            //     )
                            // );
                          }
                        },
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
              ),
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
      String? imgUrl = ImageParser.parseImageUrl(placeData['photos'][i]['url']);
      tiles.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imgUrl != null ?
            Image.network(
              imgUrl,
              fit: BoxFit.cover,
            ) :
            Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
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
          RoundedRectangleMagazineCard(
            title: _relevanceStoryData[i]['title'],
            message: _relevanceStoryData[i]['message'],
            location: _relevanceStoryData[i]['location'],
            imageUrl: _relevanceStoryData[i]['background'],
            width: 250,
            height: 194,
            onTap: () {
              // Get.to(() => CourseMainPage());
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
    bool loadVisibility = false;

    int page = 0;
    int size = 25;

    StateSetter? state;

    List<dynamic> _bookmarkData = [];

    void addBookmarks() async {
      state!(() {
        setState(() {
          loadVisibility = true;
        });
      });
      Map<String, dynamic>? result = await _userProvider.getPlaceBookmark(page, size, widget.placeId);

      if (result != null) {
        _bookmarkData.addAll(result['result']);
        page++;
      }

      state!(() {
        setState(() {
          loadVisibility = false;
        });
      });
    }

    void addPlaceBookmark(String text) async {
      Get.dialog(
          const AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
            actionsPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 24),
                Text('북마크 생성중'),
              ],
            ),
          ),
          barrierDismissible: false
      );
      bool result = await _bookmarkController.addPlaceBookmark(text);
      Get.back();
      if (result) {
        page = 0;
        _bookmarkData.clear();
        addBookmarks();
      } else {
        Get.dialog(
          AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
            titlePadding: EdgeInsets.zero,
            content: const Text("북마크 추가 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
            actions: [
              TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
            ],
          ),
        );
      }
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
                        final String title = _bookmarkNameController.text.toString();
                        if (bookmarkTextFieldValidator(title) != null) return;
                        Navigator.of(context, rootNavigator: true).pop();
                        addPlaceBookmark(title);
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

    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter bottomState) {
              state = bottomState;
              if (stateFirst) {
                _bookmarkScrollController.addListener(() {
                  if (_bookmarkScrollController.position.maxScrollExtent == _bookmarkScrollController.offset && !loadVisibility) {
                    stateFirst = false;
                    addBookmarks();
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
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
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
                                          child: const Row(
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
                                    itemCount: _bookmarkData.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        minVerticalPadding: 0,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text("${_bookmarkData[index]['title']}"),
                                        trailing: _bookmarkData[index]['bookmark']
                                            ? Icon(Icons.check_box, color: lightColorScheme.primary,)
                                            : Icon(Icons.check_box_outline_blank),
                                        onTap: () async {
                                          bottomState(() {
                                            setState(() {
                                              loadVisibility = true;
                                            });
                                          });
                                          bool result;
                                          if (_bookmarkData[index]['bookmark']) {
                                            result = await _userProvider.deletePlaceInBookmark(
                                                _bookmarkData[index]['placeBookmarkId'], widget.placeId);
                                          } else {
                                            result = await _userProvider.postPlaceInBookmark(
                                                _bookmarkData[index]['placeBookmarkId'], widget.placeId);
                                          }
                                          if (result) {
                                            bottomState(() {
                                              setState(() {
                                                loadVisibility = false;
                                                _bookmarkData[index]['bookmark'] = !_bookmarkData[index]['bookmark'];
                                              });
                                            });
                                          }
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Divider(height: 0, color: Colors.grey[250],);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                              visible: loadVisibility,
                              child: AbsorbPointer(
                                absorbing: true,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(38),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: const CircularProgressIndicator(),
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      addBookmarks();
    });
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

  void __showCommentSheet(double commentHeight) async {
    List<dynamic> _commentData = [];

    String sortKey = 'likes';
    bool myReviews = false;
    int offset = 0;
    int count = 5;

    bool stateFirst = true;
    bool loadVisibility = false;

    StateSetter? state;

    void _addComments() async {
      state!(() {
        setState(() {
          loadVisibility = true;
          _commentScrollController.jumpTo(_commentScrollController.position.maxScrollExtent);
        });
      });
      List<dynamic>? result = await _placeProvider.getPlaceReviewData(widget.placeId, sortKey, offset, count, myReviews);
      if (result != null) {
        _commentData.addAll(result);
        offset += count;
      }
      state!(() {
        setState(() {
          loadVisibility = false;
        });
      });
    }

    void _changeSort() {
      offset = 0;
      count = 5;
      _commentData.clear();
      switch(commentSortKey) {
        case 0: {
          sortKey = 'created_at';
          myReviews = false;
          break;
        }
        case 1: {
          sortKey = 'likes';
          myReviews = false;
          break;
        }
        case 2: {
          sortKey = 'created_at';
          myReviews = true;
          break;
        }
      }
      _addComments();
    }

    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            state = bottomState;
            if (stateFirst) {
              _commentScrollController.addListener(() {
                if (_commentScrollController.position.maxScrollExtent == _commentScrollController.offset && !loadVisibility) {
                  stateFirst = false;
                  _addComments();
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
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
                                      items: [
                                        const DropdownMenuItem(child: Text('최신순'), value: 0,),
                                        const DropdownMenuItem(child: Text('좋아요순'), value: 1,),
                                        if (AuthController.to.user.value != null) const DropdownMenuItem(child: Text('내 한줄평'), value: 2,),
                                      ],
                                      onChanged: loadVisibility ? null :
                                          (int? value) {
                                        bottomState(() {
                                          setState(() {
                                            commentSortKey = value!;
                                          });
                                        });
                                        _changeSort();
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
                                  itemCount: _commentData.length,
                                  itemBuilder: (context, index) {
                                    bool myReview = false;
                                    if (AuthController.to.user.value != null) {
                                      myReview = AuthController.to.user.value!.uid == _commentData[index]['user']['id'];
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                      child: ShortPlaceReviewCard(
                                        vsync: this,
                                        height: commentHeight,
                                        name: _commentData[index]['user']['nickname'],
                                        comment: _commentData[index]['contents'],
                                        profileUrl: _commentData[index]['user']['img_url'],
                                        date: _commentData[index]['created_at'].split('T')[0].replaceAll('-', '.'),
                                        likeComment: _commentData[index]['is_liked'],
                                        likeCount: _commentData[index]['likes'],
                                        myReview: myReview,
                                        placeId: widget.placeId,
                                        reviewId: _commentData[index]['id'],
                                        onDeletePressed: () async {
                                          Get.dialog(
                                            const AlertDialog(
                                              contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                                              actionsPadding: EdgeInsets.zero,
                                              titlePadding: EdgeInsets.zero,
                                              content: Row(
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(width: 24),
                                                  Text("삭제중..."),
                                                ],
                                              ),
                                            ),
                                            barrierDismissible: false,
                                          );
                                          bool result = await _placeProvider.deletePlaceReview(widget.placeId, _commentData[index]['id']);

                                          if (result) {
                                            offset = 0;
                                            count = 5;
                                            _commentData.clear();
                                            _addComments();
                                            _loadComments();
                                            Get.back();
                                          } else {
                                            Get.back();
                                            Get.dialog(
                                              AlertDialog(
                                                contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                                                titlePadding: EdgeInsets.zero,
                                                content: const Text("한줄평 삭제 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
                                                actions: [
                                                  TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
                                                ],
                                              ),
                                            );
                                            // Get.showSnackbar(
                                            //     ErrorGetSnackBar(
                                            //         title: "삭제 실패",
                                            //         message: "한줄평 삭제 중 오류가 발생했습니다.",
                                            //       showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_SHORT,
                                            //     )
                                            // );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 12,);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: loadVisibility,
                          child: AbsorbPointer(
                            absorbing: true,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(38),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(24)
                                ),
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                          )
                        )
                      ],
                    ),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addComments();
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
