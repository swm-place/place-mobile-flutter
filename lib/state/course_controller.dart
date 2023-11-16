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
  RxList<dynamic> placesPosition = RxList([]);
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

    placesPosition.clear();
    placesPosition.addAll(
        coursePlaceData.expand((element) =>
        [element['place']['location']]).toList()
    );

    if (result['routesJson'] != null && result['routesJson'] != '') {
      dynamic data = json.decode(result['routesJson']);

      center[0] = data['center'][0];
      center[1] = data['center'][1];

      regionName.value = data['region_name'];

      courseLineData.value = data;
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

  Future<bool> addPlace(List<dynamic> places) async {
    List<dynamic> addData = [];
    List<dynamic> placePosTemp = List<dynamic>.from(placesPosition.value);
    List<double> centerTemp = List<double>.from(center.value);
    String regionNameTem = '-';

    for (int i = 0;i < places.length;i++) {
      addData.add({
        'place': {
          'id': places[i]['id']
        },
        'order': coursePlaceData.length + i + 1
      });
      placePosTemp.add(places[i]['location']);
    }

    Map<String, dynamic> newLine = {};
    if (placePosTemp.length > 1) {
      Map<String, dynamic>? newLineResult = await _courseProvider.getCourseLine(placePosTemp);
      if (newLineResult == null) {
        print('1\n$placePosTemp');
        return false;
      }
      newLine = newLineResult;
      centerTemp = UnitConverter.findCenter(placePosTemp.expand(
              (element) => [[element['lon'], element['lat']]]).toList());
    } else {
      centerTemp = [placePosTemp[0]['lat'], placePosTemp[0]['lon']];
    }

    newLine['center'] = centerTemp;

    Map<String, dynamic>? newRegion = await _courseProvider.getReverseGeocode(LatLng(centerTemp[0], centerTemp[1]));
    if (newRegion == null) {
      print(2);
      return false;
    }
    regionNameTem = newRegion['region_name'];

    newLine['region_name'] = regionNameTem;

    Map<String, dynamic>? result = await _courseProvider.patchMyCourseData(courseId, {
      'placesInCourse': addData,
      'routesJson': json.encode(newLine)
    });

    if (result == null) {
      print('3');
      return false;
    }

    coursePlaceData.addAll(result!['placesInCourse']);

    placesPosition.clear();
    placesPosition.addAll(placePosTemp);

    center[0] = centerTemp[0];
    center[1] = centerTemp[1];
    center.refresh();

    regionName.value = regionNameTem;

    courseLineData.value = newLine;

    update();
    return true;
  }
}