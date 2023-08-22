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

  Future<Map<String, dynamic>?> getPlaceRecommendSection(String query) async {
    String? apiKey = _getKey();
    if (apiKey == null) return null;

    Uri uri = Uri.parse("https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=25&q=$query&regionCode=KR&type=video&videoCategoryId=22&key=$apiKey");
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