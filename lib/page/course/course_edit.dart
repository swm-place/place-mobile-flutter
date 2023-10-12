import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/state/course_controller.dart';
import 'package:place_mobile_flutter/util/cache/map/map_cache_manager.dart';
import 'package:place_mobile_flutter/util/map/map_layer.dart';
import 'package:place_mobile_flutter/util/map/map_tile_cache.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            LayoutBuilder(
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
                      interactiveFlags: InteractiveFlag.drag |
                      InteractiveFlag.flingAnimation |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom
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
              },
            )
          ],
        ),
      ),
    );
  }
}
