import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/course_provider.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/page/course/course_edit.dart';
import 'package:place_mobile_flutter/page/course/course_map.dart';
import 'package:place_mobile_flutter/page/place/place_detail.dart';
import 'package:place_mobile_flutter/state/bookmark_controller.dart';
import 'package:place_mobile_flutter/state/course_controller.dart';
import 'package:place_mobile_flutter/state/gis_controller.dart';
import 'package:place_mobile_flutter/state/state_const.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/cache/map/map_cache_manager.dart';
import 'package:place_mobile_flutter/util/map/map_layer.dart';
import 'package:place_mobile_flutter/util/map/map_tile_cache.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/course/course_inform_card.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/section/topbar/picture_flexible.dart';
import 'package:place_mobile_flutter/widget/section/topbar/topbar_flexible_button.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseMainPage extends StatefulWidget {
  CourseMainPage({
    required this.courseId,
    Key? key
  }) : super(key: key);

  dynamic courseId;

  @override
  State<StatefulWidget> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends State<CourseMainPage> with TickerProviderStateMixin {
  late final CourseController courseController;
  late final CourseProvider _courseProvider;
  late final UserProvider _userProvider;
  final BookmarkController _bookmarkController = BookmarkController();

  late final AnimationController _likeButtonController;
  late final AnimationController _bookmarkButtonController;

  late final TextEditingController _courseNameController;
  late final TextEditingController _bookmarkNameController;

  late ScrollController _bookmarkScrollController;
  late final CacheManager cacheManager;

  late final MapController _mapController;

  bool likeCourse = false;
  bool bookmarkCourse = false;

  String? _courseNameError;
  String? _bookmarkNameError;

  CourseProvider courseProvider= CourseProvider();

  int initData = -1;

  final List<Map<String, dynamic>> _bookmarkData = [];

  void initCourseData() async {
    // Future<void> loadData() async {
    //   Map<String, dynamic> resultCourse = await courseController.getCoursePlacesData();
    //   if (resultCourse['code'] != ASYNC_SUCCESS) {
    //     return;
    //   }
    //
    //   int resultLine = await courseController.getCourseLineData();
    //   if (resultLine != ASYNC_SUCCESS) {
    //     return;
    //   }
    //
    //   int resultGeocode = await courseController.getGeocodeData();
    //   if (resultGeocode != ASYNC_SUCCESS) {
    //     return;
    //   }
    // }
    // await loadData();
    bool result = await courseController.getCourseData();
    if (result) {
      setState(() {
        initData = 1;
      });

      // courseController.courseLineData.listen((p0) {
      //   print('change');
      //   final double width = MediaQuery.of(context).size.width - 48;
      //   final double height = width / 16 * 9;
      //
      //   final double initZoom;
      //   if (courseController.courseLineData.value != null) {
      //     if (courseController.placesPosition.length > 1) {
      //       initZoom = UnitConverter.calculateZoomLevel(
      //           courseController.courseLineData.value!['routes'][0]['geometry']['coordinates'],
      //           MediaQuery.of(context).size.width - 48,
      //           height < 200 ? 200 : (height < 400 ? height : 400));
      //     } else {
      //       initZoom = 16.5;
      //     }
      //   } else {
      //     initZoom = 15;
      //   }
      //
      //   _mapController.move(LatLng(
      //       courseController.center[0],
      //       courseController.center[1]
      //   ), initZoom);
      //
      //   setState(() {});
      // });
    } else {
      setState(() {
        initData = 0;
      });
    }
  }

  @override
  void initState() {
    courseController = CourseController();
    courseController.courseId = widget.courseId;

    _courseProvider = CourseProvider();
    _userProvider = UserProvider();

    _likeButtonController = AnimationController(vsync: this);
    _bookmarkButtonController = AnimationController(vsync: this);
    _bookmarkScrollController = ScrollController();
    _courseNameController = TextEditingController();
    _bookmarkNameController = TextEditingController();

    _mapController = MapController();

    cacheManager = MapCacheManager.instance;

    initCourseData();
    super.initState();
  }

  @override
  void dispose() {
    _likeButtonController.dispose();
    _bookmarkButtonController.dispose();
    _bookmarkScrollController.dispose();
    _courseNameController.dispose();
    _bookmarkNameController.dispose();
    cacheManager.dispose();
    courseController.dispose();
    Get.delete<CourseController>();
    super.dispose();
  }

  Widget _detailHead() => Obx(() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: AutoSizeText(
                  courseController.title.value,
                  style: PageTextStyle.headlineExtraLarge(Colors.black),
                  maxLines: 1,
                  minFontSize: 24,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                )
              ),
              // const SizedBox(
              //   height: 6,
              // ),
              // Row(
              //   children: [
              //     TagChip(
              //       text: "#자연",
              //       textStyle: SectionTextStyle.labelMediumThick(Colors.white),
              //       padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              //     ),
              //     const SizedBox(width: 4,),
              //     TagChip(
              //       text: "#자연",
              //       textStyle: SectionTextStyle.labelMediumThick(Colors.white),
              //       padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              //     ),
              //     const SizedBox(width: 4,),
              //     TagChip(
              //       text: "#자연",
              //       textStyle: SectionTextStyle.labelMediumThick(Colors.white),
              //       padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                __showBookmarkSelectionSheet();
                // setState(() {
                //   HapticFeedback.lightImpact();
                //   bookmarkCourse = !bookmarkCourse;
                //   if (bookmarkCourse) {
                //     _bookmarkButtonController.animateTo(1);
                //   } else {
                //     _bookmarkButtonController.animateBack(0);
                //   }
                // });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 10, 4, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: 24,
                      // height: 24,
                      child: lottie.Lottie.asset(
                          "assets/lottie/animation_bookmark.json",
                          repeat: false,
                          reverse: false,
                          width: 24,
                          height: 24,
                          controller: _bookmarkButtonController,
                          onLoaded: (conposition) {
                            _bookmarkButtonController.duration = conposition.duration;
                            if (bookmarkCourse) {
                              _bookmarkButtonController.animateTo(1);
                            } else {
                              _bookmarkButtonController.animateBack(0);
                            }
                          }
                      ),
                    ),
                    const Text("북마크")
                  ],
                ),
              ),
            ),
            // const SizedBox(width: 12,),
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       HapticFeedback.lightImpact();
            //       likeCourse = !likeCourse;
            //       if (likeCourse) {
            //         _likeButtonController.animateTo(1);
            //       } else {
            //         _likeButtonController.animateBack(0);
            //       }
            //     });
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(4),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           // width: 24,
            //           // height: 24,
            //           child: lottie.Lottie.asset(
            //               "assets/lottie/animation_like_button.json",
            //               repeat: false,
            //               reverse: false,
            //               width: 28,
            //               height: 28,
            //               controller: _likeButtonController,
            //               onLoaded: (conposition) {
            //                 _likeButtonController.duration = conposition.duration;
            //                 if (likeCourse) {
            //                   _likeButtonController.animateTo(1);
            //                 } else {
            //                   _likeButtonController.animateBack(0);
            //                 }
            //               }
            //           ),
            //         ),
            //         const Text("1.2K")
            //       ],
            //     ),
            //   ),
            // )
          ],
        )
      ],
    ),
  ));

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
      List<dynamic>? result = await _userProvider.getCourseBookmark(page, size, widget.courseId);

      if (result != null) {
        _bookmarkData.addAll(result);
        page++;
      }

      state!(() {
        setState(() {
          loadVisibility = false;
        });
      });
    }

    void addCourseBookmark(String text) async {
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
      bool result = await _bookmarkController.addCourseBookmark(text);
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
                        addCourseBookmark(title);
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
                                      bool isContain = false;
                                      for (var i in courseController.bookmarkData) {
                                        if (i['id'] == _bookmarkData[index]['id']) {
                                          isContain = true;
                                          break;
                                        }
                                      }
                                      return ListTile(
                                        minVerticalPadding: 0,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text("${_bookmarkData[index]['title']}"),
                                        trailing: isContain
                                            ? Icon(Icons.check_box, color: lightColorScheme.primary,)
                                            : Icon(Icons.check_box_outline_blank),
                                        onTap: () async {
                                          bottomState(() {
                                            setState(() {
                                              loadVisibility = true;
                                            });
                                          });
                                          bool result;
                                          if (isContain) {
                                            result = await _userProvider.deleteCourseInBookmark(
                                                _bookmarkData[index]['id'], widget.courseId);
                                          } else {
                                            result = await _userProvider.postCourseInBookmark(
                                                _bookmarkData[index]['id'], widget.courseId);
                                          }
                                          if (result) {
                                            if (isContain) {
                                              int i = 0;
                                              bool find = false;
                                              for (;i < courseController.bookmarkData.length;i++) {
                                                if (courseController.bookmarkData[i]['id'] == _bookmarkData[index]['id']) {
                                                  find = true;
                                                  break;
                                                }
                                              }
                                              if (find) {
                                                courseController.bookmarkData.removeAt(i);
                                              }
                                            } else {
                                              courseController.bookmarkData.add({
                                                'id': _bookmarkData[index]['id'],
                                                'title': _bookmarkData[index]['title']
                                              });
                                            }
                                            bottomState(() {
                                              setState(() {
                                                loadVisibility = false;
                                                isContain = !isContain;
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

  void __showCreateBookmarkDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter dialogState) {
              return AlertDialog(
                title: const Text("북마크 추가"),
                content: TextField(
                  maxLength: 50,
                  controller: _courseNameController,
                  onChanged: (text) {
                    dialogState(() {
                      setState(() {
                        _courseNameError = bookmarkTextFieldValidator(text);
                      });
                    });
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "북마크 이름",
                      errorText: _courseNameError
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('취소', style: TextStyle(color: Colors.red),),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('만들기', style: TextStyle(color: Colors.blue),),
                  )
                ],
              );
            },
          );
        }
    );
  }

  Widget _informationSection() {
    int placeCount = courseController.coursePlaceData.length;
    double distance = 0.0;
    if (courseController.courseLineData.value != null && courseController.courseLineData.value != '') {
      if (courseController.placesPosition.length > 1) {
        if (courseController.courseLineData.value!['routes'][0]['distance'] is int) {
          distance = courseController.courseLineData.value!['routes'][0]['distance'].toDouble();
        } else {
          distance = courseController.courseLineData.value!['routes'][0]['distance'];
        }
      } else {
        distance = 0;
      }
    }
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        children: [
          CourseInformationCard(
            title: '지역',
            content: courseController.regionName.value,
          ),
          const SizedBox(
            width: 12,
          ),
          CourseInformationCard(
            title: '이동 거리',
            content: UnitConverter.formatDistance(distance.floor()),
          ),
          const SizedBox(
            width: 12,
          ),
          CourseInformationCard(
            title: '방문 장소',
            content: '$placeCount곳',
          ),
        ],
      ),
    ));
  }

  List<Widget> __createPlaceList() {
    List<Widget> course = [];
    for (var place in courseController.coursePlaceData) {
      int? distance;
      if (GISController.to.userPosition.value != null) {
        double lat2 = place['place']['location']['lat'];
        double lon2 = place['place']['location']['lon'];
        distance = GISController.to.haversineDistance(lat2, lon2);
      }

      String openString = '정보 없음';
      if (place['place']['opening_hours'] != null) {
        final now = DateTime.now();
        final currentWeekday = now.weekday - 1;
        final currentTime = int.parse(DateFormat('HHmm').format(now));

        final currentDayHours = place['place']['opening_hours'].firstWhere(
              (hours) => hours["weekday"] == currentWeekday,
          orElse: () => null,
        );

        if (currentDayHours != null) {
          final openTime = currentDayHours["open"];
          final closeTime = currentDayHours["close"];

          try {
            if (currentTime >= openTime && currentTime <= closeTime) {
              openString = '영업중';
            } else {
              openString = '영업중 아님';
            }
          } catch(e) {
            openString = '정보 없음';
          }
        }
      }

      course.addAll([
        GestureDetector(
          onTap: () {
            Get.to(() => PlaceDetailPage(placeId: place['place']['id']));
          },
          child: RoundedRowRectanglePlaceCard(
            imageUrl: place['place']['img_url'] != null ?
            ImageParser.parseImageUrl(place['place']['img_url']) :
            null,
            tags: place['place']['hashtags'],
            // tags: [],
            placeName: place['place']['name'],
            placeType: place['place']['category'],
            // open: place['place']['open'],
            open: openString,
            distance: distance == null ? null : UnitConverter.formatDistance(distance),
          ),
        ),
        const SizedBox(height: 12)
      ]);
    }
    course.add(
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double width = constraints.maxWidth - 48;
                final double height = width / 16 * 9;

                final double initZoom;
                if (courseController.courseLineData.value != null) {
                  if (courseController.placesPosition.length > 1) {
                    initZoom = UnitConverter.calculateZoomLevel(
                        courseController.courseLineData.value!['routes'][0]['geometry']['coordinates'],
                        MediaQuery.of(context).size.width - 48,
                        height < 200 ? 200 : (height < 400 ? height : 400));
                  } else {
                    initZoom = 16.5;
                  }
                } else {
                  initZoom = 15;
                }

                print('1 ${courseController.center}');

                final Widget map = FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                      courseController.center[0],
                      courseController.center[1]
                    ),
                    zoom: initZoom,
                    maxZoom: 18,
                    interactiveFlags: InteractiveFlag.none,
                    onTap: (tapPos, cord) {
                      Get.to(() => CourseMapPage(
                        courseController: courseController,
                      ));
                    }
                  ),
                  mapController: _mapController,
                  children: [
                    TileLayer(
                      urlTemplate: '$mapBaseUrl/styles/bright/{z}/{x}/{y}.jpg',
                      userAgentPackageName: 'com.example.app',
                      tileProvider: CacheTileProvider(cacheManager),
                    ),
                    if (courseController.courseLineData.value != null &&
                        courseController.placesPosition.length > 1) PolylineLayer(
                      polylines: MapLayerGenerator.generatePolyLines(
                          courseController.courseLineData.value!['routes'][0]['geometry']['coordinates']),
                    ),
                    if (courseController.placesPosition.isNotEmpty) MarkerLayer(
                      markers: MapLayerGenerator.generateMarkers(
                          courseController.placesPosition.value),
                    )
                  ],
                );

                if (height < 200) {
                  return SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: map,
                  );
                } else {
                  return AspectRatio(
                    aspectRatio: 16/9,
                    child: map,
                  );
                }
              },
            )
        )
    );
    return course;
  }

  Widget _visitPlaceSection() {
    return MainSection(
      title: '장소 목록',
      content: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: courseController.coursePlaceData.isEmpty ?
          Container(
            height: 288,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300]
              ),
              padding: const EdgeInsets.all(24),
              child: const Center(
                child: Text('장소를 추가해주세요!'),
              ),
            ),
          ) :
          Column(
            children: __createPlaceList(),
          )
      ),
    );
  }

  void changeTitle(dynamic courseId, String title) async {
    Get.dialog(
        const AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
          actionsPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 24),
              Text('코스 이름 변경중'),
            ],
          ),
        ),
        barrierDismissible: false
    );

    bool result = await courseController.changeTitle(title);
    Get.back();

    if (result) {

    } else {
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("이름 변경 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
    }
  }

  void deleteCourse(dynamic courseId) async {
    Get.dialog(
        const AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
          actionsPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 24),
              Text('코스 삭제중'),
            ],
          ),
        ),
        barrierDismissible: false
    );

    bool result = await _courseProvider.deleteMyCourseDataById(courseId);
    Get.back();

    if (result) {
      Get.back();
    } else {
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("코스 삭제 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
    }
  }

  void _generateShareUrl() {
    int placeCount = courseController.coursePlaceData.length;
    double distance = 0.0;
    if (courseController.courseLineData.value != null && courseController.courseLineData.value != '') {
      if (courseController.placesPosition.length > 1) {
        if (courseController.courseLineData.value!['routes'][0]['distance'] is int) {
          distance = courseController.courseLineData.value!['routes'][0]['distance'].toDouble();
        } else {
          distance = courseController.courseLineData.value!['routes'][0]['distance'];
        }
      } else {
        distance = 0;
      }
    }

    Map<String, dynamic> shareData = {};
    shareData['title'] = courseController.title.value;
    shareData['region_name'] = courseController.regionName.value;
    shareData['distance'] = UnitConverter.formatDistance(distance.floor());
    shareData['count'] = placeCount;
    shareData['places'] = [];
    for (var place in courseController.coursePlaceData) {
      shareData['places'].add({
        'name': place['place']['name'],
        'img': place['place']['img_url'] != null ?
          ImageParser.parseImageUrl(place['place']['img_url']) :
          null
      });
    }

    String shareJson = json.encode(shareData);
    // log('http://localhost:8080/course?data=${Uri.encodeComponent(shareJson)}');
    Share.share('https://d1neqdrdl1s3ts.cloudfront.net/#/course?data=${Uri.encodeComponent(shareJson)}');
  }

  @override
  Widget build(BuildContext context) {
    if (initData != -1) {
      if (initData == 1) {
        return Scaffold(
          body: CustomScrollView(
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
                      onPressed: _generateShareUrl,
                      icon: Icon(Icons.ios_share, size: 18,)
                  ),
                  SizedBox(width: 6,),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: PopupMenuButton(
                      icon: Icon(Icons.more_vert, size: 18,),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(onTap: () {
                            _courseNameController.text = courseController.title.value;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter dialogState) {
                                      return AlertDialog(
                                        title: Text("코스 이름 변경"),
                                        content: TextField(
                                          maxLength: 50,
                                          controller: _courseNameController,
                                          onChanged: (text) {
                                            dialogState(() {
                                              _courseNameError = courseTextFieldValidator(text);
                                            });
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "북마크 이름",
                                              errorText: _courseNameError
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
                                              final String title = _courseNameController.text.toString();
                                              if (courseTextFieldValidator(title) != null) return;
                                              Navigator.of(context, rootNavigator: true).pop();
                                              if (courseController.title.value == title) return;
                                              changeTitle(courseController.courseId, title);
                                            },
                                            child: Text('변경', style: TextStyle(color: Colors.blue),),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                            );
                          }, child: const Text('이름 변경'),),
                          PopupMenuItem(onTap: () {
                            deleteCourse(courseController.courseId);
                          }, child: const Text('삭제'),)
                        ];
                      },
                    ),
                  ),
                  SizedBox(width: 12,)
                ],
                pinned: true,
                expandedHeight: 220.0,
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                flexibleSpace: Obx(() {
                  return MultiplePictureFlexibleSpace(
                    imageUrl: courseController.coursePlaceData
                        .map<String?>((item) => ImageParser.parseImageUrl(item['place']['img_url'])).toList(),
                  );
                }),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _detailHead(),
                  const SizedBox(height: 12,),
                  _informationSection(),
                  const SizedBox(height: 24,),
                  _visitPlaceSection(),
                  const SizedBox(height: 24,),
                ]),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => CourseEditPage(
                courseController: courseController,
                cacheManager: cacheManager,
              ))!
              .then((value) {
                setState(() {});
                final double width = MediaQuery.of(context).size.width - 48;
                final double height = width / 16 * 9;

                final double initZoom;
                if (courseController.courseLineData.value != null) {
                  if (courseController.placesPosition.length > 1) {
                    initZoom = UnitConverter.calculateZoomLevel(
                        courseController.courseLineData.value!['routes'][0]['geometry']['coordinates'],
                        MediaQuery.of(context).size.width - 48,
                        height < 200 ? 200 : (height < 400 ? height : 400));
                  } else {
                    initZoom = 16.5;
                  }
                } else {
                  initZoom = 15;
                }

                _mapController.move(LatLng(
                    courseController.center[0],
                    courseController.center[1]
                ), initZoom);
              });
            },
            backgroundColor: lightColorScheme.primary,
            shape: const CircleBorder(),
            child: const Icon(Icons.edit, color: Colors.white,),
          ),
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
      return Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Shimmer.fromColors(
                baseColor: const Color.fromRGBO(240, 240, 240, 1),
                highlightColor: Colors.grey[300]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(240, 240, 240, 1),
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Container(
                          width: 195,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 240, 240, 1),
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Container(
                          width: 145,
                          height: 25,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 240, 240, 1),
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: Container(
                          width: 185,
                          height: 25,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 240, 240, 1),
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: Container(
                          width: 86,
                          height: 25,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 240, 240, 1),
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 240, 240, 1),
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 240, 240, 1),
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    }
  }
}
