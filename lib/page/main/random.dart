import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';

class RandomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomPageState();
  }
}

class RandomPageState extends State<RandomPage> with AutomaticKeepAliveClientMixin<RandomPage> {
  final List<Map<String, dynamic>> _categoryCandidates = [
    {
      "id": null,
      "tag": "컨텐츠",
      "parent": null,
      "group_large": null,
      "rating": 0
    },
    {
      "id": null,
      "tag": "영화",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "공연",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "콘서트",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "연극",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "뮤지컬",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "오페라",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "클래식",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "전시",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "콘서트",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "미술관",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "박물관",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "팝업스토어",
      "parent": "컨텐츠",
      "group_large": "컨텐츠",
      "rating": 0
    },
    {
      "id": null,
      "tag": "액티비티",
      "parent": null,
      "group_large": null,
      "rating": 0
    },
    {
      "id": null,
      "tag": "볼링",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "보드게임",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "만화카페",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "공방",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "레저",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "테마파크",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "놀이공원",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "방탈출",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "워터파크",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "스키",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "스파",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "동물원",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "아쿠아리움",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "클라이밍",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "탁구",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "당구",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "수상레저",
      "parent": "액티비티",
      "group_large": "액티비티",
      "rating": 0
    },
    {
      "id": null,
      "tag": "휴식/산책",
      "parent": null,
      "group_large": null,
      "rating": 0
    },
    {
      "id": null,
      "tag": "찜질방",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0
    },
    {
      "id": null,
      "tag": "공원",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0
    },
    {
      "id": null,
      "tag": "한강",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0
    },
    {
      "id": null,
      "tag": "산책로",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0
    },
    {
      "id": null,
      "tag": "피크닉",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0
    },
    {
      "id": null,
      "tag": "야경",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0
    },
    {
      "id": null,
      "tag": "캠핑",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0
    },
    {
      "id": null,
      "tag": "호캉스",
      "parent": "휴식/산책",
      "group_large": "휴식/산책",
      "rating": 0
    },
    {
      "id": null,
      "tag": "쇼핑/복합문화공간",
      "parent": null,
      "group_large": null,
      "rating": 0
    },
    {
      "id": null,
      "tag": "대형마트",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0
    },
    {
      "id": null,
      "tag": "쇼핑몰",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0
    },
    {
      "id": null,
      "tag": "문구",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0
    },
    {
      "id": null,
      "tag": "패션",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0
    },
    {
      "id": null,
      "tag": "오브제",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0
    },
    {
      "id": null,
      "tag": "소품샵",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0
    },
    {
      "id": null,
      "tag": "뷰티",
      "parent": "쇼핑/복합문화공간",
      "group_large": "쇼핑/복합문화공간",
      "rating": 0
    },
    {
      "id": null,
      "tag": "카페",
      "parent": null,
      "group_large": null,
      "rating": 0
    },
    {
      "id": null,
      "tag": "뷰가 좋은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "조용한",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "작업하기 좋은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "독서하기 좋은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "펫과 함께",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "넓은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "작은",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "아늑한",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "커피가 맛있는",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "디저트가 맛있는",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "대형",
      "parent": "카페",
      "group_large": "카페",
      "rating": 0
    },
    {
      "id": null,
      "tag": "음식점",
      "parent": null,
      "group_large": null,
      "rating": 0
    },
    {
      "id": null,
      "tag": "한식",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0
    },
    {
      "id": null,
      "tag": "중식",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0
    },
    {
      "id": null,
      "tag": "양식",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0
    },
    {
      "id": null,
      "tag": "일식",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0
    },
    {
      "id": null,
      "tag": "술집",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0
    },
    {
      "id": null,
      "tag": "바",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0
    },
    {
      "id": null,
      "tag": "이자카야",
      "parent": "음식점",
      "group_large": "음식점",
      "rating": 0
    },
    {
      "id": null,
      "tag": "기타",
      "parent": null,
      "group_large": null,
      "rating": 0
    },
    {
      "id": null,
      "tag": "데이트",
      "parent": "기타",
      "group_large": "기타",
      "rating": 0
    },
    {
      "id": null,
      "tag": "공부/작업",
      "parent": "기타",
      "group_large": "기타",
      "rating": 0
    }
  ];

  @override
  bool get wantKeepAlive => true;

  Widget _createChipSelectionSection(StateSetter bottomState, List<Map<String, dynamic>> data, String categoryName) {
    List<Widget> chips = [];
    for (int i = 0;i < data.length;i++) {
      // int rating = data[i]['rating'];
      chips.add(
          TagPreferenceChip(
            label: Text(data[i]['tag'], style: const TextStyle(color: Colors.black),),
            priority: data[i]['rating'],
            onTap: () {
              bottomState(() {
                data[i]['rating']++;
                if (data[i]['rating'] > 2) data[i]['rating'] = 0;
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
      String? group_large = _categoryCandidates[i]['group_large'];
      if (group_large == null) {
        if (!data.containsKey(group_large)) {
          data[_categoryCandidates[i]['tag']] = [];
          continue;
        }
      }
      if (data.containsKey(group_large!)) {
        data[group_large!].add(_categoryCandidates[i]);
      } else {
        data[group_large!] = [_categoryCandidates[i]];
      }
    }
    return data;
  }

  List<Widget> _createTagPreferenceSection(StateSetter bottomState) {
    Map<String, dynamic> data = _preprocessTagPref();
    // print(data);
    List<Widget> section = [
      SizedBox(
        width: double.infinity,
        child: Text('선호 태그 설정', style: SectionTextStyle.sectionTitle(),),
      ),
      const SizedBox(height: 8,),
      SizedBox(
        width: double.infinity,
        child: Text('태그를 클릭하면 선호도가 3단계로 변경됩니다. 가장 높은 선호도는 최대 5개의 태그만 지정할 수 있습니다.', style: SectionTextStyle.sectionContent(Colors.grey[500]!),),
      ),
      const SizedBox(height: 24,)
    ];
    for (var k in data.keys) {
      section.add(_createChipSelectionSection(bottomState, List<Map<String, dynamic>>.from(data[k]), k));
      section.add(const SizedBox(height: 24,));
    }
    return section;
  }

  Widget _createChipSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded(
          //   child: ListView.builder(
          //     itemBuilder: (BuildContext context, int index) {
          //
          //     },
          //   ),
          // ),
          TagSelectionChip(
            label: Text('태그설정', style: TextStyle(color: lightColorScheme.primary),),
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
                child: GridView.custom(
                  // physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  gridDelegate: SliverQuiltedGridDelegate(
                      mainAxisSpacing: 6,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                      crossAxisSpacing: 6,
                      crossAxisCount: 5,
                      pattern: [
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 2),
                        const QuiltedGridTile(1, 3),
                        const QuiltedGridTile(2, 1),
                        const QuiltedGridTile(1, 2),
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(1, 2),
                      ]
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(((context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network("https://source.unsplash.com/random?sig=$index", fit: BoxFit.cover,),
                    );
                  })),
                ),
              )
            )
          ],
        )
      ),
    );
  }
}