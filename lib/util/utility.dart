import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/api/api_const.dart';

class UnitConverter {
  static String formatDistance(int distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters}m';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      if ((distanceInKm * 10) % 10 == 0) {
        return '${distanceInKm.toInt()}km';
      }
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }

  static String formatNumber(int number) {
    if (number < 1000) {
      return '$number';
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    }
  }

  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<double> findCenter(List<dynamic> points) {
    double x = 0.0;
    double y = 0.0;
    double z = 0.0;

    for (var point in points) {
      double latitude = point[1]! * pi / 180;
      double longitude = point[0]! * pi / 180;

      x += cos(latitude) * cos(longitude);
      y += cos(latitude) * sin(longitude);
      z += sin(latitude);
    }

    x = x / points.length;
    y = y / points.length;
    z = z / points.length;

    double centralLongitude = atan2(y, x);
    double centralSquareRoot = sqrt(x * x + y * y);
    double centralLatitude = atan2(z, centralSquareRoot);

    print('${centralLatitude * 180 / pi} ${centralLongitude * 180 / pi}');

    return [centralLatitude * 180 / pi, centralLongitude * 180 / pi];
  }

  static double degreeToRadian(double degree) {
    return degree * (pi / 180);
  }

  static double radianToDegree(double radian) {
    return radian * (180 / pi);
  }

  static double calculateZoomLevel(List<dynamic> points, double mapWidth, double mapHeight) {
    const double ZOOM_MAX = 18;
    const double TILE_SIZE = 256.0;

    double minLat = 90.0;
    double maxLat = -90.0;
    double minLon = 180.0;
    double maxLon = -180.0;

    for (var point in points) {
      double lat = point[1];
      double lon = point[0];
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lon < minLon) minLon = lon;
      if (lon > maxLon) maxLon = lon;
    }

    double latFraction = (sin(maxLat * pi / 180) - sin(minLat * pi / 180)) / pi;
    double lngDiff = maxLon - minLon;
    double lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

    double latZoom = log(mapHeight * 0.8 / TILE_SIZE / latFraction) / ln2;
    double lngZoom = log(mapWidth * 0.8 / TILE_SIZE / lngFraction) / ln2;

    double zoom = min(latZoom, lngZoom);
    zoom = min(zoom, ZOOM_MAX);

    print(zoom);

    return zoom;
  }
}

class RandomGenerator {
  static String generateRandomDarkHexColor() {
    final Random random = Random();
    final int r = random.nextInt(128); // 0-127
    final int g = random.nextInt(128); // 0-127
    final int b = random.nextInt(128); // 0-127
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }

  static Color getRandomPastelColor() {
    Random random = Random();
    double hue = random.nextDouble() * 360;
    double saturation = random.nextDouble() * 0.3 + 0.2;
    double brightness = random.nextDouble() * 0.2 + 0.8;
    return HSVColor.fromAHSV(1.0, hue, saturation, brightness).toColor();
  }

  static Color getRandomLightMaterialColor() {
    Random random = Random();
    List<Color> lightColors = [
      Colors.red[400]!,
      Colors.pink[400]!,
      Colors.purple[400]!,
      Colors.deepPurple[400]!,
      Colors.indigo[400]!,
      Colors.blue[400]!,
      Colors.lightBlue[400]!,
      Colors.cyan[400]!,
      Colors.teal[400]!,
      Colors.green[400]!,
      Colors.lightGreen[400]!,
      Colors.lime[400]!,
      Colors.yellow[400]!,
      Colors.amber[400]!,
      Colors.orange[400]!,
      Colors.deepOrange[400]!,
      Colors.brown[400]!,
      Colors.grey[400]!,
      Colors.blueGrey[400]!,
    ];

    return lightColors[random.nextInt(lightColors.length)];
  }
}

class HtmlParser {
  static String removeHtmlTags(String htmlText) {
    final RegExp regExp = RegExp(r'<[^>]*>', multiLine: true);
    return htmlText.replaceAll(regExp, '');
  }
}

class ImageParser {
  static String? parseImageUrl(String? url) {
    if (url == null) return null;

    var urlSplit = url.split('?');
    if (urlSplit.length > 1) {
      return "$baseUrlDev/api-recommender/place-photo/?${urlSplit[1]}&max_width=480";
    } else {
      return "$baseUrlDev$url";
    }
  }
}
