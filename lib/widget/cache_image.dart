import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/util/cache/image/image_cache.dart';

class NetworkCacheImage extends StatefulWidget {
  NetworkCacheImage(this.url, {
    this.retry = 10,
    this.timeout = 3,
    this.fit,
    Key? key
  }) : super(key: key);

  final String url;
  final int retry;
  final int timeout;
  final BoxFit? fit;

  @override
  State<StatefulWidget> createState() => _NetworkCacheImageState();
}

class _NetworkCacheImageState extends State<NetworkCacheImage> {
  final CacheImageManager cacheImageManager = CacheImageManager();

  late Future<Uint8List> image;

  String oldUrl = '';

  @override
  void initState() {
    super.initState();
    oldUrl = widget.url;
    image = cacheImageManager.fetchImage(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    if (oldUrl != widget.url) {
      oldUrl = widget.url;
      image = cacheImageManager.fetchImage(
        widget.url,
        retry: widget.retry,
        timeout: widget.timeout,
      );
    }
    return FutureBuilder<Uint8List>(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data as Uint8List,
            fit: widget.fit ?? BoxFit.cover,
          );
        } else if (snapshot.hasError) {
          return Image.asset('assets/images/no_image.png', fit: widget.fit ?? BoxFit.cover,);
        }
        return Image.asset('assets/images/no_image.png', fit: widget.fit ?? BoxFit.cover,);
      },
    );
  }
}
