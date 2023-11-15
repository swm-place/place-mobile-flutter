import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';

class PlaceProvider extends DefaultProvider {
  Future<Map<String, dynamic>?> getPlaceRecommendSection() async {
    Uri uri = Uri.parse("$baseUrl/api-recommender/recommendation/collection/preset");
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

  Future<Map<String, dynamic>?> getPlaceData(String placeId) async {
    Uri uri = Uri.parse("$baseUrl/api-recommender/places/$placeId");
    Response response;
    try {
      response = await get(uri, headers: await setHeader(AuthController.to.user.value != null));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getPlaceSearchData(String? source, String? hashtag, String keyword, double lat, double lon, double radius) async {
    String uriString = "$baseUrl/api-recommender/places/?keyword=${Uri.encodeComponent(keyword)}&lat=$lat&lon=$lon&radius=$radius";
    if (source != null) uriString += "&source=$source";
    if (hashtag != null) uriString += "&hashtag=$hashtag";

    Uri uri = Uri.parse(uriString);
    Response response;

    try {
      response = await get(uri, headers: await setHeader(AuthController.to.user.value != null));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getPlaceReviewData(String placeId, String orderBy, int offset, int count, bool my) async {
    Uri uri = Uri.parse("$baseUrl/api-recommender/places/$placeId/reviews?order_by=$orderBy&count=$count&offset=$offset&only_my_reviews=$my");
    Response response;

    try {
      response = await get(uri, headers: await setHeader(AuthController.to.user.value != null));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> postPlaceReviewData(String placeId, String content) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (idToken == null || user == null) {
      return null;
    }

    Uri uri = Uri.parse("$baseUrl/api-recommender/places/$placeId/reviews");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await post(uri, headers: header, body: json.encode({
        "contents": content
      }));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<bool> postPlaceReviewLike(String placeId, dynamic reviewId) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (idToken == null || user == null) {
      return false;
    }

    Uri uri = Uri.parse("$baseUrl/api-recommender/places/$placeId/reviews/$reviewId/likes");
    Map<String, String>? header = await setHeader(true);

    Response response;
    try {
      response = await post(uri, headers: header);
    } catch(e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePlaceReviewLike(String placeId, dynamic reviewId) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (idToken == null || user == null) {
      return false;
    }

    Uri uri = Uri.parse("$baseUrl/api-recommender/places/$placeId/reviews/$reviewId/likes");
    Map<String, String>? header = await setHeader(true);

    Response response;
    try {
      response = await delete(uri, headers: header);
    } catch(e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePlaceReview(String placeId, dynamic reviewId) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (idToken == null || user == null) {
      return false;
    }

    Uri uri = Uri.parse("$baseUrl/api-recommender/places/$placeId/reviews/$reviewId");
    Map<String, String>? header = await setHeader(true);

    Response response;
    try {
      response = await delete(uri, headers: header);
    } catch(e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postPlaceLike(String placeId) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (idToken == null || user == null) {
      return false;
    }

    Uri uri = Uri.parse("$baseUrl/api/user/${user.uid}/place-favorite");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await post(uri, headers: header, body: json.encode({
        "placeId": placeId
      }));
    } catch(e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePlaceLike(String placeId) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (idToken == null || user == null) {
      return false;
    }

    Uri uri = Uri.parse("$baseUrl/api/user/${user.uid}/place-favorite/$placeId");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await delete(uri, headers: header);
    } catch(e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}