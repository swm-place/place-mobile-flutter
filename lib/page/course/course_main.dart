import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/section/topbar/picture_flexible.dart';
import 'package:place_mobile_flutter/widget/section/topbar/topbar_flexible_button.dart';

class CourseMainPage extends StatefulWidget {
  const CourseMainPage({
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends State<CourseMainPage> with TickerProviderStateMixin {
  late final AnimationController _likeButtonController;
  late final AnimationController _bookmarkButtonController;

  late final TextEditingController _bookmarkNameController;

  late ScrollController _bookmarkScrollController;

  bool likePlace = false;
  bool bookmarkPlace = false;

  bool isTimeOpen = false;

  String? _bookmarkNameError;

  int? commentSortKey = 0;

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
    _bookmarkNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _likeButtonController.dispose();
    _bookmarkButtonController.dispose();
    _bookmarkScrollController.dispose();
    _bookmarkNameController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
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
                  pinned: true,
                  expandedHeight: 220.0,
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  flexibleSpace: const PictureFlexibleSpace(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _detailHead()
                  ]),
                )
              ],
            );
          },
        )
    );
  }
}
