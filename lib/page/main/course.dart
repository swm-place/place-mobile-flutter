import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/course_provider.dart';
import 'package:place_mobile_flutter/page/course/course_main.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/course/course_inform_card.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/story/story_card.dart';

class CoursePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CoursePageState();
}

class CoursePageState extends State<CoursePage> with AutomaticKeepAliveClientMixin<CoursePage> {

  final CourseProvider _courseProvider = CourseProvider();

  late ScrollController _courseScrollController;

  int _loadMyCourseData = -1;
  int page = 0;
  int count = 25;

  bool loadVisibilityCourse = false;

  List<dynamic>? _myCourseData = [];

  final Map<String, dynamic> _courseData = {
    'title': '코스 추천',
    'summary': '코스 설명',
    'courses': [
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
      }
    ]
  };

  final List<Map<String, dynamic>> _recommendKeywordData = [
    {
      'background': [
        "https://source.unsplash.com/random?sig=1",
        "https://source.unsplash.com/random?sig=2",
        "https://source.unsplash.com/random?sig=3",
      ],
      'title': '강남 데이트 1',
      'location': '서울특뱔시 강남구'
    },
    {
      'background': [
        "https://source.unsplash.com/random?sig=4",
        "https://source.unsplash.com/random?sig=5",
        "https://source.unsplash.com/random?sig=6",
        "https://source.unsplash.com/random?sig=7",
        "https://source.unsplash.com/random?sig=8",
      ],
      'title': '파주 데이트 2',
      'location': '경기도 파주시'
    },
  ];

  @override
  bool get wantKeepAlive => false;

  void initCourseData() async {
    page = 0;
    List<dynamic>? data = await _courseProvider.getMyCourseData(page, count);
    if (data == null) {
      _myCourseData = null;
      setState(() {
        _loadMyCourseData = 0;
      });
      return null;
    }

    _myCourseData = data;
    setState(() {
      _loadMyCourseData = 1;
    });
  }

  void addCourseList() async {
    if (_myCourseData == null) return;
    setState(() {
      loadVisibilityCourse = true;
    });
    page += 1;
    List<dynamic>? data = await _courseProvider.getMyCourseData(page, count);
    if (data == null) {
      setState(() {
        loadVisibilityCourse = false;
      });
      return null;
    }

    setState(() {
      _myCourseData!.addAll(data);
      loadVisibilityCourse = false;
    });
  }

  @override
  void initState() {
    _courseScrollController = ScrollController();

    _courseScrollController.addListener(() {
      if (_courseScrollController.position.maxScrollExtent == _courseScrollController.offset && !loadVisibilityCourse) {
        addCourseList();
      }
    });

    initCourseData();
    super.initState();
  }

  @override
  void dispose() {
    _courseScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (loadVisibilityCourse) return;
          Get.dialog(
              const AlertDialog(
                contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                actionsPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 24),
                    Text('내 코스 생성중'),
                  ],
                ),
              ),
              barrierDismissible: false
          );
          Map<String, dynamic>? result = await _courseProvider.postMyCourseData();
          Get.back();
          if (result == null) {
            Get.dialog(
              AlertDialog(
                contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                titlePadding: EdgeInsets.zero,
                content: const Text("새 코스 생성 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
                actions: [
                  TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
                ],
              ),
            );
            return;
          }
          Get.to(() => CourseMainPage(courseId: result['id']))!
            .then((value) {
              initCourseData();
            });
        },
        backgroundColor: lightColorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: _createMyCourseSection(),
        ),
        // child: Column(
        //   children: [
        //     // const SizedBox(height: 24,),
        //     // _recommendKeywordSection(),
        //     const SizedBox(height: 24,),
        //     _createMyCourseSection(),
        //     const SizedBox(height: 24,)
        //   ],
        // ),
      ),
    );
  }

  Widget _recommendKeywordSection() {
    return MainSection(
      title: '인기있는 키워드',
      content: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 24,),
                Expanded(
                  child: Center(
                    child: Text('키워드1', style: SectionTextStyle.sectionContent(Colors.black),),
                  ),
                ),
                const Icon(Icons.keyboard_double_arrow_right_sharp),
                Expanded(
                  child: Center(
                    child: Text('키워드1', style: SectionTextStyle.sectionContent(Colors.black)),
                  ),
                ),
                const Icon(Icons.keyboard_double_arrow_right_sharp),
                Expanded(
                  child: Center(
                    child: Text('키워드1', style: SectionTextStyle.sectionContent(Colors.black)),
                  ),
                ),
                const SizedBox(width: 24,),
              ],
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: 150,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: _recommendKeywordData.length + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0 || index == _recommendKeywordData.length + 1) {
                    return const SizedBox(width: 16,);
                  } else {
                    index -= 1;
                    return RoundedRectangleCourseCard(
                      title: _recommendKeywordData[index]['title'],
                      location: _recommendKeywordData[index]['location'],
                      imageUrls: _recommendKeywordData[index]['background'],
                      width: 230,
                      height: 150,
                      titleStyle: SectionTextStyle.lineContentExtraLarge(Colors.white),
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _createMyCourseSection() {
    if (_loadMyCourseData < 1) {
      return MainSection(
        title: '나의 코스',
        content: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300]
            ),
            padding: const EdgeInsets.all(24),
            child: const Column(
                children: [
                CircularProgressIndicator(),
                SizedBox(height: 12,),
                Text("데이터를 불러오는 중 입니다.")
              ],
            )
          )
        )
      );
    }
    if (_myCourseData == null) {
      return MainSection(
        title: '나의 코스',
        content: Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300]
            ),
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text("데이터를 불러오는 중 오류가 발생했습니다."),
            ),
          ),
        )
      );
    }
    if (_myCourseData!.isEmpty) {
      return MainSection(
        title: '나의 코스',
        content: Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300]
            ),
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text("아직 생성된 나의 코스가 없습니다 :("),
            ),
          ),
        )
      );
    }

    return MainSection(
        title: '나의 코스',
        content: Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Stack(
              children: [
                ListView.separated(
                  controller: _courseScrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _myCourseData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    dynamic? courseLineData = null;
                    if (_myCourseData![index]['routesJson'] != null) {
                      courseLineData = json.decode(_myCourseData![index]['routesJson']);
                    }

                    double distance = 0.0;
                    if (courseLineData != null && courseLineData != '') {
                      if (_myCourseData![index]['placesInCourse'].length > 1) {
                        if (courseLineData!['routes'][0]['distance'] is int) {
                          distance = courseLineData!['routes'][0]['distance'].toDouble();
                        } else {
                          distance = courseLineData!['routes'][0]['distance'];
                        }
                      } else {
                        distance = 0;
                      }
                    }

                    return CourseListCardItem(
                      courseName: _myCourseData![index]['title'],
                      placeCount: _myCourseData![index]['placesInCourse'].length,
                      distance: distance.floor(),
                      placesImageUrls: _myCourseData![index]['placesInCourse'].map((item) {
                        if (item['place']['img_url'] != null) {
                          return "$baseUrlDev/api-recommender/place-photo/?${item['place']['img_url'].split('?')[1]}&max_width=480";
                        } else {
                          return null;
                        }
                      }).toList(),
                      placesName: _myCourseData![index]['placesInCourse'].map((item) => item['place']['name'].toString()).toList(),
                      regionName: courseLineData != null && courseLineData != '' ?
                      courseLineData['region_name'] : '-',
                      onPressed: () {
                        Get.to(() => CourseMainPage(courseId: _myCourseData![index]['id'],))!
                            .then((value) {
                          initCourseData();
                        });
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 12,);
                  },
                ),
                Visibility(
                  visible: loadVisibilityCourse,
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
          )
        )
    );
  }
}