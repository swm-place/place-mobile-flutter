import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/map/course_provider.dart';
import 'package:place_mobile_flutter/util/utility.dart';

class CourseController extends GetxController {
  static CourseController get to => Get.find();

  final CourseProvider _courseProvider = CourseProvider();

  RxList<Map<String, dynamic>> coursePlaceData = RxList([]);
  RxList<Map<String, double>> placesPosition = RxList([]);
  Rxn<Map<String, dynamic>> courseLineData = Rxn(null);

  Future<void> getCourseData() async {
    coursePlaceData.clear();
    await Future.delayed(const Duration(seconds: 2));
    print('object');
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

    getCourseLineData();
  }

  Future<void> getCourseLineData() async {
    Map<String, dynamic>? result = await _courseProvider.getCourseLine(placesPosition);
    if (result == null) {
      courseLineData.value = null;
      courseLineData.refresh();
      return;
    }

    courseLineData.value = result;
    courseLineData.refresh();
  }
}