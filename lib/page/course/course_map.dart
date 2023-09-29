import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/util/cache/map/map_cache_manager.dart';
import 'package:place_mobile_flutter/util/map/map_tile_cache.dart';
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
  final MapController _controller = MapController();
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
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: FlutterMap(
                mapController: _controller,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: StreamBuilder(
                    stream: _controller.mapEventStream,
                    builder: (context, snapshot) {
                      return Text('Zoom: ${_controller.zoom.toStringAsFixed(2)} Center: ${_controller.center.latitude.toStringAsFixed(4)},${_controller.center.longitude.toStringAsFixed(4)}');
                    }
                  )
                )
              ]
            )
          ]
        )
      )
    );
  }
}
