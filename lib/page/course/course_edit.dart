import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/page/course/course_add.dart';
import 'package:place_mobile_flutter/state/course_controller.dart';
import 'package:place_mobile_flutter/state/gis_controller.dart';
import 'package:place_mobile_flutter/state/state_const.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/cache/map/map_cache_manager.dart';
import 'package:place_mobile_flutter/util/map/map_layer.dart';
import 'package:place_mobile_flutter/util/map/map_tile_cache.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';

class CourseEditPage extends StatefulWidget {
  CourseEditPage({
    required this.courseController,
    required this.cacheManager,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CourseEditPageState();

  CourseController courseController;
  CacheManager cacheManager;
}

class _CourseEditPageState extends State<CourseEditPage> {
  // late final CacheManager cacheManager;

  late final MapController _mapController;
  late final double mapWidth;

  @override
  void initState() {
    // cacheManager = MapCacheManager.instance;
    _mapController = MapController();
    widget.courseController.courseLineData.listen((p0) {
      final double height = mapWidth / 16 * 9;

      final double initZoom;
      if (widget.courseController.courseLineData.value != null) {
        if (widget.courseController.placesPosition.length > 1) {
          initZoom = UnitConverter.calculateZoomLevel(
              widget.courseController.courseLineData.value!['routes'][0]['geometry']['coordinates'],
              mapWidth,
              height < 200 ? 200 : (height < 400 ? height : 400));
        } else {
          initZoom = 16.5;
        }
      } else {
        initZoom = 15;
      }

      _mapController.move(LatLng(
          widget.courseController.center[0],
          widget.courseController.center[1]
      ), initZoom);
    });
    super.initState();
  }

  @override
  void dispose() {
    // cacheManager.dispose();
    _mapController.dispose();
    super.dispose();
  }

  List<Widget> _createList() {
    List<Widget> course = [];
    int index = 0;
    for (var place in widget.courseController.coursePlaceData) {
      int? distance;
      if (GISController.to.userPosition.value != null) {
        double lat2 = place['place']['location']['lat'];
        double lon2 = place['place']['location']['lon'];
        distance = GISController.to.haversineDistance(lat2, lon2);
      }
      int targetIndex = index;
      course.add(
          Slidable(
            key: Key('$index'),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    widget.courseController.deletePlace(targetIndex);
                    widget.courseController.getCourseLineData()
                        .then((value) {
                      if (value == ASYNC_SUCCESS) {
                        widget.courseController.getGeocodeData();
                      }
                    });
                  },
                  label: '삭제',
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                )
              ],
            ),
            child: RoundedRowRectanglePlaceCard(
              imageUrl: place['place']['img_url'] != null ?
                "$baseUrlDev/api-recommender/place-photo/?${ place['place']['img_url'].split('?')[1]}&max_width=480" :
                null,
              // tags: place['place']['tags'],
              tags: [],
              placeName: place['place']['name'],
              placeType: place['place']['category'],
              // open: place['place']['open'],
              open: '영압중',
              distance: distance == null ? null : UnitConverter.formatDistance(distance),
              elevation: 0,
              borderRadius: 0,
              imageBorderRadius: 8,
              imagePadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            ),
          )
      );
      index++;
    }
    return course;
  }

  @override
  Widget build(BuildContext context) {
    mapWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('편집'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => CourseAddPage(
              cacheManager: widget.cacheManager,
              courseController: widget.courseController,
            ),
            transition: Transition.downToUp,
            fullscreenDialog: true,
            popGesture: false
          );
        },
        backgroundColor: lightColorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final double height = mapWidth / 16 * 9;

              final double initZoom;
              if (widget.courseController.courseLineData.value != null) {
                if (widget.courseController.placesPosition.length > 1) {
                  initZoom = UnitConverter.calculateZoomLevel(
                      widget.courseController.courseLineData.value!['routes'][0]['geometry']['coordinates'],
                      mapWidth,
                      height < 200 ? 200 : (height < 400 ? height : 400));
                } else {
                  initZoom = 16.5;
                }
              } else {
                initZoom = 15;
              }

              final Widget map = FlutterMap(
                options: MapOptions(
                    center: LatLng(
                        widget.courseController.center[0],
                        widget.courseController.center[1]
                    ),
                    zoom: initZoom,
                    maxZoom: 18,
                    interactiveFlags: InteractiveFlag.none
                ),
                mapController: _mapController,
                children: [
                  TileLayer(
                    urlTemplate: '$mapBaseUrl/styles/bright/{z}/{x}/{y}.jpg',
                    userAgentPackageName: 'com.example.app',
                    tileProvider: CacheTileProvider(widget.cacheManager),
                  ),
                  if (widget.courseController.courseLineData.value != null &&
                      widget.courseController.placesPosition.length > 1) PolylineLayer(
                    polylines: MapLayerGenerator.generatePolyLines(
                        widget.courseController.courseLineData.value!['routes'][0]['geometry']['coordinates']),
                  ),
                  if (widget.courseController.placesPosition.isNotEmpty) MarkerLayer(
                    markers: MapLayerGenerator.generateMarkers(
                        widget.courseController.placesPosition.value),
                  )
                ],
              );

              if (height < 200) {
                return SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: map,
                );
              }

              if (height < 400) {
                return AspectRatio(
                  aspectRatio: 16/9,
                  child: map,
                );
              }

              return SizedBox(
                width: double.infinity,
                height: 400,
                child: map,
              );
            }),
            Flexible(
              child: Obx(() => Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: widget.courseController.coursePlaceData.isEmpty ?
                  Container(
                    height: double.infinity,
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
                  ReorderableListView(
                    children: _createList(),
                    onReorder: (int oldIndex, int newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      Get.dialog(
                          const AlertDialog(
                            contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                            actionsPadding: EdgeInsets.zero,
                            titlePadding: EdgeInsets.zero,
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 24),
                                Text('코스 순서 변경 반영중'),
                              ],
                            ),
                          ),
                          barrierDismissible: false
                      );
                      bool result = await widget.courseController.changePlaceOrder(oldIndex, newIndex);
                      Get.back();
                      if (result) {

                      } else {
                        Get.dialog(
                          AlertDialog(
                            contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                            titlePadding: EdgeInsets.zero,
                            content: const Text("코스 순서 변경 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
                            actions: [
                              TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
                            ],
                          ),
                        );
                      }
                    },
                  ),
              )),
            )
          ],
        )
      ),
    );
  }
}
