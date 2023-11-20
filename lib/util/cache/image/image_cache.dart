import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class CacheImageManager {
  Future<Uint8List> fetchImage(String url,
      {int retry = 3, int timeout = 3}) async {
    int failCount = 0;
    while (failCount < retry) {
      try {
        try {
          var file = await DefaultCacheManager().getSingleFile(url);
          if (await file.exists()) {
            var res = await file.readAsBytes();
            return res;
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }

        final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: timeout));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        } else {
          throw Exception('Fail to load data.');
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        failCount++;
      }
    }
    return (await rootBundle.load('images/sample.png')).buffer.asUint8List();
  }
}
