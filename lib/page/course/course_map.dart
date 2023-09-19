import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
  Style? _style;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _initStyle();
  }

  void _initStyle() async {
    try {
      _style = await _readStyle();
    } catch (e, stack) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print(stack);
      _error = e;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (_error != null) {
      children.add(Expanded(child: Text(_error!.toString())));
    } else if (_style == null) {
      children.add(const Center(child: CircularProgressIndicator()));
    } else {
      children.add(Flexible(child: _map(_style!)));
      children.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_statusText()]));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('test'),
        ),
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children)));
  }

  Future<Style> _readStyle() => StyleReader(
      uri: 'http://192.168.0.2:8080/styles/bright/style.json',
      // ignore: undefined_identifier
      // apiKey: mapboxApiKey,
  ).read();

  Widget _map(Style style) => FlutterMap(
    mapController: _controller,
    options: MapOptions(
        center: style.center ?? const LatLng(37.5036, 127.0448),
        zoom: 12,
        maxZoom: 22,
        interactiveFlags: InteractiveFlag.drag |
        InteractiveFlag.flingAnimation |
        InteractiveFlag.pinchMove |
        InteractiveFlag.pinchZoom |
        InteractiveFlag.doubleTapZoom),
    children: [
      // VectorTileLayer(
      //     tileProviders: style.providers,
      //     theme: style.theme,
      //     sprites: style.sprites,
      //     maximumZoom: 22,
      //     tileOffset: TileOffset.DEFAULT,
      //     layerMode: VectorTileLayerMode.vector)
      TileLayer(
        urlTemplate: 'http://192.168.0.2:8080/styles/bright/{z}/{x}/{y}.png',
        // urlTemplate: 'http://localhost:50001/tile/v1/foot/tile({x},{y},{z}).mvt',
        userAgentPackageName: 'com.example.app',
      ),
    ],
  );

  Widget _statusText() => Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: StreamBuilder(
          stream: _controller.mapEventStream,
          builder: (context, snapshot) {
            return Text(
                'Zoom: ${_controller.zoom.toStringAsFixed(2)} Center: ${_controller.center.latitude.toStringAsFixed(4)},${_controller.center.longitude.toStringAsFixed(4)}');
          }));
}
