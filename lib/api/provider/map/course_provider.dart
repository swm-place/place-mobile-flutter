import 'dart:convert';

import 'package:http/http.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';

class CourseProvider extends DefaultProvider {
  Future<Map<String, dynamic>?> getCourseLine(List<Map<String, dynamic>> coordinates) async {
    String course = coordinates.expand((element) => ["${element['lon']},${element['lat']}"]).toList().join(';');
    Uri uri = Uri.parse("$routeBaseUrl/route/v1/foot/$course?steps=true");
    Response response;
    try {
      response = await get(uri, headers: setHeader(null));
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