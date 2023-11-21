import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/api/provider/course_provider.dart';
import 'package:place_mobile_flutter/api/provider/magazine_provider.dart';
import 'package:place_mobile_flutter/page/course/course_main.dart';
import 'package:place_mobile_flutter/page/place/place_detail.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/cache_image.dart';
import 'package:place_mobile_flutter/widget/section/topbar/picture_flexible.dart';
import 'package:place_mobile_flutter/widget/section/topbar/topbar_flexible_button.dart';
import 'package:latlong2/latlong.dart';

class Magazine extends StatefulWidget {
  Magazine({
    required this.magazineId,
    this.imageUrl,
    Key? key
  }) : super(key: key);

  dynamic magazineId;

  String? imageUrl;

  @override
  State<StatefulWidget> createState() => _MagazineState();
}

class _MagazineState extends State<Magazine> {

  final MagazineProvider _magazineProvider = MagazineProvider();
  final CourseProvider _courseProvider = CourseProvider();

  bool likeClicked = false;
  bool asyncLike = false;

  int _loadData = -1;

  Map<String, dynamic>? _magazineData;

  @override
  void initState() {
    getMagazineData();
    super.initState();
  }

  void like() async {
    asyncLike = true;

    bool result;
    if (!likeClicked) {
      result = await _magazineProvider.postMagazineLike(_magazineData!['id']);
    } else {
      result = await _magazineProvider.deleteMagazineLike(_magazineData!['id']);
    }

    if (result) {
      HapticFeedback.lightImpact();
      setState(() {
        likeClicked = !likeClicked;
      });
    }

    asyncLike = false;
  }

  void _convertCourse() async {
    Get.dialog(
        const AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
          actionsPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 24),
              Text('코스로 변환중'),
            ],
          ),
        ),
        barrierDismissible: false
    );

    String title = '매거진 to 코스';
    List<dynamic> places = [];
    for (int i = 0;i < _magazineData!['placesInCourseMagazine'].length;i++) {
      places.add({
        "place": {
          "id": _magazineData!['placesInCourseMagazine'][i]['place']['id']
        },
        "order": i + 1,
      });
    }
    Map<String, dynamic>? result = await _courseProvider.postMyCourseData(title, places);

    if (result == null) {
      Get.back();

      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("코스 변환 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
      return;
    }

    List<double> centerTemp = [];
    String regionNameTem = '';
    List<dynamic> placePos = result['placesInCourse'].expand((element) =>
      [element['place']['location']]).toList();

    Map<String, dynamic> newLine = {};
    if (placePos.length > 1) {
      Map<String, dynamic>? newLineResult = await _courseProvider.getCourseLine(placePos);
      if (newLineResult == null) {
        print(1);
        Get.back();
        Get.dialog(
          AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
            titlePadding: EdgeInsets.zero,
            content: const Text("코스 변환 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
            actions: [
              TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
            ],
          ),
        );
        return;
      }
      newLine = newLineResult;
      centerTemp = UnitConverter.findCenter(newLine['routes'][0]['geometry']['coordinates']);
    } else {
      centerTemp = [placePos[0]['lat'], placePos[0]['lon']];
    }

    newLine['center'] = centerTemp;

    Map<String, dynamic>? newRegion = await _courseProvider.getReverseGeocode(LatLng(centerTemp[0], centerTemp[1]));
    if (newRegion == null) {
      print(2);
      Get.back();
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("코스 변환 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
      return;
    }
    regionNameTem = newRegion['region_name'];
    newLine['region_name'] = regionNameTem;

    Map<String, dynamic>? patchResult = await _courseProvider.patchMyCourseData(result['id'], {
      'placesInCourse': [],
      'routesJson': json.encode(newLine)
    });

    if (patchResult == null) {
      print('3');
      Get.back();
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("코스 변환 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
      return;
    }

    Get.back();
    Get.to(() => CourseMainPage(courseId: result['id']));
  }

  @override
  Widget build(BuildContext context) {
    if (_loadData != -1) {
      if (_loadData == 1) {
        return Scaffold(
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      actions: [
                        FlexibleTopBarActionButton(
                            onPressed: () {
                              _convertCourse();
                            },
                            icon: const Icon(Icons.swap_horiz, size: 18,)
                        ),
                        FlexibleTopBarActionButton(
                          onPressed: () {
                            like();
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
                      flexibleSpace: PictureFlexibleSpace(
                        imageUrl: widget.imageUrl,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(_createMagazineSection()),
                    )
                  ],
                );
              },
            )
        );
      } else {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
              child: Text('오류 발생')
          ),
        );
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  void getMagazineData() async {
    Map<String, dynamic>? result = await _magazineProvider.getMagazine(widget.magazineId);
    if (result != null) {
      _magazineData = result;
      if (result['isFavorite'] != null) likeClicked = result['isFavorite'];

      setState(() {
        _loadData = 1;
      });
    } else {
      setState(() {
        _loadData = 0;
      });
    }
  }

  Widget _createHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(_magazineData!['title'], style: PageTextStyle.headlineBold(Colors.black)),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _magazineData!['user']['imgUrl'] != null ?
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(_magazineData!['user']['imgUrl']),
              ) :
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/avatar_male.png'),
              ),
            const SizedBox(width: 10,),
            Text(_magazineData!['user']['nickname'], style: SectionTextStyle.sectionContent(Colors.black),),
            if (_magazineData!['createdAt'] != null)
              const SizedBox(width: 10,),
            if (_magazineData!['createdAt'] != null)
              Text(_magazineData!['createdAt'], style: SectionTextStyle.labelMedium(Colors.grey),),
          ],
        )
      ],
    ),
  );

  Widget _createTextContentSection(String content) => Container(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
    width: double.infinity,
    child: Text(content, style: SectionTextStyle.sectionContentLine(Colors.black),),
  );

  Widget _createDividerSection() => Center(
    child: Container(
      // width: double.infinity,
      constraints: const BoxConstraints(
          maxWidth: 250
      ),
      child: const Divider(
        height: 1,
        color: Colors.black87,
      ),
    ),
  );

  Widget _createPlaceContentSection(String title, String content, String? imgUrl, String placeId) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Text(title, style: SectionTextStyle.sectionTitle(),)),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                onPressed: () {
                  Get.to(() => PlaceDetailPage(placeId: placeId));
                },
                  padding: EdgeInsets.all(0),
                icon: const Icon(Icons.info_outline, size: 24,)
              ),
            )
          ],
        ),
        const SizedBox(height: 18,),
        Container(
          constraints: const BoxConstraints(
            maxHeight: 200
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imgUrl != null ?
                NetworkCacheImage(imgUrl) :
                Image.asset('assets/images/no_image.png'),
            ),
          ),
        ),
        const SizedBox(height: 18,),
        Text(content, style: SectionTextStyle.sectionContentLine(Colors.black),)
      ],
    ),
  );

  Widget _createImageSection(String imgUrl, String? description) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
    child: Column(
      children: [
        Container(
          constraints: const BoxConstraints(
              maxHeight: 200
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkCacheImage(imgUrl),
            ),
          ),
        ),
        const SizedBox(height: 8,),
        if (description != null) Text(description, style: SectionTextStyle.labelMedium(Colors.grey),)
      ],
    ),
  );

  List<Widget> _createMagazineSection() {
    List<Widget> section = [_createHeader(), const SizedBox(height: 20)];
    section.add(_createTextContentSection(_magazineData!['contents']));
    section.add(const SizedBox(height: 24,));
    section.add(_createDividerSection());
    section.add(const SizedBox(height: 24,));
    for (var place in _magazineData!['placesInCourseMagazine']) {
      section.add(_createPlaceContentSection(
        place['place']['name'],
        place['contents'],
        ImageParser.parseImageUrl(place['place']['imgUrl']),
        place['place']['id']
      ));
      section.add(const SizedBox(height: 24,));
    }
    // for (int i = 0;i < _magazineContents['contents'].length;i++) {
    //   Map<String, dynamic> content =  _magazineContents['contents'][i];
    //   if (i > 0) section.add(const SizedBox(height: 24,));
    //   switch(content['type']) {
    //     case 'text': {
    //       section.add(_createTextContentSection(content['content']));
    //       break;
    //     }
    //     case 'divider': {
    //       section.add(_createDividerSection());
    //       break;
    //     }
    //     case 'placeCard': {
    //       section.add(_createPlaceContentSection(
    //         content['title'],
    //         content['placeContent'],
    //         content['placePicture']
    //       ));
    //       break;
    //     }
    //     case 'image': {
    //       section.add(_createImageSection(
    //         content['imgUrl'],
    //         content['description']
    //       ));
    //       break;
    //     }
    //   }
    // }
    return section;
  }
}
