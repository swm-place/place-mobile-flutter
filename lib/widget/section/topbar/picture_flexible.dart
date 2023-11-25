import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/widget/cache_image.dart';

class PictureFlexibleSpace extends StatelessWidget {
  PictureFlexibleSpace({
    this.imageUrl,
    Key? key
  }) : super(key: key);

  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Opacity(
          opacity: opacity,
          child: Column(
            children: [
              Flexible(
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: imageUrl != null ?
                    NetworkCacheImage(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ) :
                    Image.asset('assets/images/empty.png', fit: BoxFit.fitHeight,),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MultiplePictureFlexibleSpace extends StatelessWidget {
  MultiplePictureFlexibleSpace({
    this.imageUrl,
    Key? key
  }) : super(key: key);

  List<String?>? imageUrl;

  List<Widget> _generateImages() {
    if (imageUrl == null) return [];

    List<Widget> images = [];
    for (var image in imageUrl!) {
      if (image != null) {
        images.add(
          Expanded(
            child: NetworkCacheImage(
              image!,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          )
        );
      }
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        List<Widget> images = _generateImages();

        return Opacity(
          opacity: opacity,
          child: Column(
            children: [
              Flexible(
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: images.isNotEmpty ?
                    Row(
                      children: images,
                    ) :
                  Image.asset('assets/images/empty.png', fit: BoxFit.fitHeight,),
                  // child: imageUrl != null ?
                  //   Image.network(
                  //     imageUrl!,
                  //     fit: BoxFit.cover,
                  //   ) :
                  // Image.asset('assets/images/empty.png', fit: BoxFit.fitHeight,)
                  // ,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}