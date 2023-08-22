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

  void _getYoutubeData(String? pageToken) async {
    Map<String, dynamic>? result = await _youtubeProvider.getSearchData(query.join('%7C'), pageToken);
    log(result.toString());
    randomData.refresh();
  }

  void initYoutubeData() async {
    _getYoutubeData(null);
  }

  void nextYoutubeData() async {
    _getYoutubeData(_nextPageToken);
  }

  void prevYoutubeData() async {
    _getYoutubeData(_prevPageToken);
  }

  @override
  void onReady() {
    initYoutubeData();
    super.onReady();
  }
}