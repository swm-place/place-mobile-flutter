import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/state/course_controller.dart';
import 'package:place_mobile_flutter/state/place_controller.dart';
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
  @override
  State<StatefulWidget> createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {

  late final CacheManager cacheManager;

  @override
  void initState() {
    cacheManager = MapCacheManager.instance;
    super.initState();
  }

  @override
  void dispose() {
    cacheManager.dispose();
    super.dispose();
  }

  List<Widget> _createList() {
    List<Widget> course = [];
    int index = 0;
    for (var place in CourseController.to.coursePlaceData) {
      int? distance;
      if (PlaceController.to.userPosition.value != null) {
        double lat2 = place['location']['lat'];
        double lon2 = place['location']['lon'];
        distance = PlaceController.to.haversineDistance(lat2, lon2);
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
                    CourseController.to.deletePlace(targetIndex);
                    CourseController.to.getCourseLineData()
                        .then((value) {
                      if (value == ASYNC_SUCCESS) {
                        CourseController.to.getGeocodeData();
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
              imageUrl: place['imageUrl'],
              tags: place['tags'],
              placeName: place['placeName'],
              placeType: place['placeType'],
              open: place['open'],
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
    return Scaffold(
      appBar: AppBar(
        title: Text('편집'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
          if (bottomPadding == 0) bottomPadding = 24;
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPadding),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('장소 추가', style: SectionTextStyle.sectionTitle(),)
                            ),
                            Ink(
                              decoration: BoxDecoration(
                                // color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                customBorder: CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                  child: Icon(Icons.close, size: 18,),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          height: 1800,
                          child: Container(color: Colors.red, width: double.infinity, height: double.infinity,),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('추가')
                      ),
                    )
                  ],
                ),
              );
            },
            isScrollControlled: true,
            useSafeArea: true,
            enableDrag: false,
            isDismissible: false
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
              final double width = MediaQuery.of(context).size.width;
              final double height = width / 16 * 9;

              final double initZoom = UnitConverter.calculateZoomLevel(
                  CourseController.to.courseLineData.value!['routes'][0]['geometry']['coordinates'],
                  MediaQuery.of(context).size.width,
                  height < 200 ? 200 : height);

              final Widget map = FlutterMap(
                options: MapOptions(
                    center: LatLng(
                        CourseController.to.center[0],
                        CourseController.to.center[1]
                    ),
                    zoom: initZoom,
                    maxZoom: 18,
                    interactiveFlags: InteractiveFlag.none
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
                child: ReorderableListView(
                  children: _createList(),
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    CourseController.to.changePlaceOrder(oldIndex, newIndex);
                    CourseController.to.getCourseLineData()
                        .then((value) {
                      if (value == ASYNC_SUCCESS) {
                        CourseController.to.getGeocodeData();
                      }
                    });
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
