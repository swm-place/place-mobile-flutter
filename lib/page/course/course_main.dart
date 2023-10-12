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
import 'package:lottie/lottie.dart' as lottie;
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/map/course_provider.dart';
import 'package:place_mobile_flutter/page/course/course_edit.dart';
import 'package:place_mobile_flutter/page/course/course_map.dart';
import 'package:place_mobile_flutter/state/course_controller.dart';
import 'package:place_mobile_flutter/state/place_controller.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
  late final CacheManager cacheManager;

  bool likeCourse = false;
  bool bookmarkCourse = false;

  String? _bookmarkNameError;

  CourseProvider courseProvider= CourseProvider();

  bool initData = false;

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

  void initCourseData() async {
    Future<void> loadData() async {
      Map<String, dynamic> resultCourse = await CourseController.to.getCourseData();
      if (resultCourse['code'] != ASYNC_SUCCESS) {
        return;
      }

      int resultLine = await CourseController.to.getCourseLineData();
      if (resultLine != ASYNC_SUCCESS) {
        return;
      }

      int resultGeocode = await CourseController.to.getGeocodeData();
      if (resultGeocode != ASYNC_SUCCESS) {
        return;
      }
    }
    await loadData();
    setState(() {
      initData = true;
    });
  }

  @override
  void initState() {
    Get.put(CourseController());

    _likeButtonController = AnimationController(vsync: this);
    _bookmarkButtonController = AnimationController(vsync: this);
    _bookmarkScrollController = ScrollController();
    _bookmarkNameController = TextEditingController();

    cacheManager = MapCacheManager.instance;

    initCourseData();
    super.initState();
  }

  @override
  void dispose() {
    _likeButtonController.dispose();
    _bookmarkButtonController.dispose();
    _bookmarkScrollController.dispose();
    _bookmarkNameController.dispose();
    cacheManager.dispose();
    Get.delete<CourseController>();
    super.dispose();
  }

  Widget _detailHead() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  TagChip(
                    text: "#자연",
                    textStyle: SectionTextStyle.labelMediumThick(Colors.white),
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                  ),
                  const SizedBox(width: 4,),
                  TagChip(
                    text: "#자연",
                    textStyle: SectionTextStyle.labelMediumThick(Colors.white),
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                  ),
                  const SizedBox(width: 4,),
                  TagChip(
                    text: "#자연",
                    textStyle: SectionTextStyle.labelMediumThick(Colors.white),
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
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
                  bookmarkCourse = !bookmarkCourse;
                  if (bookmarkCourse) {
                    _bookmarkButtonController.animateTo(1);
                  } else {
                    _bookmarkButtonController.animateBack(0);
                  }
                });
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
                    const Text("븍마크")
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12,),
            GestureDetector(
              onTap: () {
                setState(() {
                  HapticFeedback.lightImpact();
                  likeCourse = !likeCourse;
                  if (likeCourse) {
                    _likeButtonController.animateTo(1);
                  } else {
                    _likeButtonController.animateBack(0);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: 24,
                      // height: 24,
                      child: lottie.Lottie.asset(
                          "assets/lottie/animation_like_button.json",
                          repeat: false,
                          reverse: false,
                          width: 28,
                          height: 28,
                          controller: _likeButtonController,
                          onLoaded: (conposition) {
                            _likeButtonController.duration = conposition.duration;
                            if (likeCourse) {
                              _likeButtonController.animateTo(1);
                            } else {
                              _likeButtonController.animateBack(0);
                            }
                          }
                      ),
                    ),
                    const Text("1.2K")
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
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
                    const SizedBox(height: 18,),
                    Expanded(
                        child: Scrollbar(
                          controller: _bookmarkScrollController,
                          child: ListView.separated(
                            controller: _bookmarkScrollController,
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            itemCount: _bookmarkData.length + 1,
                            itemBuilder: (context, index) {
                              if (index < _bookmarkData.length) {
                                return ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("${_bookmarkData[index]['name']} $index"),
                                  trailing: _bookmarkData[index]['include']
                                      ? Icon(Icons.check_box, color: lightColorScheme.primary,)
                                      : const Icon(Icons.check_box_outline_blank),
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
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('닫기')
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
                title: const Text("북마크 추가"),
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
                      border: const OutlineInputBorder(),
                      hintText: "북마크 이름",
                      errorText: _bookmarkNameError
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
    int placeCount = CourseController.to.coursePlaceData.length;
    double distance = 0.0;
    if (CourseController.to.courseLineData.value != null) {
      if (CourseController.to.courseLineData.value!['routes'][0]['distance'] is int) {
        distance = CourseController.to.courseLineData.value!['routes'][0]['distance'].toDouble();
      } else {
        distance = CourseController.to.courseLineData.value!['routes'][0]['distance'];
      }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        children: [
          CourseInformationCard(
            title: '지역',
            content: CourseController.to.regionName.value,
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
    );
  }

  List<Widget> __createPlaceList() {
    List<Widget> course = [];
    for (var place in CourseController.to.coursePlaceData) {
      int? distance;
      if (PlaceController.to.userPosition.value != null) {
        double lat2 = place['location']['lat'];
        double lon2 = place['location']['lon'];
        distance = PlaceController.to.haversineDistance(lat2, lon2);
      }
      course.addAll([
        RoundedRowRectanglePlaceCard(
          imageUrl: place['imageUrl'],
          tags: place['tags'],
          placeName: place['placeName'],
          placeType: place['placeType'],
          open: place['open'],
          distance: distance == null ? null : UnitConverter.formatDistance(distance),
        ),
        const SizedBox(height: 12)
      ]);
    }
    course.add(
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double width = constraints.maxWidth;
                final double height = width / 16 * 9;

                final double initZoom = UnitConverter.calculateZoomLevel(
                    CourseController.to.courseLineData.value!['routes'][0]['geometry']['coordinates'],
                    constraints.maxWidth,
                    height < 200 ? 200 : height);

                final Widget map = FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                      CourseController.to.center[0],
                      CourseController.to.center[1]
                    ),
                    zoom: initZoom,
                    maxZoom: 18,
                    interactiveFlags: InteractiveFlag.none,
                    onTap: (tapPos, cord) {
                      Get.to(() => CourseMapPage());
                    }
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: '$mapBaseUrl/styles/bright/{z}/{x}/{y}.jpg',
                      userAgentPackageName: 'com.example.app',
                      tileProvider: CacheTileProvider(cacheManager),
                    ),
                    if (CourseController.to.courseLineData.value != null) PolylineLayer(
                      polylines: MapLayerGenerator.generatePolyLines(
                          CourseController.to.courseLineData.value!['routes'][0]['geometry']['coordinates']),
                    ),
                    if (CourseController.to.courseLineData.value != null) MarkerLayer(
                      markers: MapLayerGenerator.generateMarkers(
                          CourseController.to.courseLineData.value!['waypoints']),
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
        child: Column(
          children: __createPlaceList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold;
    if (initData) {
      scaffold = Scaffold(
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
            Obx(() {
              return SliverList(
                delegate: SliverChildListDelegate([
                  _detailHead(),
                  const SizedBox(height: 24,),
                  _informationSection(),
                  const SizedBox(height: 24,),
                  _visitPlaceSection(),
                  const SizedBox(height: 24,),
                ]),
              );
            })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => CourseEditPage());
          },
          backgroundColor: lightColorScheme.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.edit, color: Colors.white,),
        ),
      );
    } else {
      scaffold = const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return scaffold;
  }
}
