import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PlaceController extends GetxController {
  static PlaceController get to => Get.find();

  Rxn<Position> position = Rxn(null);

  bool gpuPermissionAllow = false;

  @override
  void onReady() async {
    super.onReady();
  }

  Future<Position?> getPosition() async {
    Position? position;

    if (gpuPermissionAllow) {
      try {
        position = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 5));
        this.position(position);
      } catch(e) {
        position = await Geolocator.getLastKnownPosition();
        this.position(position);
      }
    } else {
      position = await Geolocator.getLastKnownPosition();
      this.position(position);
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
      gpuPermissionAllow = false;
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // return Future.error('Location permissions are denied');
        gpuPermissionAllow = false;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      gpuPermissionAllow = false;
      return false;
    }

    gpuPermissionAllow = true;
    return true;
  }
}