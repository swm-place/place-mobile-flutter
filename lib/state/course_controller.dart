import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/course_provider.dart';
import 'package:place_mobile_flutter/state/state_const.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:latlong2/latlong.dart';

class CourseController extends GetxController {
  static CourseController get to => Get.find();

  dynamic courseId;

  final CourseProvider _courseProvider = CourseProvider();

  RxList<dynamic> coursePlaceData = RxList([]);
  RxList<Map<String, double>> placesPosition = RxList([]);
  Rxn<Map<String, dynamic>> courseLineData = Rxn(null);

  RxList<double> center = RxList([37.574863, 126.977725]);
  RxString regionName = RxString('-');
  RxString title = RxString('');

  Future<bool> getCourseData() async {
    Map<String, dynamic>? result = await _courseProvider.getMyCourseDataById(courseId);
    if (result == null) {
      return false;
    }

    log(result.toString());

    title.value = result['title'];
    coursePlaceData.value = result['placesInCourse'];
    if (result['routesJson'] != null) {
      courseLineData.value = json.decode(result['routesJson']);
    } else {
      courseLineData.value = null;
    }

    return true;
  }

  Future<Map<String, dynamic>> getCoursePlacesData() async {
    coursePlaceData.clear();
    await Future.delayed(const Duration(milliseconds: 500));
    coursePlaceData.addAll(
        [
          {
            "imageUrl": "https://source.unsplash.com/random?seq=2",
            "placeName": "날쏘고가라",
            "placeType": "레포츠",
            "location": {
              'lat': 37.553979,
              'lon': 126.922668
            },
            "open": "영업중",
            "tags": [
              {"text": "조용한", "color": RandomGenerator.generateRandomDarkHexColor()},
              {"text": "넓은", "color": RandomGenerator.generateRandomDarkHexColor()},
            ]
          },
          {
            "imageUrl": "https://source.unsplash.com/random?seq=3",
            "placeName": "니컷네컷 홍대점",
            "placeType": "사진",
            "location": {
              'lat': 37.554218,
              'lon': 126.922398
            },
            "open": "영업중",
            "tags": [
              {"text": "조용한", "color": RandomGenerator.generateRandomDarkHexColor()},
              {"text": "넓은", "color": RandomGenerator.generateRandomDarkHexColor()},
            ]
          },
          {
            "imageUrl": "https://source.unsplash.com/random?seq=4",
            "placeName": "무신사 테라스 홍대",
            "placeType": "옷가게",
            "location": {
              'lat': 37.557574,
              'lon': 126.926882
            },
            "open": "영업중",
            "tags": [
              {"text": "조용한", "color": RandomGenerator.generateRandomDarkHexColor()},
              {"text": "넓은", "color": RandomGenerator.generateRandomDarkHexColor()},
            ]
          },
          {
            "imageUrl": "https://source.unsplash.com/random?seq=5",
            "placeName": "산울림1992",
            "placeType": "주점",
            "location": {
              'lat': 37.554666,
              'lon': 126.930591
            },
            "open": "영업중",
            "tags": [
              {"text": "조용한", "color": RandomGenerator.generateRandomDarkHexColor()},
              {"text": "넓은", "color": RandomGenerator.generateRandomDarkHexColor()},
            ]
          },
        ]
    );
    coursePlaceData.refresh();

    placesPosition.clear();
    placesPosition.addAll(
        coursePlaceData.expand((element) =>
          [element['location']]).toList().cast<Map<String, double>>()
    );
    placesPosition.refresh();

    return {'code': ASYNC_SUCCESS};
  }

  Future<int> getCourseLineData() async {
    Map<String, dynamic>? result = await _courseProvider.getCourseLine(placesPosition);
    if (result == null) {
      courseLineData.value = null;
      courseLineData.refresh();
      return ASYNC_ERROR;
    }

    courseLineData.value = result;
    courseLineData.refresh();

    center.value = UnitConverter.findCenter(courseLineData.value!['routes'][0]['geometry']['coordinates']);
    center.refresh();
    return ASYNC_SUCCESS;
  }

  Future<int> getGeocodeData() async {
    Map<String, dynamic>? result = await _courseProvider.getReverseGeocode(LatLng(center[0], center[1]));
    if (result == null) {
      regionName.value = '-';
      regionName.refresh();
      return ASYNC_ERROR;
    }

    regionName.value = result['region_name'];
    regionName.refresh();
    return ASYNC_SUCCESS;
  }

  void changePlaceOrder(int oldIndex, int newIndex) {
    final Map<String, dynamic> item = coursePlaceData.removeAt(oldIndex);
    coursePlaceData.insert(newIndex, item);
    coursePlaceData.refresh();
    placesPosition.clear();
    placesPosition.addAll(
        coursePlaceData.expand((element) =>
        [element['location']]).toList().cast<Map<String, double>>()
    );
    placesPosition.refresh();
  }

  void deletePlace(int index) {
    coursePlaceData.removeAt(index);
    coursePlaceData.refresh();
    placesPosition.clear();
    placesPosition.addAll(
        coursePlaceData.expand((element) =>
        [element['location']]).toList().cast<Map<String, double>>()
    );
    placesPosition.refresh();
  }

  void addPlace(List<dynamic> places) async {
    for (int i = 0;i < places.length;i++) {
      coursePlaceData.add({
        'id': places[i]['id'],
        'name': places[i]['name'],
        'category': places[i]['category'],
        'img_url': places[i]['img_url'],
        'img_url': places[i]['img_url'],
        'img_url': places[i]['img_url'],
      });
    }
  }
}