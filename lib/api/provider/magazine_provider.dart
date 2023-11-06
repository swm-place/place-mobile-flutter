import 'dart:convert';

import 'package:http/http.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';

class MagazineProvider extends DefaultProvider {
  Future<List<dynamic>?> getMagazineList() async {
    Uri uri = Uri.parse("$baseUrl/api/course-magazines");
    Response response;

    try {
      response = await get(uri, headers: await setHeader(false));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMagazine(dynamic id) async {
    Uri uri = Uri.parse("$baseUrl/api/course-magazines/$id");
    Response response;

    try {
      response = await get(uri, headers: await setHeader(false));
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