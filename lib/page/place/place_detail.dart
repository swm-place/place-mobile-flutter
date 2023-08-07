import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/place/review/place_review.dart';

import 'dart:math' as math;

import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
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

  bool likePlace = false;
  bool bookmarkPlace = false;

  bool isTimeOpen = false;

  @override
  void initState() {
    _likeButtonController = AnimationController(vsync: this);
    _bookmarkButtonController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
              // forceElevated: true,
              // elevation: 20,
              // floating: true,
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
              ]),
            )
          ],
        )
      ),
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
    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "정보",
            style: SectionTextStyle.sectionTitle(),
          ),
        ),
        SizedBox(height: 14,),
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
                                  style: SectionTextStyle.sectionContent(Colors.green),
                                ),
                                Text("최근 1시간 동안 5명이 운영중이 아니라고 제보"),
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
                  TextButton.icon(
                    onPressed: () {},
                    label: Text("오류 신고"),
                    icon: Icon(MdiIcons.alertOctagon, size: 20,),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      iconColor: Colors.red,
                      surfaceTintColor: Colors.red,
                      foregroundColor: Colors.red
                    ),
                  )
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
  );

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
          itemCount: 20,
          itemBuilder: (context, index, realIndex) {
            return Padding(
              padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: ShortPlaceReviewCard(
                vsync: this,
              ),
            );
          },
        ),
      ),
    ],
  );
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
                    'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
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
