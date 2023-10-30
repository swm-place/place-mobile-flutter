import 'dart:convert';

import 'package:http/http.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';

class PlaceProvider extends DefaultProvider {
  Future<Map<String, dynamic>?> getPlaceRecommendSection() async {
    Uri uri = Uri.parse("$baseUrl/api-recommender/recommendation/collection/preset");
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

  Future<Map<String, dynamic>?> getPlaceData(String placeId) async {
    Uri uri = Uri.parse("$baseUrl/api-recommender/places/$placeId");
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