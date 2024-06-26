import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/api/secrets.dart';

class CourseProvider extends DefaultProvider {

  Map<String, String> setMapHeader() {
    return {API_KEY_MAP_KEY: API_KEY_MAP_VALUE};
  }

  Future<Map<String, dynamic>?> getCourseLine(List<dynamic> coordinates) async {
    String course = coordinates.expand((element) => ["${element['lon']},${element['lat']}"]).toList().join(';');
    Uri uri = Uri.parse("$routeBaseUrl/route/v1/foot/$course?steps=true&overview=full&geometries=geojson");
    Response response;
    try {
      response = await get(uri, headers: setMapHeader());
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getReverseGeocode(LatLng coordinate) async {
    Uri uri = Uri.parse("$geocodingBaseUrl/map/reverse-geocode?lat=${coordinate.latitude}&lon=${coordinate.longitude}&type=0&near=1");
    Response response;
    try {
      response = await get(uri, headers: setMapHeader());
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getMyCourseData(int page, int size) async {
    Uri uri = Uri.parse("$baseUrl/api/courses?size=$size&page=$page");
    Response response;
    try {
      response = await get(uri, headers: await setHeader(true));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print(response.body);
      return null;
    }
  }

  Future<List<dynamic>?> getMyCourseDataOne(int page, int size) async {
    Uri uri = Uri.parse("$baseUrl/api/courses/:one-place-each?size=$size&page=$page");
    Response response;
    try {
      response = await get(uri, headers: await setHeader(true));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print(response.body);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMyCourseDataById(dynamic id) async {
    Uri uri = Uri.parse("$baseUrl/api/courses/$id");
    Response response;
    try {
      response = await get(uri, headers: await setHeader(true));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<bool> deletePlaceInMyCourseData(dynamic courseId, dynamic placeId) async {
    Uri uri = Uri.parse("$baseUrl/api/courses/$courseId/places/$placeId");
    Response response;
    try {
      response = await delete(uri, headers: await setHeader(true));
    } catch(e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteMyCourseDataById(dynamic courseId) async {
    Uri uri = Uri.parse("$baseUrl/api/courses/$courseId");
    Response response;
    try {
      response = await delete(uri, headers: await setHeader(true));
    } catch(e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>?> patchMyCourseData(dynamic id, dynamic data) async {
    Uri uri = Uri.parse("$baseUrl/api/courses/$id");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await patch(uri, headers: header, body: json.encode(data));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print(response.body);
      return null;
    }
  }

  Future<Map<String, dynamic>?> postMyCourseData(String title, List<dynamic>? courseData) async {
    Uri uri = Uri.parse("$baseUrl/api/courses");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await post(uri, headers: header, body: json.encode({
        "title": title,
        "description": "",
        "placesInCourse": courseData ??= [],
        "inProgress": false,
        "finished": false
      }));
    } catch(e) {
      print(e.toString());
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print(response.body);
      return null;
    }
  }
}