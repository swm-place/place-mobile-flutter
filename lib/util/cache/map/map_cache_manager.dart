import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MapCacheManager {
  static const key = 'mapTileKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 180),
      maxNrOfCacheObjects: 3000,
      repo: JsonCacheInfoRepository(databaseName: key),
    ),
  );
}