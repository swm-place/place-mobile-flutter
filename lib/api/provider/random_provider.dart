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

class NaverBlogProvider extends DefaultProvider {
  Map<String, String>? _getHeader() {
    return {
      'X-Naver-Client-Id': API_NAVER_CLIENT_ID,
      'X-Naver-Client-Secret': API_NAVER_CLIENT_SECRET
    };
  }

  Future<Map<String, dynamic>?> getSearchData(String query, int startIndex) async {
    print("query: $query");
    print("startIndex: $startIndex");

    String uriString = "https://openapi.naver.com/v1/search/image?start=$startIndex&display=100&query=$query&sort=sim&filter=small";
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
      print('get naver blog data fail: ${response.statusCode}');
      return null;
    }
  }
}

class KakaoBlogProvider extends DefaultProvider {
  Map<String, String>? _getHeader() {
    return {
      'Authorization': 'KakaoAK $API_KAKAO_API_KEY',
    };
  }

  Future<Map<String, dynamic>?> getSearchData(String query, int page) async {
    print("query: $query");
    print("page: $page");

    String uriString = "https://dapi.kakao.com/v2/search/blog?query=$query&sort=accuracy&size=50&page=$page";
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
      print('get naver blog data fail: ${response.statusCode}');
      return null;
    }
  }
}
