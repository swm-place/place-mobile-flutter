import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/state/random_controller.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';
import 'package:get/get.dart';

import 'dart:convert';

class RandomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomPageState();
  }
}

class RandomPageState extends State<RandomPage> with AutomaticKeepAliveClientMixin<RandomPage> {
  final List<Map<String, dynamic>> _categoryCandidates = [
    {
      "id": 0,
      "tag": "영화",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 1,
      "tag": "공연",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 2,
      "tag": "콘서트",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 3,
      "tag": "연극",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 4,
      "tag": "뮤지컬",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 5,
      "tag": "오페라",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 6,
      "tag": "클래식",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 7,
      "tag": "전시",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 8,
      "tag": "콘서트",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 9,
      "tag": "미술관",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 10,
      "tag": "박물관",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 11,
      "tag": "팝업스토어",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0,
      "selection": false
    },
    {
      "id": 12,
      "tag": "볼링",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 13,
      "tag": "보드게임",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 14,
      "tag": "만화카페",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 15,
      "tag": "공방",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 16,
      "tag": "레저",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 17,
      "tag": "테마파크",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 18,
      "tag": "놀이공원",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 19,
      "tag": "방탈출",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 20,
      "tag": "워터파크",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 21,
      "tag": "스키",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 22,
      "tag": "스파",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 23,
      "tag": "동물원",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 24,
      "tag": "아쿠아리움",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 25,
      "tag": "클라이밍",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 26,
      "tag": "탁구",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 27,
      "tag": "당구",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 28,
      "tag": "수상레저",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0,
      "selection": false
    },
    {
      "id": 29,
      "tag": "찜질방",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0,
      "selection": false
    },
    {
      "id": 30,
      "tag": "공원",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0,
      "selection": false
    },
    {
      "id": 31,
      "tag": "한강",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0,
      "selection": false
    },
    {
      "id": 32,
      "tag": "산책로",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0,
      "selection": false
    },
    {
      "id": 33,
      "tag": "피크닉",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0,
      "selection": false
    },
    {
      "id": 34,
      "tag": "야경",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0,
      "selection": false
    },
    {
      "id": 35,
      "tag": "캠핑",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0,
      "selection": false
    },
    {
      "id": 36,
      "tag": "호캉스",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0,
      "selection": false
    },
    {
      "id": 37,
      "tag": "대형마트",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0,
      "selection": false
    },
    {
      "id": 38,
      "tag": "쇼핑몰",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0,
      "selection": false
    },
    {
      "id": 39,
      "tag": "문구",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0,
      "selection": false
    },
    {
      "id": 40,
      "tag": "패션",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0,
      "selection": false
    },
    {
      "id": 41,
      "tag": "오브제",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0,
      "selection": false
    },
    {
      "id": 42,
      "tag": "소품샵",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0,
      "selection": false
    },
    {
      "id": 43,
      "tag": "뷰티",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0,
      "selection": false
    },
    {
      "id": 44,
      "tag": "뷰가 좋은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 45,
      "tag": "조용한",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 46,
      "tag": "작업하기 좋은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 47,
      "tag": "독서하기 좋은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 48,
      "tag": "펫과 함께",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 49,
      "tag": "넓은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 50,
      "tag": "작은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 51,
      "tag": "아늑한",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 52,
      "tag": "커피가 맛있는",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 53,
      "tag": "디저트가 맛있는",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 54,
      "tag": "대형",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0,
      "selection": false
    },
    {
      "id": 55,
      "tag": "한식",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0,
      "selection": false
    },
    {
      "id": 56,
      "tag": "중식",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0,
      "selection": false
    },
    {
      "id": 57,
      "tag": "양식",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0,
      "selection": false
    },
    {
      "id": 58,
      "tag": "일식",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0,
      "selection": false
    },
    {
      "id": 59,
      "tag": "술집",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0,
      "selection": false
    },
    {
      "id": 60,
      "tag": "바",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0,
      "selection": false
    },
    {
      "id": 61,
      "tag": "이자카야",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0,
      "selection": false
    },
    {
      "id": 62,
      "tag": "데이트",
      "parent": "기타",
      "group_large": "기타",
      "rating": 0,
      "selection": false
    },
    {
      "id": 63,
      "tag": "공부/작업",
      "parent": "기타",
      "group_large": "기타",
      "rating": 0,
      "selection": false
    }
  ];

  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  Widget _createChipSelectionSection(StateSetter bottomState, List<Map<String, dynamic>> data, String categoryName) {
    List<Widget> chips = [];
    for (int i = 0;i < data.length;i++) {
      // int rating = data[i]['rating'];
      chips.add(
          TagSelectionChip(
            label: Text(data[i]['tag'], style: const TextStyle(color: Colors.black),),
            selection: data[i]['selection'],
            onTap: () {
              _scrollController.jumpTo(0);
              setState(() {
                bottomState(() {
                  data[i]['selection'] = !data[i]['selection'];
                  if (!data[i]['selection']) {
                    RandomController.to.removeKakaoTag(data[i]['tag']);
                  } else {
                    RandomController.to.addKakaoTag(data[i]['tag']);
                  }
                });
              });
            },
          )
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(categoryName, style: SectionTextStyle.sectionContentExtraLarge(Colors.black),),
          ),
          const SizedBox(height: 16,),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: chips,
            ),
          )
        ],
      ),
    );
  }

  Map<String, dynamic> _preprocessTagPref() {
    Map<String, dynamic> data = {};
    for (int i = 0;i < _categoryCandidates.length;i++) {
      // print(_categoryCandidates[i]);
      String groupLarge = _categoryCandidates[i]['group_large'];
      if (data.containsKey(groupLarge)) {
        data[groupLarge].add(_categoryCandidates[i]);
      } else {
        data[groupLarge] = [_categoryCandidates[i]];
      }
    }
    return data;
  }

  List<Widget> _createTagPreferenceSection(StateSetter bottomState) {
    Map<String, dynamic> data = _preprocessTagPref();
    List<Widget> section = [];
    for (var k in data.keys) {
      section.add(_createChipSelectionSection(bottomState, List<Map<String, dynamic>>.from(data[k]), k));
      section.add(const SizedBox(height: 24,));
    }
    return section;
  }

  List<Widget> _createSelectionChips() {
    List<Widget> selection = [];
    for (int index = 0;index < _categoryCandidates.length;index++) {
      if (_categoryCandidates[index]['selection']) {
        if (selection.isNotEmpty) selection.add(const SizedBox(width: 5,));
        selection.add(
            TagSelectionChip(
                label: Text(_categoryCandidates[index]['tag']),
                selection: _categoryCandidates[index]['selection'],
                onTap: () {
                  _scrollController.jumpTo(0);
                  setState(() {
                    _categoryCandidates[index]['selection'] = !_categoryCandidates[index]['selection'];
                    if (!_categoryCandidates[index]['selection']) {
                      RandomController.to.removeKakaoTag(_categoryCandidates[index]['tag']);
                    } else {
                      RandomController.to.addKakaoTag(_categoryCandidates[index]['tag']);
                    }
                  });
                }
            )
        );
      }
    }
    return selection;
  }

  Widget _createChipSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _createSelectionChips(),
              ),
            ),
          ),
          const SizedBox(width: 5,),
          TagSelectionChip(
            label: null,
            prefixIcon: Icon(MdiIcons.tune, color: lightColorScheme.primary, size: 18,),
            borderColor: lightColorScheme.primary,
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter bottomState) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: _createTagPreferenceSection(bottomState),
                                  ),
                                ),
                              ),
                              // SizedBox(height: 24,),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                                width: double.infinity,
                                child: FilledButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('닫기')
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    Get.put(RandomController());
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        print('next');
        // RandomController.to.nextYoutubeData();
        // RandomController.to.nextNaverData();
        RandomController.to.nextKakaoData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _createChipSection(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: GetX<RandomController>(
                  builder: (controller) {
                    return GridView.custom(
                      // physics: NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      controller: _scrollController,
                      gridDelegate: SliverQuiltedGridDelegate(
                          mainAxisSpacing: 6,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          crossAxisSpacing: 6,
                          crossAxisCount: 5,
                          pattern: [
                            const QuiltedGridTile(2, 2),
                            const QuiltedGridTile(1, 3),
                            const QuiltedGridTile(1, 3),
                            const QuiltedGridTile(1, 3),
                            const QuiltedGridTile(2, 2),
                            const QuiltedGridTile(1, 3),
                          ]
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                          ((context, index) {
                            return Ink(
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onTap: () {
                                  print(controller.randomData[index]['url']);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: controller.randomData[index]['thumbnail'] != '' ?
                                    Image.network(controller.randomData[index]['thumbnail'], fit: BoxFit.cover,) :
                                    Container(
                                      color: controller.randomData[index]['color'],
                                      width: double.infinity,
                                      height: double.infinity,
                                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                                      child: Center(
                                        child: AutoSizeText(
                                          HtmlUnescape().convert(HtmlParser.removeHtmlTags(controller.randomData[index]['title'])),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                        ),
                                      ),
                                    )
                                  // child: Image.network(controller.randomData[index]['snippet']['thumbnails']['medium']['url'], fit: BoxFit.cover,),
                                ),
                              ),
                            );
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(controller.randomData[index]['thumbnail'], fit: BoxFit.cover,),
                              // child: Image.network(controller.randomData[index]['snippet']['thumbnails']['medium']['url'], fit: BoxFit.cover,),
                            );
                          }),
                          childCount: controller.randomData.length
                      ),
                    );
                  },
                ),
              )
            )
          ],
        )
      ),
    );
  }
}