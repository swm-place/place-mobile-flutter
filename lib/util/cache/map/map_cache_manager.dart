import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MapCacheManager {
  static const key = 'mapTileKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 50,
      repo: JsonCacheInfoRepository(databaseName: key),
    ),
  );
}