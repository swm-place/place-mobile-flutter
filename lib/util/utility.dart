import 'dart:ui';

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