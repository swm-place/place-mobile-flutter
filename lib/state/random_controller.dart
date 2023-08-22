import 'dart:developer';

import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/random_provider.dart';

class RandomController extends GetxController {
  static RandomController get to => Get.find();

  RxList<Map<String, dynamic>> randomData = RxList();

  List<String> query = ['대한민국', '한국'];

  String? _nextPageToken;
  String? _prevPageToken;

  final YoutubeProvider _youtubeProvider = YoutubeProvider();

  Future<List<Map<String, dynamic>>?> _getYoutubeData(String? pageToken) async {
    Map<String, dynamic>? result = await _youtubeProvider.getSearchData(query.join('%7C'), pageToken);
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
    if (data == null) {
      randomData.clear();
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

  // void prevYoutubeData() async {
  //   _getYoutubeData(_prevPageToken);
  // }

  @override
  void onReady() {
    initYoutubeData();
    super.onReady();
  }
}