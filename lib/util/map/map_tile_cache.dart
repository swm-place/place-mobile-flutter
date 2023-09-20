import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:flutter/painting.dart';
import 'package:http/retry.dart';

class CacheTileProvider extends TileProvider {
  CacheTileProvider({
    super.headers = const {},
    BaseClient? httpClient,
  }) : httpClient = httpClient ?? RetryClient(Client());

  final BaseClient httpClient;

  @override
  ImageProvider<Object> getImage(TileCoordinates coordinates, TileLayer options) =>
      _FlutterMapNetworkImageProvider(
        url: getTileUrl(coordinates, options),
        fallbackUrl: getTileFallbackUrl(coordinates, options),
        headers: headers,
        httpClient: httpClient,
      );
}

class _FlutterMapNetworkImageProvider
    extends ImageProvider<_FlutterMapNetworkImageProvider> {
  final String url;

  final String? fallbackUrl;

  final BaseClient httpClient;

  final Map<String, String> headers;

  _FlutterMapNetworkImageProvider({
    required this.url,
    required this.fallbackUrl,
    required this.headers,
    required this.httpClient,
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
    final Uint8List bytes;
    try {
      bytes = await httpClient.readBytes(
        Uri.parse(useFallback ? fallbackUrl ?? '' : url),
        headers: headers,
      );
    } catch (_) {
      if (useFallback) rethrow;
      return _loadAsync(key, chunkEvents, decode, useFallback: true);
    }

    return decode(await ImmutableBuffer.fromUint8List(bytes));
  }
}
