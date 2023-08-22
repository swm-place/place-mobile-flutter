import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/api/secrets.dart';

class YoutubeProvider extends DefaultProvider {
  String? _getKey() {
    if (Platform.isAndroid) {
      return API_KEY_ANDROID;
    } else if (Platform.isIOS) {
      return API_KEY_IOS;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSearchData(String query, String? pageToken) async {
    String? apiKey = _getKey();
    if (apiKey == null) return null;

    String uriString = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=$query&regionCode=KR&type=video&videoCategoryId=22&key=$apiKey";
    if (pageToken != null) uriString += "&pageToken=$pageToken";
    Uri uri = Uri.parse(uriString);
    Response response;
    try {
      response = await get(uri);
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