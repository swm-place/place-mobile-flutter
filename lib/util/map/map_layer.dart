import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapLayerGenerator {
  static List<Polyline> generatePolyLines(List<dynamic> course) {
    List<Polyline> lines = [];
    List<LatLng> points = [];

    for (var l in course) {
      points.add(LatLng(l[1], l[0]));
    }
    lines.add(
        Polyline(
            points: points,
            strokeWidth: 3.0,
            color: Colors.black87.withOpacity(0.5)
        )
    );
    return lines;
  }

  static List<Marker> generateMarkers(List<dynamic> points) {
    List<Marker> markers = [];
    for (int i = 0;i < points.length;i++) {
      markers.add(
          Marker(
              point: LatLng(points[i]['lat'], points[i]['lon']),
              width: 18,
              height: 18,
              builder: (context) => Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87
                ),
                child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    )
                ),
              )
          )
      );
    }
    return markers;
  }
}