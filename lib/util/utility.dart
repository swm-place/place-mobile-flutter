import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
