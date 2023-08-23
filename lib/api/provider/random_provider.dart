import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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

  Map<String, String>? _getHeader() {
    if (Platform.isAndroid) {
      return {
        'x-android_package_name': HEADER_ANDROID_BUNDLE,
        'x-android_cert_fingerprint': kDebugMode ? HEADER_ANDROID_CERT_DEBUG : HEADER_ANDROID_CERT_RELEASE
      };
    } else if (Platform.isIOS) {
      return {
        'x-ios-bundle-identifier': HEADER_IOS_BUNDLE
      };
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSearchData(String query, String? pageToken) async {
    String? apiKey = _getKey();
    print("query: $query");
    print("pageToken: $pageToken");
    print("apiKey: $apiKey");
    if (apiKey == null) return null;

    String uriString = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=$query&regionCode=KR&relevanceLanguage=ko&type=video&videoCategoryId=19&key=$apiKey";
    if (pageToken != null) uriString += "&pageToken=$pageToken";
    Uri uri = Uri.parse(uriString);
    Response response;
    try {
      response = await get(uri, headers: _getHeader());
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('get youtube data fail: ${response.statusCode}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPopularData(String? pageToken) async {
    String? apiKey = _getKey();
    print("pageToken: $pageToken");
    print("apiKey: $apiKey");
    if (apiKey == null) return null;

    String uriString = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&chart=mostPopular&regionCode=KR&videoCategoryId=19&key=$apiKey";
    if (pageToken != null) uriString += "&pageToken=$pageToken";
    Uri uri = Uri.parse(uriString);
    Response response;
    try {
      response = await get(uri, headers: _getHeader());
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('get youtube data fail: ${response.statusCode}');
      return null;
    }
  }
}