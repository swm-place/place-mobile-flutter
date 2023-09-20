import 'dart:convert';

import 'package:http/http.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';

class CourseProvider extends DefaultProvider {
  Future<Map<String, dynamic>?> getCourseLine(List<Map<String, dynamic>> coordinates) async {
    String course = coordinates.expand((element) => [element.values.join(',')]).toList().join(';');
    Uri uri = Uri.parse("http://192.168.0.2:50000/route/v1/foot/$course?step=true");
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