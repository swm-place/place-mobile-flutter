import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/section/topbar/picture_flexible.dart';
import 'package:place_mobile_flutter/widget/section/topbar/topbar_flexible_button.dart';

class Magazine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MagazineState();
}

class _MagazineState extends State<Magazine> {

  bool likeClicked = false;

  Widget _createHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text("매거진 제목", style: PageTextStyle.headlineBold(Colors.black)),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://source.unsplash.com/random'),
            ),
            const SizedBox(width: 10,),
            Text("작성자", style: SectionTextStyle.sectionContent(Colors.black),),
            const SizedBox(width: 10,),
            Text("2022.01.01", style: SectionTextStyle.labelMedium(Colors.grey),),
          ],
        )
      ],
    ),
  );

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
                  actions: [
                    FlexibleTopBarActionButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          likeClicked = !likeClicked;
                        });
                      },
                      icon: likeClicked ? Icon(
                        MdiIcons.heart,
                        color: Colors.pink,
                        size: 18,
                      ) : Icon(
                        MdiIcons.heartOutline,
                        size: 18,
                      ),
                    ),
                  ],
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
                    _createHeader()
                  ]),
                )
              ],
            );
          },
        )
    );
  }
}
