import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/state/course_controller.dart';
import 'package:place_mobile_flutter/state/gis_controller.dart';
import 'package:place_mobile_flutter/util/cache/map/map_cache_manager.dart';
import 'package:place_mobile_flutter/util/map/map_layer.dart';
import 'package:place_mobile_flutter/util/map/map_tile_cache.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:latlong2/latlong.dart';

class CourseMapPage extends StatefulWidget {
  CourseMapPage({
    required this.courseController,
    Key? key
  }) : super(key: key);
  
  CourseController courseController;

  @override
  State<StatefulWidget> createState() => _CourseMapPageState();
}

class _CourseMapPageState extends State<CourseMapPage> with TickerProviderStateMixin {
  late final AnimatedMapController _mapController;
  late final CarouselController _carouselController;

  late final CacheManager cacheManager;

  @override
  void initState() {
    cacheManager = MapCacheManager.instance;
    _mapController = AnimatedMapController(vsync: this);
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
    double bottomSafePad = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text("상세보기"),
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              final double height = width / 16 * 9;

              final double initZoom;
              if (widget.courseController.courseLineData.value != null) {
                if (widget.courseController.placesPosition.length > 1) {
                  initZoom = UnitConverter.calculateZoomLevel(
                      widget.courseController.courseLineData.value!['routes'][0]['geometry']['coordinates'],
                      MediaQuery.of(context).size.width,
                      height < 200 ? 200 : (height < 400 ? height : 400));
                } else {
                  initZoom = 16.5;
                }
              } else {
                initZoom = 15;
              }

              return FlutterMap(
                mapController: _mapController.mapController,
                options: MapOptions(
                    center: LatLng(
                        widget.courseController.center[0],
                        widget.courseController.center[1]
                    ),
                    zoom: 18,
                    maxZoom: 18,
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
            },
          ),
          Positioned(
            bottom: bottomSafePad == 0 ? 24 : 0,
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
                  clipBehavior: Clip.none,
                  onPageChanged: (index, reason) {
                    double lat = widget.courseController.coursePlaceData[index]['place']['location']['lat'];
                    double lon = widget.courseController.coursePlaceData[index]['place']['location']['lon'];
                    _mapController.animateTo(
                      dest: LatLng(lat, lon),
                      zoom: _mapController.mapController.zoom
                    );
                  }
                ),
                carouselController: _carouselController,
                itemCount: widget.courseController.coursePlaceData.length,
                itemBuilder: (context, index, realIndex) {
                  int? distance;
                  if (GISController.to.userPosition.value != null) {
                    double lat2 = widget.courseController.coursePlaceData[index]['place']['location']['lat'];
                    double lon2 = widget.courseController.coursePlaceData[index]['place']['location']['lon'];
                    distance = GISController.to.haversineDistance(lat2, lon2);
                  }
                  return Container(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: RoundedRowRectanglePlaceCard(
                      imageUrl: widget.courseController.coursePlaceData[index]['place']['img_url'] != null ?
                      "$baseUrlDev/api-recommender/place-photo/?${ widget.courseController.coursePlaceData[index]['place']['img_url'].split('?')[1]}&max_width=480" :
                      null,
                      // tags: place['place']['tags'],
                      tags: [],
                      placeName: widget.courseController.coursePlaceData[index]['place']['name'],
                      placeType: widget.courseController.coursePlaceData[index]['place']['category'],
                      // open: place['place']['open'],
                      open: '영압중',
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
