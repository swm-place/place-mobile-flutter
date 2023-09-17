import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/widget/section/topbar/picture_flexible.dart';
import 'package:place_mobile_flutter/widget/section/topbar/topbar_flexible_button.dart';

class CourseMainPage extends StatefulWidget {
  const CourseMainPage({
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends State<CourseMainPage> {
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
                  leading: FlexibleTopBarActionButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                      size: 18,
                    ),
                    iconPadding: Platform.isAndroid ? EdgeInsets.zero : const EdgeInsets.fromLTRB(6, 0, 0, 0),
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
