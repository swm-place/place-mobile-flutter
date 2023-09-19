import 'dart:io';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:place_mobile_flutter/page/course/course_map.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
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
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

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

  bool likeCourse = false;
  bool bookmarkCourse = false;

  String? _bookmarkNameError;

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
                  bookmarkCourse = !bookmarkCourse;
                  if (bookmarkCourse) {
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
                            if (bookmarkCourse) {
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
                  likeCourse = !likeCourse;
                  if (likeCourse) {
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
                            if (likeCourse) {
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

  Widget _informationSection() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
    child: Row(
      children: [
        CourseInformationCard(
          title: '지역',
          content: '서울시 강남구',
        ),
        const SizedBox(width: 12,),
        CourseInformationCard(
          title: '이동 거리',
          content: '2.4 km',
        ),
        const SizedBox(width: 12,),
        CourseInformationCard(
          title: '방문 장소',
          content: '5곳',
        ),
      ],
    ),
  );

  Widget _visitPlaceSection() {
    // MaplibreMapController controller = MaplibreMapController(
    //     mapboxGlPlatform: mapboxGlPlatform,
    //     initialCameraPosition: initialCameraPosition,
    //     annotationOrder: annotationOrder,
    //     annotationConsumeTapEvents: annotationConsumeTapEvents
    // );

    // final MaplibreMap map = MaplibreMap(
    //   initialCameraPosition: CameraPosition(
    //     target: LatLng(37.5036, 127.0448),
    //     zoom: 7.0,
    //   ),
    // );

    VectorTileProvider _tileProvider() => NetworkVectorTileProvider(
      urlTemplate: 'http://192.168.0.2:8080/data/openmaptiles/{z}/{x}/{y}.pbf',
      maximumZoom: 14,
      minimumZoom: 10
    );

    return MainSection(
      title: '장소 목록',
      content: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: Column(
          children: [
            RoundedRowRectanglePlaceCard(),
            SizedBox(height: 12,),
            RoundedRowRectanglePlaceCard(),
            SizedBox(height: 12,),
            RoundedRowRectanglePlaceCard(),
            SizedBox(height: 12,),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16/9,
                child: FlutterMap(
                  options: MapOptions(
                    center: const LatLng(37.5036, 127.0448),
                    zoom: 14,
                  ),
                  // nonRotatedChildren: [
                  //   RichAttributionWidget(
                  //     attributions: [
                  //       TextSourceAttribution(
                  //         'OpenStreetMap contributors',
                  //         onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  //       ),
                  //     ],
                  //   ),
                  // ],
                  children: [
                    // TileLayer(
                    //   urlTemplate: 'http://192.168.0.2:8080/styles/test-style/{z}/{x}/{y}.png',
                    //   // urlTemplate: 'http://localhost:50001/tile/v1/foot/tile({x},{y},{z}).mvt',
                    //   userAgentPackageName: 'com.example.app',
                    // ),
                    VectorTileLayer(
                      tileProviders: TileProviders({
                        'openmaptiles': _tileProvider(),
                      }),
                      theme: ThemeReader().read({"version":8,"name":"OSM Bright","metadata":{"mapbox:type":"template","mapbox:groups":{"1444849364238.8171":{"collapsed":false,"name":"Buildings"},"1444849354174.1904":{"collapsed":true,"name":"Tunnels"},"1444849388993.3071":{"collapsed":false,"name":"Land"},"1444849242106.713":{"collapsed":false,"name":"Places"},"1444849382550.77":{"collapsed":false,"name":"Water"},"1444849345966.4436":{"collapsed":false,"name":"Roads"},"1444849334699.1902":{"collapsed":true,"name":"Bridges"}},"mapbox:autocomposite":true,"openmaptiles:version":"3.x"},"center":[-120.97945979949654,47.82891995412305],"zoom":7.194570163444179,"bearing":0,"pitch":0,"sources":{"openmaptiles":{"type":"vector","url":"http://localhost:8080/data/openmaptiles.json"}},"sprite":"http://localhost:8080/styles/test-style/sprite","glyphs":"http://localhost:8080/fonts/{fontstack}/{range}.pbf","layers":[{"id":"background","type":"background","paint":{"background-color":"#f8f4f0"}},{"id":"landcover-glacier","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landcover","filter":["==","subclass","glacier"],"layout":{"visibility":"visible"},"paint":{"fill-color":"#fff","fill-opacity":{"base":1,"stops":[[0,0.9],[10,0.3]]}}},{"id":"landuse-residential","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landuse","filter":["==","class","residential"],"paint":{"fill-color":{"base":1,"stops":[[12,"hsla(30, 19%, 90%, 0.4)"],[16,"hsla(30, 19%, 90%, 0.2)"]]}}},{"id":"landuse-commercial","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landuse","filter":["all",["==","\$type","Polygon"],["==","class","commercial"]],"paint":{"fill-color":"hsla(0, 60%, 87%, 0.23)"}},{"id":"landuse-industrial","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landuse","filter":["all",["==","\$type","Polygon"],["==","class","industrial"]],"paint":{"fill-color":"hsla(49, 100%, 88%, 0.34)"}},{"id":"park","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"park","filter":["==","\$type","Polygon"],"paint":{"fill-color":"#d8e8c8","fill-opacity":{"base":1.8,"stops":[[9,0.5],[12,0.2]]}}},{"id":"park-outline","type":"line","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"park","filter":["==","\$type","Polygon"],"layout":{},"paint":{"line-color":{"base":1,"stops":[[6,"hsla(96, 40%, 49%, 0.36)"],[8,"hsla(96, 40%, 49%, 0.66)"]]},"line-dasharray":[3,3]}},{"id":"landuse-cemetery","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landuse","filter":["==","class","cemetery"],"paint":{"fill-color":"#e0e4dd"}},{"id":"landuse-hospital","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landuse","filter":["==","class","hospital"],"paint":{"fill-color":"#fde"}},{"id":"landuse-school","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landuse","filter":["==","class","school"],"paint":{"fill-color":"#f0e8f8"}},{"id":"landuse-railway","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landuse","filter":["==","class","railway"],"paint":{"fill-color":"hsla(30, 19%, 90%, 0.4)"}},{"id":"landcover-wood","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landcover","filter":["==","class","wood"],"paint":{"fill-color":"#6a4","fill-opacity":0.1,"fill-outline-color":"hsla(0, 0%, 0%, 0.03)","fill-antialias":{"base":1,"stops":[[0,false],[9,true]]}}},{"id":"landcover-grass","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"landcover","filter":["==","class","grass"],"paint":{"fill-color":"#d8e8c8","fill-opacity":1}},{"id":"landcover-grass-park","type":"fill","metadata":{"mapbox:group":"1444849388993.3071"},"source":"openmaptiles","source-layer":"park","filter":["==","class","public_park"],"paint":{"fill-color":"#d8e8c8","fill-opacity":0.8}},{"id":"waterway-other","type":"line","metadata":{"mapbox:group":"1444849382550.77"},"source":"openmaptiles","source-layer":"waterway","filter":["!in","class","canal","river","stream"],"layout":{"line-cap":"round"},"paint":{"line-color":"#a0c8f0","line-width":{"base":1.3,"stops":[[13,0.5],[20,2]]}}},{"id":"waterway-stream-canal","type":"line","metadata":{"mapbox:group":"1444849382550.77"},"source":"openmaptiles","source-layer":"waterway","filter":["in","class","canal","stream"],"layout":{"line-cap":"round"},"paint":{"line-color":"#a0c8f0","line-width":{"base":1.3,"stops":[[13,0.5],[20,6]]}}},{"id":"waterway-river","type":"line","metadata":{"mapbox:group":"1444849382550.77"},"source":"openmaptiles","source-layer":"waterway","filter":["==","class","river"],"layout":{"line-cap":"round"},"paint":{"line-color":"#a0c8f0","line-width":{"base":1.2,"stops":[[10,0.8],[20,6]]}}},{"id":"water-offset","type":"fill","metadata":{"mapbox:group":"1444849382550.77"},"source":"openmaptiles","source-layer":"water","maxzoom":8,"filter":["==","\$type","Polygon"],"layout":{"visibility":"visible"},"paint":{"fill-opacity":1,"fill-color":"#a0c8f0","fill-translate":{"base":1,"stops":[[6,[2,0]],[8,[0,0]]]}}},{"id":"water","type":"fill","metadata":{"mapbox:group":"1444849382550.77"},"source":"openmaptiles","source-layer":"water","layout":{"visibility":"visible"},"paint":{"fill-color":"hsl(210, 67%, 85%)"}},{"id":"water-pattern","metadata":{"mapbox:group":"1444849382550.77"},"ref":"water","paint":{"fill-translate":[0,2.5],"fill-pattern":"wave"}},{"id":"landcover-ice-shelf","type":"fill","metadata":{"mapbox:group":"1444849382550.77"},"source":"openmaptiles","source-layer":"landcover","filter":["==","subclass","ice_shelf"],"layout":{"visibility":"visible"},"paint":{"fill-color":"#fff","fill-opacity":{"base":1,"stops":[[0,0.9],[10,0.3]]}}},{"id":"building","type":"fill","metadata":{"mapbox:group":"1444849364238.8171"},"source":"openmaptiles","source-layer":"building","paint":{"fill-color":{"base":1,"stops":[[15.5,"#f2eae2"],[16,"#dfdbd7"]]},"fill-antialias":true}},{"id":"building-top","type":"fill","metadata":{"mapbox:group":"1444849364238.8171"},"source":"openmaptiles","source-layer":"building","layout":{"visibility":"visible"},"paint":{"fill-translate":{"base":1,"stops":[[14,[0,0]],[16,[-2,-2]]]},"fill-outline-color":"#dfdbd7","fill-color":"#f2eae2","fill-opacity":{"base":1,"stops":[[13,0],[16,1]]}}},{"id":"tunnel-service-track-casing","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","tunnel"],["in","class","service","track"]],"layout":{"line-join":"round"},"paint":{"line-color":"#cfcdca","line-dasharray":[0.5,0.25],"line-width":{"base":1.2,"stops":[[15,1],[16,4],[20,11]]}}},{"id":"tunnel-minor-casing","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","tunnel"],["==","class","minor"]],"layout":{"line-join":"round"},"paint":{"line-color":"#cfcdca","line-opacity":{"stops":[[12,0],[12.5,1]]},"line-width":{"base":1.2,"stops":[[12,0.5],[13,1],[14,4],[20,15]]}}},{"id":"tunnel-secondary-tertiary-casing","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","tunnel"],["in","class","secondary","tertiary"]],"layout":{"line-join":"round"},"paint":{"line-color":"#e9ac77","line-opacity":1,"line-width":{"base":1.2,"stops":[[8,1.5],[20,17]]}}},{"id":"tunnel-trunk-primary-casing","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","tunnel"],["in","class","primary","trunk"]],"layout":{"line-join":"round"},"paint":{"line-color":"#e9ac77","line-width":{"base":1.2,"stops":[[5,0.4],[6,0.6],[7,1.5],[20,22]]}}},{"id":"tunnel-motorway-casing","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","tunnel"],["==","class","motorway"]],"layout":{"line-join":"round","visibility":"visible"},"paint":{"line-color":"#e9ac77","line-dasharray":[0.5,0.25],"line-width":{"base":1.2,"stops":[[5,0.4],[6,0.6],[7,1.5],[20,22]]}}},{"id":"tunnel-path","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","\$type","LineString"],["all",["==","brunnel","tunnel"],["==","class","path"]]],"paint":{"line-color":"#cba","line-dasharray":[1.5,0.75],"line-width":{"base":1.2,"stops":[[15,1.2],[20,4]]}}},{"id":"tunnel-service-track","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","tunnel"],["in","class","service","track"]],"layout":{"line-join":"round"},"paint":{"line-color":"#fff","line-width":{"base":1.2,"stops":[[15.5,0],[16,2],[20,7.5]]}}},{"id":"tunnel-minor","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","tunnel"],["==","class","minor_road"]],"layout":{"line-join":"round"},"paint":{"line-color":"#fff","line-opacity":1,"line-width":{"base":1.2,"stops":[[13.5,0],[14,2.5],[20,11.5]]}}},{"id":"tunnel-secondary-tertiary","metadata":{"mapbox:group":"1444849354174.1904"},"ref":"tunnel-secondary-tertiary-casing","paint":{"line-color":"#fff4c6","line-width":{"base":1.2,"stops":[[6.5,0],[7,0.5],[20,10]]}}},{"id":"tunnel-trunk-primary","metadata":{"mapbox:group":"1444849354174.1904"},"ref":"tunnel-trunk-primary-casing","paint":{"line-color":"#fff4c6","line-width":{"base":1.2,"stops":[[6.5,0],[7,0.5],[20,18]]}}},{"id":"tunnel-motorway","metadata":{"mapbox:group":"1444849354174.1904"},"ref":"tunnel-motorway-casing","paint":{"line-color":"#ffdaa6","line-width":{"base":1.2,"stops":[[6.5,0],[7,0.5],[20,18]]}}},{"id":"tunnel-railway","type":"line","metadata":{"mapbox:group":"1444849354174.1904"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","tunnel"],["==","class","rail"]],"paint":{"line-color":"#bbb","line-width":{"base":1.4,"stops":[[14,0.4],[15,0.75],[20,2]]},"line-dasharray":[2,2]}},{"id":"highway-area","type":"fill","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["==","\$type","Polygon"],"layout":{"visibility":"visible"},"paint":{"fill-color":"hsla(0, 0%, 89%, 0.56)","fill-outline-color":"#cfcdca","fill-opacity":0.9,"fill-antialias":false}},{"id":"highway-motorway-link-casing","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","minzoom":12,"filter":["all",["!in","brunnel","bridge","tunnel"],["==","class","motorway_link"]],"layout":{"line-cap":"round","line-join":"round"},"paint":{"line-color":"#e9ac77","line-opacity":1,"line-width":{"base":1.2,"stops":[[12,1],[13,3],[14,4],[20,15]]}}},{"id":"highway-link-casing","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","minzoom":13,"filter":["all",["!in","brunnel","bridge","tunnel"],["in","class","primary_link","secondary_link","tertiary_link","trunk_link"]],"layout":{"line-cap":"round","line-join":"round","visibility":"visible"},"paint":{"line-color":"#e9ac77","line-opacity":1,"line-width":{"base":1.2,"stops":[[12,1],[13,3],[14,4],[20,15]]}}},{"id":"highway-minor-casing","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","\$type","LineString"],["all",["!=","brunnel","tunnel"],["in","class","minor","service","track"]]],"layout":{"line-cap":"round","line-join":"round"},"paint":{"line-color":"#cfcdca","line-opacity":{"stops":[[12,0],[12.5,1]]},"line-width":{"base":1.2,"stops":[[12,0.5],[13,1],[14,4],[20,15]]}}},{"id":"highway-secondary-tertiary-casing","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["!in","brunnel","bridge","tunnel"],["in","class","secondary","tertiary"]],"layout":{"line-cap":"round","line-join":"round","visibility":"visible"},"paint":{"line-color":"#e9ac77","line-opacity":1,"line-width":{"base":1.2,"stops":[[8,1.5],[20,17]]}}},{"id":"highway-trunk-primary-casing","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["!in","brunnel","bridge","tunnel"],["in","class","primary","trunk"]],"layout":{"line-cap":"round","line-join":"round","visibility":"visible"},"paint":{"line-color":"#e9ac77","line-opacity":1,"line-width":{"base":1.2,"stops":[[5,0.4],[6,0.6],[7,1.5],[20,22]]}}},{"id":"highway-motorway-casing","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","minzoom":5,"filter":["all",["!in","brunnel","bridge","tunnel"],["==","class","motorway"]],"layout":{"line-cap":"round","line-join":"round","visibility":"visible"},"paint":{"line-color":"#e9ac77","line-width":{"base":1.2,"stops":[[5,0.4],[6,0.6],[7,1.5],[20,22]]}}},{"id":"highway-path","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","\$type","LineString"],["all",["!in","brunnel","bridge","tunnel"],["==","class","path"]]],"paint":{"line-color":"#cba","line-dasharray":[1.5,0.75],"line-width":{"base":1.2,"stops":[[15,1.2],[20,4]]}}},{"id":"highway-motorway-link","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","minzoom":12,"filter":["all",["!in","brunnel","bridge","tunnel"],["==","class","motorway_link"]],"layout":{"line-cap":"round","line-join":"round"},"paint":{"line-color":"#fc8","line-width":{"base":1.2,"stops":[[12.5,0],[13,1.5],[14,2.5],[20,11.5]]}}},{"id":"highway-link","metadata":{"mapbox:group":"1444849345966.4436"},"ref":"highway-link-casing","paint":{"line-color":"#fea","line-width":{"base":1.2,"stops":[[12.5,0],[13,1.5],[14,2.5],[20,11.5]]}}},{"id":"highway-minor","metadata":{"mapbox:group":"1444849345966.4436"},"ref":"highway-minor-casing","paint":{"line-color":"#fff","line-opacity":1,"line-width":{"base":1.2,"stops":[[13.5,0],[14,2.5],[20,11.5]]}}},{"id":"highway-secondary-tertiary","metadata":{"mapbox:group":"1444849345966.4436"},"ref":"highway-secondary-tertiary-casing","paint":{"line-color":"#fea","line-width":{"base":1.2,"stops":[[6.5,0],[8,0.5],[20,13]]}}},{"id":"highway-trunk-primary","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","\$type","LineString"],["all",["!in","brunnel","bridge","tunnel"],["in","class","primary","trunk"]]],"layout":{"line-cap":"round","line-join":"round","visibility":"visible"},"paint":{"line-color":"#fea","line-width":{"base":1.2,"stops":[[6.5,0],[7,0.5],[20,18]]}}},{"id":"highway-motorway","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","minzoom":5,"filter":["all",["==","\$type","LineString"],["all",["!in","brunnel","bridge","tunnel"],["==","class","motorway"]]],"layout":{"line-cap":"round","line-join":"round","visibility":"visible"},"paint":{"line-color":"#fc8","line-width":{"base":1.2,"stops":[[6.5,0],[7,0.5],[20,18]]}}},{"id":"railway-service","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","\$type","LineString"],["all",["==","class","rail"],["has","service"]]],"paint":{"line-color":"hsla(0, 0%, 73%, 0.77)","line-width":{"base":1.4,"stops":[[14,0.4],[20,1]]}}},{"id":"railway-service-hatching","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","\$type","LineString"],["all",["==","class","rail"],["has","service"]]],"layout":{"visibility":"visible"},"paint":{"line-color":"hsla(0, 0%, 73%, 0.68)","line-dasharray":[0.2,8],"line-width":{"base":1.4,"stops":[[14.5,0],[15,2],[20,6]]}}},{"id":"railway","type":"line","metadata":{"mapbox:group":"1444849345966.4436"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","\$type","LineString"],["all",["!has","service"],["!in","brunnel","bridge","tunnel"],["==","class","rail"]]],"paint":{"line-color":"#bbb","line-width":{"base":1.4,"stops":[[14,0.4],[15,0.75],[20,2]]}}},{"id":"railway-hatching","metadata":{"mapbox:group":"1444849345966.4436"},"ref":"railway","paint":{"line-color":"#bbb","line-dasharray":[0.2,8],"line-width":{"base":1.4,"stops":[[14.5,0],[15,3],[20,8]]}}},{"id":"bridge-motorway-link-casing","type":"line","metadata":{"mapbox:group":"1444849334699.1902"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","bridge"],["==","class","motorway_link"]],"layout":{"line-join":"round"},"paint":{"line-color":"#e9ac77","line-opacity":1,"line-width":{"base":1.2,"stops":[[12,1],[13,3],[14,4],[20,15]]}}},{"id":"bridge-link-casing","type":"line","metadata":{"mapbox:group":"1444849334699.1902"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","bridge"],["in","class","primary_link","secondary_link","tertiary_link","trunk_link"]],"layout":{"line-join":"round"},"paint":{"line-color":"#e9ac77","line-opacity":1,"line-width":{"base":1.2,"stops":[[12,1],[13,3],[14,4],[20,15]]}}},{"id":"bridge-secondary-tertiary-casing","type":"line","metadata":{"mapbox:group":"1444849334699.1902"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","bridge"],["in","class","secondary","tertiary"]],"layout":{"line-join":"round"},"paint":{"line-color":"#e9ac77","line-opacity":1,"line-width":{"base":1.2,"stops":[[8,1.5],[20,28]]}}},{"id":"bridge-trunk-primary-casing","type":"line","metadata":{"mapbox:group":"1444849334699.1902"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","bridge"],["in","class","primary","trunk"]],"layout":{"line-join":"round"},"paint":{"line-color":"hsl(28, 76%, 67%)","line-width":{"base":1.2,"stops":[[5,0.4],[6,0.6],[7,1.5],[20,26]]}}},{"id":"bridge-motorway-casing","type":"line","metadata":{"mapbox:group":"1444849334699.1902"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","brunnel","bridge"],["==","class","motorway"]],"layout":{"line-join":"round"},"paint":{"line-color":"#e9ac77","line-width":{"base":1.2,"stops":[[5,0.4],[6,0.6],[7,1.5],[20,22]]}}},{"id":"bridge-path-casing","type":"line","metadata":{"mapbox:group":"1444849334699.1902"},"source":"openmaptiles","source-layer":"transportation","filter":["all",["==","\$type","LineString"],["all",["==","brunnel","bridge"],["==","class","path"]]],"paint":{"line-color":"#f8f4f0","line-width":{"base":1.2,"stops":[[15,1.2],[20,18]]}}},{"id":"bridge-path","metadata":{"mapbox:group":"1444849334699.1902"},"ref":"bridge-path-casing","paint":{"line-color":"#cba","line-width":{"base":1.2,"stops":[[15,1.2],[20,4]]},"line-dasharray":[1.5,0.75]}},{"id":"bridge-motorway-link","metadata":{"mapbox:group":"1444849334699.1902"},"ref":"bridge-motorway-link-casing","paint":{"line-color":"#fc8","line-width":{"base":1.2,"stops":[[12.5,0],[13,1.5],[14,2.5],[20,11.5]]}}},{"id":"bridge-link","metadata":{"mapbox:group":"1444849334699.1902"},"ref":"bridge-link-casing","paint":{"line-color":"#fea","line-width":{"base":1.2,"stops":[[12.5,0],[13,1.5],[14,2.5],[20,11.5]]}}},{"id":"bridge-secondary-tertiary","metadata":{"mapbox:group":"1444849334699.1902"},"ref":"bridge-secondary-tertiary-casing","paint":{"line-color":"#fea","line-width":{"base":1.2,"stops":[[6.5,0],[7,0.5],[20,20]]}}},{"id":"bridge-trunk-primary","metadata":{"mapbox:group":"1444849334699.1902"},"ref":"bridge-trunk-primary-casing","paint":{"line-color":"#fea","line-width":{"base":1.2,"stops":[[6.5,0],[7,0.5],[20,18]]}}},{"id":"bridge-motorway","metadata":{"mapbox:group":"1444849334699.1902"},"ref":"bridge-motorway-casing","paint":{"line-color":"#fc8","line-width":{"base":1.2,"stops":[[6.5,0],[7,0.5],[20,18]]}}},{"id":"bridge-railway","type":"line","metadata":{"mapbox:group":"1444849334699.1902"},"source":"openmaptiles","source-layer":"railway","filter":["all",["==","brunnel","bridge"],["==","class","rail"]],"paint":{"line-color":"#bbb","line-width":{"base":1.4,"stops":[[14,0.4],[15,0.75],[20,2]]}}},{"id":"bridge-railway-hatching","metadata":{"mapbox:group":"1444849334699.1902"},"ref":"bridge-railway","paint":{"line-color":"#bbb","line-dasharray":[0.2,8],"line-width":{"base":1.4,"stops":[[14.5,0],[15,3],[20,8]]}}},{"id":"boundary-level-4","type":"line","source":"openmaptiles","source-layer":"boundary","filter":["in","admin_level",4,6,8],"layout":{"line-join":"round"},"paint":{"line-color":"#9e9cab","line-dasharray":[3,1,1,1],"line-width":{"base":1.4,"stops":[[4,0.4],[5,1],[12,3]]}}},{"id":"boundary-level-2","type":"line","source":"openmaptiles","source-layer":"boundary","filter":["==","admin_level",2],"layout":{"line-cap":"round","line-join":"round"},"paint":{"line-color":"hsl(248, 7%, 66%)","line-width":{"base":1,"stops":[[0,0.6],[4,1.4],[5,2],[12,8]]}}},{"id":"waterway-name","type":"symbol","source":"openmaptiles","source-layer":"waterway","minzoom":13,"filter":["all",["==","\$type","LineString"],["has","name"]],"layout":{"text-font":["Open Sans Italic"],"text-size":14,"text-field":"{name}","text-max-width":5,"text-rotation-alignment":"map","symbol-placement":"line","text-letter-spacing":0.2,"symbol-spacing":350},"paint":{"text-color":"#74aee9","text-halo-width":1.5,"text-halo-color":"rgba(255,255,255,0.7)"}},{"id":"water-name-lakeline","type":"symbol","source":"openmaptiles","source-layer":"water_name","filter":["==","\$type","LineString"],"layout":{"text-font":["Open Sans Italic"],"text-size":14,"text-field":"{name}","text-max-width":5,"text-rotation-alignment":"map","symbol-placement":"line","symbol-spacing":350,"text-letter-spacing":0.2},"paint":{"text-color":"#74aee9","text-halo-width":1.5,"text-halo-color":"rgba(255,255,255,0.7)"}},{"id":"water-name","type":"symbol","source":"openmaptiles","source-layer":"water_name","filter":["==","\$type","Point"],"layout":{"text-font":["Open Sans Italic"],"text-size":14,"text-field":"{name}","text-max-width":5,"text-rotation-alignment":"map","symbol-placement":"line","symbol-spacing":350,"text-letter-spacing":0.2},"paint":{"text-color":"#74aee9","text-halo-width":1.5,"text-halo-color":"rgba(255,255,255,0.7)"}},{"id":"poi-level-3","type":"symbol","source":"openmaptiles","source-layer":"poi","minzoom":16,"filter":["all",["==","\$type","Point"],[">=","rank",25]],"layout":{"text-padding":2,"text-font":["Open Sans Semibold"],"text-anchor":"top","icon-image":"{class}_11","text-field":"{name}","text-offset":[0,0.6],"text-size":12,"text-max-width":9},"paint":{"text-halo-blur":0.5,"text-color":"#666","text-halo-width":1,"text-halo-color":"#ffffff"}},{"id":"poi-level-2","type":"symbol","source":"openmaptiles","source-layer":"poi","minzoom":15,"filter":["all",["==","\$type","Point"],["all",["<=","rank",24],[">=","rank",15]]],"layout":{"text-padding":2,"text-font":["Open Sans Semibold"],"text-anchor":"top","icon-image":"{class}_11","text-field":"{name}","text-offset":[0,0.6],"text-size":12,"text-max-width":9},"paint":{"text-halo-blur":0.5,"text-color":"#666","text-halo-width":1,"text-halo-color":"#ffffff"}},{"id":"poi-level-1","type":"symbol","source":"openmaptiles","source-layer":"poi","minzoom":14,"filter":["all",["==","\$type","Point"],["all",["<=","rank",14],["has","name"]]],"layout":{"text-padding":2,"text-font":["Open Sans Semibold"],"text-anchor":"top","icon-image":"{class}_11","text-field":"{name}","text-offset":[0,0.6],"text-size":12,"text-max-width":9},"paint":{"text-halo-blur":0.5,"text-color":"#666","text-halo-width":1,"text-halo-color":"#ffffff"}},{"id":"highway-name-path","type":"symbol","source":"openmaptiles","source-layer":"transportation_name","minzoom":15.5,"filter":["==","class","path"],"layout":{"text-size":{"base":1,"stops":[[13,12],[14,13]]},"text-font":["Open Sans Regular"],"text-field":"{name}","symbol-placement":"line","text-rotation-alignment":"map"},"paint":{"text-halo-color":"#f8f4f0","text-color":"hsl(30, 23%, 62%)","text-halo-width":0.5}},{"id":"highway-name-minor","type":"symbol","source":"openmaptiles","source-layer":"transportation_name","minzoom":15,"filter":["all",["==","\$type","LineString"],["in","class","minor","service","track"]],"layout":{"text-size":{"base":1,"stops":[[13,12],[14,13]]},"text-font":["Open Sans Regular"],"text-field":"{name}","symbol-placement":"line","text-rotation-alignment":"map"},"paint":{"text-halo-blur":0.5,"text-color":"#765","text-halo-width":1}},{"id":"highway-name-major","type":"symbol","source":"openmaptiles","source-layer":"transportation_name","minzoom":12.2,"filter":["in","class","primary","secondary","tertiary","trunk"],"layout":{"text-size":{"base":1,"stops":[[13,12],[14,13]]},"text-font":["Open Sans Regular"],"text-field":"{name}","symbol-placement":"line","text-rotation-alignment":"map"},"paint":{"text-halo-blur":0.5,"text-color":"#765","text-halo-width":1}},{"id":"highway-shield","type":"symbol","source":"openmaptiles","source-layer":"transportation_name","minzoom":8,"filter":["all",["<=","ref_length",6],["==","\$type","LineString"]],"layout":{"text-size":11,"icon-image":"motorway_{ref_length}","icon-rotation-alignment":"viewport","symbol-spacing":500,"text-font":["Open Sans Semibold"],"symbol-placement":{"base":1,"stops":[[10,"point"],[11,"line"]]},"text-rotation-alignment":"viewport","icon-size":0.85,"text-field":"{ref}"},"paint":{}},{"id":"place-other","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","filter":["all",["!in","class","city","town","village"]],"layout":{"text-letter-spacing":0.1,"text-size":{"base":1.2,"stops":[[12,10],[15,14]]},"text-font":["Open Sans Bold"],"text-field":"{name_en}","text-transform":"uppercase","text-max-width":9},"paint":{"text-color":"#633","text-halo-width":1.2,"text-halo-color":"rgba(255,255,255,0.8)"}},{"id":"place-village","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","filter":["==","class","village"],"layout":{"text-font":["Open Sans Regular"],"text-size":{"base":1.2,"stops":[[10,12],[15,22]]},"text-field":"{name_en}","text-max-width":8},"paint":{"text-color":"#333","text-halo-width":1.2,"text-halo-color":"rgba(255,255,255,0.8)"}},{"id":"place-town","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","filter":["==","class","town"],"layout":{"text-font":["Open Sans Regular"],"text-size":{"base":1.2,"stops":[[10,14],[15,24]]},"text-field":"{name_en}","text-max-width":8},"paint":{"text-color":"#333","text-halo-width":1.2,"text-halo-color":"rgba(255,255,255,0.8)"}},{"id":"place-city","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","filter":["all",["!=","capital",2],["==","class","city"]],"layout":{"text-font":["Open Sans Semibold"],"text-size":{"base":1.2,"stops":[[7,14],[11,24]]},"text-field":"{name_en}","text-max-width":8},"paint":{"text-color":"#333","text-halo-width":1.2,"text-halo-color":"rgba(255,255,255,0.8)"}},{"id":"place-city-capital","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","filter":["all",["==","capital",2],["==","class","city"]],"layout":{"text-font":["Open Sans Semibold"],"text-size":{"base":1.2,"stops":[[7,14],[11,24]]},"text-field":"{name_en}","text-max-width":8,"icon-image":"star_11","text-offset":[0.4,0],"icon-size":0.8,"text-anchor":"left"},"paint":{"text-color":"#333","text-halo-width":1.2,"text-halo-color":"rgba(255,255,255,0.8)"}},{"id":"place-country-3","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","filter":["all",["==","class","country"],[">=","rank",3]],"layout":{"text-font":["Open Sans Bold"],"text-field":"{name_en}","text-size":{"stops":[[3,11],[7,17]]},"text-transform":"uppercase","text-max-width":6.25},"paint":{"text-halo-blur":1,"text-color":"#334","text-halo-width":2,"text-halo-color":"rgba(255,255,255,0.8)"}},{"id":"place-country-2","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","filter":["all",["==","class","country"],["==","rank",2]],"layout":{"text-font":["Open Sans Bold"],"text-field":"{name_en}","text-size":{"stops":[[2,11],[5,17]]},"text-transform":"uppercase","text-max-width":6.25},"paint":{"text-halo-blur":1,"text-color":"#334","text-halo-width":2,"text-halo-color":"rgba(255,255,255,0.8)"}},{"id":"place-country-1","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","filter":["all",["==","class","country"],["==","rank",1]],"layout":{"text-font":["Open Sans Bold"],"text-field":"{name_en}","text-size":{"stops":[[1,11],[4,17]]},"text-transform":"uppercase","text-max-width":6.25},"paint":{"text-halo-blur":1,"text-color":"#334","text-halo-width":2,"text-halo-color":"rgba(255,255,255,0.8)"}},{"id":"place-continent","type":"symbol","metadata":{"mapbox:group":"1444849242106.713"},"source":"openmaptiles","source-layer":"place","maxzoom":1,"filter":["==","class","continent"],"layout":{"text-font":["Open Sans Bold"],"text-field":"{name_en}","text-size":14,"text-max-width":6.25,"text-transform":"uppercase"},"paint":{"text-halo-blur":1,"text-color":"#334","text-halo-width":2,"text-halo-color":"rgba(255,255,255,0.8)"}}]}),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
                    _detailHead(),
                    const SizedBox(height: 24,),
                    _informationSection(),
                    const SizedBox(height: 24,),
                    _visitPlaceSection(),
                    const SizedBox(height: 24,),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => CourseMapPage());
                      },
                      child: Text('test'),
                    )
                  ]),
                )
              ],
            );
          },
        )
    );
  }
}
