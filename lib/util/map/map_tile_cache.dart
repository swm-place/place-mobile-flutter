import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:flutter/painting.dart';
import 'package:http/retry.dart';

class CacheTileProvider extends TileProvider {
  CacheTileProvider(this.cacheManager, {
    super.headers = const {},
    BaseClient? httpClient,
  }) : httpClient = httpClient ?? RetryClient(Client());

  final BaseClient httpClient;
  final CacheManager cacheManager;

  @override
  ImageProvider<Object> getImage(TileCoordinates coordinates, TileLayer options) {
    return _FlutterMapNetworkImageProvider(
      url: getTileUrl(coordinates, options),
      fallbackUrl: getTileFallbackUrl(coordinates, options),
      headers: headers,
      httpClient: httpClient,
      coordinates: coordinates.key,
      cacheManager: cacheManager
    );
  }
}

class _FlutterMapNetworkImageProvider
    extends ImageProvider<_FlutterMapNetworkImageProvider> {

  final String url;
  final String? fallbackUrl;

  final BaseClient httpClient;
  final Map<String, String> headers;

  final String coordinates;
  final CacheManager cacheManager;

  _FlutterMapNetworkImageProvider({
    required this.url,
    required this.fallbackUrl,
    required this.headers,
    required this.httpClient,
    required this.coordinates,
    required this.cacheManager,
  });

  @override
  ImageStreamCompleter loadImage(
      _FlutterMapNetworkImageProvider key,
      ImageDecoderCallback decode,
      ) {
    final StreamController<ImageChunkEvent> chunkEvents =
    StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: 1,
      debugLabel: url,
      informationCollector: () => [
        DiagnosticsProperty('URL', url),
        DiagnosticsProperty('Fallback URL', fallbackUrl),
        DiagnosticsProperty('Current provider', key),
      ],
    );
  }

  @override
  Future<_FlutterMapNetworkImageProvider> obtainKey(
      ImageConfiguration configuration,
      ) =>
      SynchronousFuture<_FlutterMapNetworkImageProvider>(this);

  Future<Codec> _loadAsync(
      _FlutterMapNetworkImageProvider key,
      StreamController<ImageChunkEvent> chunkEvents,
      ImageDecoderCallback decode, {
        bool useFallback = false,
      }) async {
    // cacheManager.getFileFromCache(coordinates);

    final Uint8List bytes;
    try {
      bytes = (await cacheManager.getSingleFile(
        useFallback ? fallbackUrl ?? '' : url,
        headers: headers,
        key: coordinates
      )).readAsBytesSync();
    } catch (_) {
      if (useFallback) rethrow;
      return _loadAsync(key, chunkEvents, decode, useFallback: true);
    }

    return decode(await ImmutableBuffer.fromUint8List(bytes));
  }
}
