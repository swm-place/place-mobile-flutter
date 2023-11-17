import 'dart:math' as math;

import 'package:flutter/material.dart';

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
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ) :
                  Image.asset('assets/images/empty.png', fit: BoxFit.fitHeight,)
                  ,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}