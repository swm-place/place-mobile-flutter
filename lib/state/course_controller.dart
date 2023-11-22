import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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

  RxList<dynamic> bookmarkData = RxList();

  RxList<double> center = RxList([37.574863, 126.977725]);
  RxString regionName = RxString('-');
  RxString title = RxString('');

  Future<bool> getCourseData() async {
    Map<String, dynamic>? result = await _courseProvider.getMyCourseDataById(courseId);
    if (result == null) {
      return false;
    }

    title.value = result['title'];

    for (var place in result['placesInCourse']) {
      if (place['place']['hashtags'] == null) {
        place['place']['hashtags'] = [];
        continue;
      }

      List<dynamic> hashtags = [];
      for (var tag in place['place']['hashtags']) {
        hashtags.add({
          'text': tag,
          'color': RandomGenerator.generateRandomDarkHexColor()
        });
      }
      place['place']['hashtags'] = hashtags;
    }

    coursePlaceData.value = result['placesInCourse'];
    if (result['bookmarks'] != null) bookmarkData.value = result['bookmarks'];

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

  Future<bool> changePlaceOrder(int oldIndex, int newIndex) async {
    List<dynamic> coursePlaceTmp = List<dynamic>.from(coursePlaceData.value);
    // List<double> centerTemp = List<double>.from(center.value);
    // String regionNameTem = '-';

    int beforeOrder = coursePlaceTmp[oldIndex]['order'];
    coursePlaceTmp[oldIndex]['order'] = coursePlaceTmp[newIndex]['order'];
    coursePlaceTmp[newIndex]['order'] = beforeOrder;

    List<dynamic> placePatchData = [
      {
        'id': coursePlaceTmp[oldIndex]['id'],
        'place': {
          'id': coursePlaceTmp[oldIndex]['place']['id']
        },
        'order': coursePlaceTmp[oldIndex]['order'],
        "day": coursePlaceTmp[oldIndex]['day'],
        "startAt": coursePlaceTmp[oldIndex]['startAt'],
        "timeRequired": coursePlaceTmp[oldIndex]['timeRequired'],
        "transportationTime": coursePlaceTmp[oldIndex]['transportationTime'],
        "createdAt": coursePlaceTmp[oldIndex]['createdAt']
      },
      {
        'id': coursePlaceTmp[newIndex]['id'],
        'place': {
          'id': coursePlaceTmp[newIndex]['place']['id']
        },
        'order': coursePlaceTmp[newIndex]['order'],
        "day": coursePlaceTmp[newIndex]['day'],
        "startAt": coursePlaceTmp[newIndex]['startAt'],
        "timeRequired": coursePlaceTmp[newIndex]['timeRequired'],
        "transportationTime": coursePlaceTmp[newIndex]['transportationTime'],
        "createdAt": coursePlaceTmp[newIndex]['createdAt']
      }
    ];

    final Map<String, dynamic> item = coursePlaceTmp.removeAt(oldIndex);
    coursePlaceTmp.insert(newIndex, item);

    List<dynamic> placePositionTmp = coursePlaceTmp.expand((element) =>
      [element['place']['location']]).toList();

    Map<String, dynamic> newLine = {};
    if (placePositionTmp.length > 1) {
      Map<String, dynamic>? newLineResult = await _courseProvider.getCourseLine(placePositionTmp);
      if (newLineResult == null) {
        print('1\n$placePositionTmp');
        return false;
      }
      newLine = newLineResult;
      // centerTemp = UnitConverter.findCenter(newLine['routes'][0]['geometry']['coordinates']);
    }

    newLine['center'] = courseLineData.value!['center'];
    newLine['region_name'] = courseLineData.value!['region_name'];

    // newLine['center'] = centerTemp;

    // Map<String, dynamic>? newRegion = await _courseProvider.getReverseGeocode(LatLng(centerTemp[0], centerTemp[1]));
    // if (newRegion == null) {
    //   print(2);
    //   return false;
    // }
    // regionNameTem = newRegion['region_name'];
    // newLine['region_name'] = regionNameTem;

    Map<String, dynamic>? result = await _courseProvider.patchMyCourseData(courseId, {
      'placesInCourse': placePatchData,
      'routesJson': json.encode(newLine)
    });

    if (result == null) {
      print('3');
      return false;
    }

    coursePlaceData.value = coursePlaceTmp;

    placesPosition.clear();
    placesPosition.addAll(placePositionTmp);

    // center[0] = centerTemp[0];
    // center[1] = centerTemp[1];
    // center.refresh();

    // regionName.value = regionNameTem;

    courseLineData.value = newLine;

    update();

    return true;
  }

  Future<bool> deletePlace(int index) async {
    List<dynamic> coursePlaceTmp = List<dynamic>.from(coursePlaceData.value);
    List<double> centerTemp = List<double>.from(center.value);
    String regionNameTem = '-';

    dynamic deletePlaceId = coursePlaceTmp.removeAt(index)['id'];
    List<dynamic> placePositionTmp = coursePlaceTmp.expand((element) =>
    [element['place']['location']]).toList();

    Future<bool> getRegionName() async {
      Map<String, dynamic>? newRegion = await _courseProvider.getReverseGeocode(LatLng(centerTemp[0], centerTemp[1]));
      if (newRegion == null) {
        print(2);
        return false;
      }
      regionNameTem = newRegion['region_name'];
      return true;
    }

    Map<String, dynamic> newLine = {};
    if (placePositionTmp.length > 1) {
      Map<String, dynamic>? newLineResult = await _courseProvider.getCourseLine(placePositionTmp);
      if (newLineResult == null) {
        print('1\n$placePositionTmp');
        return false;
      }
      newLine = newLineResult;
      centerTemp = UnitConverter.findCenter(newLine['routes'][0]['geometry']['coordinates']);
      getRegionName();
    } else {
      if (placePositionTmp.length == 1) {
        centerTemp = [placePositionTmp[0]['lat'], placePositionTmp[0]['lon']];
        getRegionName();
      } else {
        centerTemp = [37.574863, 126.977725];
        regionNameTem = '-';
      }
    }

    newLine['center'] = centerTemp;
    newLine['region_name'] = regionNameTem;

    bool resultDelete = await _courseProvider.deletePlaceInMyCourseData(courseId, deletePlaceId);
    if (!resultDelete) {
      return false;
    }

    Map<String, dynamic>? result = await _courseProvider.patchMyCourseData(courseId, {
      'placesInCourse': [],
      'routesJson': json.encode(newLine)
    });

    if (result == null) {
      return false;
    }

    coursePlaceData.value = coursePlaceTmp;

    placesPosition.clear();
    placesPosition.addAll(placePositionTmp);

    center[0] = centerTemp[0];
    center[1] = centerTemp[1];
    center.refresh();

    regionName.value = regionNameTem;

    courseLineData.value = newLine;

    update();

    return true;
  }

  Future<bool> addPlace(List<dynamic> places) async {
    List<dynamic> addData = [];
    List<dynamic> placePosTemp = List<dynamic>.from(placesPosition.value);
    List<double> centerTemp = List<double>.from(center.value);
    String regionNameTem = '-';

    for (int i = 0;i < places.length;i++) {
      int order = 0;
      if (coursePlaceData.isNotEmpty) {
        order = coursePlaceData[coursePlaceData.length - 1]['order'] + i + 1;
      } else {
        order = i + 1;
      }
      addData.add({
        'place': {
          'id': places[i]['id']
        },
        'order': order
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
      centerTemp = UnitConverter.findCenter(newLine['routes'][0]['geometry']['coordinates']);
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

    for (var place in result['placesInCourse']) {
      if (place['place']['hashtags'] == null) {
        place['place']['hashtags'] = [];
        continue;
      }

      List<dynamic> hashtags = [];
      for (var tag in place['place']['hashtags']) {
        hashtags.add({
          'text': tag,
          'color': RandomGenerator.generateRandomDarkHexColor()
        });
      }
      place['place']['hashtags'] = hashtags;
    }

    coursePlaceData.clear();
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

  Future<bool> changeTitle(String title) async {
    Map<String, dynamic>? result = await _courseProvider.patchMyCourseData(courseId, {
      'title': title,
      'placesInCourse': [],
    });

    if (result != null) {
      this.title.value = title;
      return true;
    }

    return false;
  }
}