import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PlaceController extends GetxController {
  static PlaceController get to => Get.find();

  Rxn<Position> userPosition = Rxn(null);

  bool gpsPermissionAllow = false;

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double haversineDistance(double lat2, double lon2) {
    const R = 6371000.0;

    double lat1 = userPosition.value!.latitude;
    double lon1 = userPosition.value!.longitude;

    var dLat = _degreesToRadians(lat2 - lat1);
    var dLon = _degreesToRadians(lon2 - lon1);

    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  Future<Position?> getPosition() async {
    Position? position;

    if (gpsPermissionAllow) {
      try {
        position = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 5));
        userPosition(position);
      } catch(e) {
        position = await Geolocator.getLastKnownPosition();
        userPosition(position);
      }
    } else {
      position = await Geolocator.getLastKnownPosition();
      userPosition(position);
    }
    print('now position - lat: ${position!.latitude} long: ${position!.longitude}');
    return position;
  }

  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // return Future.error('Location services are disabled.');
      gpsPermissionAllow = false;
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // return Future.error('Location permissions are denied');
        gpsPermissionAllow = false;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      gpsPermissionAllow = false;
      return false;
    }

    gpsPermissionAllow = true;
    return true;
  }
}