import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/widget/section/topbar/picture_flexible.dart';

class Magazine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MagazineState();
}

class _MagazineState extends State<Magazine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // print(constraints.maxWidth);
            double commentHeight = 58640 / (constraints.maxWidth - 96);
            return CustomScrollView(
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
                  flexibleSpace: const PictureFlexibleSpace(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([

                  ]),
                )
              ],
            );
          },
        )
    );
  }
}
