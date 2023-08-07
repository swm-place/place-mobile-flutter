import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

import 'dart:math' as math;

import 'package:place_mobile_flutter/widget/tag/tag_chip.dart';

class PlaceDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlaceDetailPageState();
  }
}

class _PlaceDetailPageState extends State<PlaceDetailPage> with TickerProviderStateMixin {
  late final AnimationController _likeButtonController;

  bool likePlace = false;

  @override
  void initState() {
    _likeButtonController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading:IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Ink(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: Platform.isAndroid ? EdgeInsets.zero : EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: Icon(
                      Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                      size: 18,
                    ),
                  ),
                ),
              ),
              pinned: true,
              expandedHeight: 220.0,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              flexibleSpace: _PlacePictureFlexibleSpace(),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _detailHead()
              ]),
            )
          ],
        )
      ),
    );
  }

  Widget _detailHead() => Padding(
    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "사려니 숲길",
                  style: placeDetailTitle,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  TagChip(
                    text: "#자연",
                    textStyle: placeDetailTagText,
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                  ),
                  SizedBox(width: 4,),
                  TagChip(
                    text: "#자연",
                    textStyle: placeDetailTagText,
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                  ),
                  SizedBox(width: 4,),
                  TagChip(
                    text: "#자연",
                    textStyle: placeDetailTagText,
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                  ),
                ],
              )
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                print("bookmark");
              },
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(MdiIcons.bookmarkPlusOutline),
                    Text("북마크")
                  ],
                ),
              ),
            ),
            SizedBox(width: 12,),
            GestureDetector(
              onTap: () {
                setState(() {
                  likePlace = !likePlace;
                  if (likePlace) {
                    _likeButtonController.animateTo(1);
                  } else {
                    _likeButtonController.animateBack(0);
                  }
                });
              },
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: 24,
                      // height: 24,
                      child: Lottie.asset(
                          "assets/lottie/animation_like_button.json",
                          repeat: false,
                          reverse: false,
                          width: 32,
                          height: 32,
                          controller: _likeButtonController,
                          onLoaded: (conposition) {
                            _likeButtonController.duration = conposition.duration;
                            if (likePlace) {
                              _likeButtonController.animateTo(1);
                            } else {
                              _likeButtonController.animateBack(0);
                            }
                          }
                      ),
                    ),
                    Text("1.2K")
                  ],
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}

class _PlacePictureFlexibleSpace extends StatelessWidget {
  const _PlacePictureFlexibleSpace({Key? key}) : super(key: key);

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
                child: Container(
                  width: double.infinity,
                  child: Image.network(
                    'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
