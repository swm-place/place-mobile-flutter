import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/state/course_controller.dart';
import 'package:place_mobile_flutter/state/place_controller.dart';
import 'package:place_mobile_flutter/state/state_const.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편집'),
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
                  children: () {
                    List<Widget> course = [];
                    int index = 0;
                    for (var place in CourseController.to.coursePlaceData) {
                      int? distance;
                      if (PlaceController.to.userPosition.value != null) {
                        double lat2 = place['location']['lat'];
                        double lon2 = place['location']['lon'];
                        distance = PlaceController.to.haversineDistance(lat2, lon2);
                      }
                      EdgeInsets padding;
                      if (index == 0) {
                        padding = const EdgeInsets.fromLTRB(0, 0, 0, 6);
                      } else if(index == CourseController.to.coursePlaceData.length - 1) {
                        padding = const EdgeInsets.fromLTRB(0, 6, 0, 0);
                      } else {
                        padding = const EdgeInsets.fromLTRB(0, 6, 0, 6);
                      }
                      course.addAll([
                      Container(
                        key: Key('$index'),
                        // padding: padding,
                        color: Colors.transparent,
                        child: RoundedRowRectanglePlaceCard(
                          key: Key('$index'),
                          imageUrl: place['imageUrl'],
                          tags: place['tags'],
                          placeName: place['placeName'],
                          placeType: place['placeType'],
                          open: place['open'],
                          distance: distance == null ? null : UnitConverter.formatDistance(distance),
                        ),
                      ),
                      ]);
                      index++;
                    }
                    return course;
                  } (),
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
