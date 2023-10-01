import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/state/course_controller.dart';
import 'package:place_mobile_flutter/state/place_controller.dart';
import 'package:place_mobile_flutter/util/cache/map/map_cache_manager.dart';
import 'package:place_mobile_flutter/util/map/map_tile_cache.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:latlong2/latlong.dart';

class CourseMapPage extends StatefulWidget {
  CourseMapPage({
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CourseMapPageState();
}

class _CourseMapPageState extends State<CourseMapPage> {
  late final MapController _mapController;
  late final CarouselController _carouselController;

  late final CacheManager cacheManager;

  @override
  void initState() {
    cacheManager = MapCacheManager.instance;
    _mapController = MapController();
    _carouselController = CarouselController();
    super.initState();
  }

  @override
  void dispose() {
    cacheManager.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                center: const LatLng(37.5036, 127.0448),
                zoom: 12,
                maxZoom: 17,
                minZoom: 10,
                interactiveFlags: InteractiveFlag.drag |
                InteractiveFlag.flingAnimation |
                InteractiveFlag.pinchMove |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.doubleTapZoom),
            children: [
              TileLayer(
                urlTemplate: '$mapBaseUrl/styles/bright/{z}/{x}/{y}.jpg',
                userAgentPackageName: 'com.example.app',
                tileProvider: CacheTileProvider(cacheManager),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SafeArea(
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  initialPage: 0,
                  autoPlay: false,
                  enableInfiniteScroll: false,
                  height: 90,
                  viewportFraction: 0.85,
                  onPageChanged: (index, reason) {
                    print(index);
                  }
                ),
                carouselController: _carouselController,
                itemCount: CourseController.to.coursePlaceData.length,
                itemBuilder: (context, index, realIndex) {
                  int? distance;
                  if (PlaceController.to.userPosition.value != null) {
                    double lat2 = CourseController.to.coursePlaceData[index]['location']['lat'];
                    double lon2 = CourseController.to.coursePlaceData[index]['location']['lon'];
                    distance = PlaceController.to.haversineDistance(lat2, lon2);
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: RoundedRowRectanglePlaceCard(
                      imageUrl: CourseController.to.coursePlaceData[index]['imageUrl'],
                      tags: CourseController.to.coursePlaceData[index]['tags'],
                      placeName: CourseController.to.coursePlaceData[index]['placeName'],
                      placeType: CourseController.to.coursePlaceData[index]['placeType'],
                      open: CourseController.to.coursePlaceData[index]['open'],
                      distance: distance == null ? null : UnitConverter.formatDistance(distance),
                    ),
                  );
                },
              ),
            )
          )
        ],
      ),
    );
  }
}
