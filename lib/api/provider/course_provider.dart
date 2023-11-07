import 'dart:convert';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/api/secrets.dart';

class CourseProvider extends DefaultProvider {

  Map<String, String> setMapHeader() {
    return {API_KEY_MAP_KEY: API_KEY_MAP_VALUE};
  }

  Future<Map<String, dynamic>?> getCourseLine(List<Map<String, dynamic>> coordinates) async {
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
}