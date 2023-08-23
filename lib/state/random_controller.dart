import 'dart:developer';

import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/random_provider.dart';
import 'package:place_mobile_flutter/util/utility.dart';

class RandomController extends GetxController {
  static RandomController get to => Get.find();

  RxList<Map<String, dynamic>> randomData = RxList();

  List<String> query = ['국내 추천'];
  List<String> queryNegative = ['-음악', '-스포츠', '-뉴스'];

  String? _nextPageToken;
  String? _prevPageToken;

  int _startPage = 0;
  int _maxPage = 0;

  bool _finish = false;

  final YoutubeProvider _youtubeProvider = YoutubeProvider();
  final NaverBlogProvider _naverBlogProvider = NaverBlogProvider();
  final KakaoBlogProvider _kakaoBlogProvider = KakaoBlogProvider();

  Future<List<Map<String, dynamic>>?> _getYoutubeData(String? pageToken) async {
    // Map<String, dynamic>? result = await _youtubeProvider.getSearchData('${query.join('%7C')} ${queryNegative.join(' ')}', pageToken);
    Map<String, dynamic>? result = await _youtubeProvider.getPopularData(pageToken);
    if (result == null) return null;

    try {
      _prevPageToken = result['prevPageToken'];
    } catch(e) {
      _prevPageToken = null;
    }

    try {
      _nextPageToken = result['nextPageToken'];
    } catch(e) {
      _nextPageToken = null;
    }
    return List<Map<String, dynamic>>.from(result['items']);
  }

  void initYoutubeData() async {
    List<Map<String, dynamic>>? data = await _getYoutubeData(null);
    print(data.toString());
    randomData.clear();
    if (data == null) {
      randomData.refresh();
    } else {
      randomData.addAll(data);
      randomData.refresh();
    }
  }

  void nextYoutubeData() async {
    List<Map<String, dynamic>>? data = await _getYoutubeData(_nextPageToken);
    if (data != null) {
      randomData.addAll(data);
      randomData.refresh();
    }
  }

  void addYoutubeTag(String tag) async {
    query.add(tag);
    initYoutubeData();
  }

  void removeYoutubeTag(String tag) async {
    query.remove(tag);
    initYoutubeData();
  }

  // void prevYoutubeData() async {
  //   _getYoutubeData(_prevPageToken);
  // }

  Future<List<Map<String, dynamic>>?> _getNaverBlogData() async {
    Map<String, dynamic>? result = await _naverBlogProvider.getSearchData(query.join('%7C'), _startPage);
    if (result == null) return null;
    _maxPage = result['total'];
    return List<Map<String, dynamic>>.from(result['items']);
  }

  void initNaverBlogData() async {
    _startPage = 1;
    _maxPage = 0;
    List<Map<String, dynamic>>? data = await _getNaverBlogData();
    // print(data.toString());
    randomData.clear();
    if (data != null) randomData.addAll(data);
    randomData.refresh();
  }

  void nextNaverData() async {
    if (_startPage > _maxPage || _startPage > 1000) return;

    _startPage += 100;
    List<Map<String, dynamic>>? data = await _getNaverBlogData();
    if (data != null) {
      randomData.addAll(data);
      randomData.refresh();
    }
  }

  void addNaverTag(String tag) async {
    query.add(tag);
    initNaverBlogData();
  }

  void removeNaverTag(String tag) async {
    query.remove(tag);
    initNaverBlogData();
  }

  Future<List<Map<String, dynamic>>?> _getKakaoBlogData() async {
    Map<String, dynamic>? result = await _kakaoBlogProvider.getSearchData(query.join('%7C'), _startPage);
    if (result == null) return null;
    _finish = result['meta']['is_end'];

    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result['documents']);
    for (int i = 0;i < data.length;i++) {
      data[i]['color'] = RandomGenerator.getRandomLightMaterialColor();
    }
    return data;
  }

  void initKakaoBlogData() async {
    _startPage = 1;
    _finish = false;
    List<Map<String, dynamic>>? data = await _getKakaoBlogData();
    // print(data.toString());
    randomData.clear();
    if (data != null) randomData.addAll(data);
    randomData.refresh();
  }

  void nextKakaoData() async {
    if (_finish || _startPage > 10) return;

    _startPage++;
    List<Map<String, dynamic>>? data = await _getKakaoBlogData();
    if (data != null) {
      randomData.addAll(data);
      randomData.refresh();
    }
  }

  void addKakaoTag(String tag) async {
    query.add(tag);
    initKakaoBlogData();
  }

  void removeKakaoTag(String tag) async {
    query.remove(tag);
    initKakaoBlogData();
  }

  void initKakaoTag(List<String> tags) async {
    query = ['국내 추천'];
    query.addAll(tags);
    initKakaoBlogData();
  }

  @override
  void onReady() {
    // initYoutubeData();
    // initNaverBlogData();
    // initKakaoBlogData();
    super.onReady();
  }
}