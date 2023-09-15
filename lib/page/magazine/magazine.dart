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

  final Map<String, dynamic> _magazineContents = {
    'title': '서울에서 느끼는 자연 코스로 즐기기',
    'author': {
      'name': "김준철",
      'profileUrl': 'https://source.unsplash.com/random?seq=2'
    },
    'createdAt': '2022.01.01',
    'contents': [
      {
        'type': 'text',
        'content': '되는 인간이 사람은 인류의 봄바람이다. 피가 길을 봄날의 끓는 트고, 때까지 같지 '
            '돋고, 인간의 것이다. 풀밭에 고행을 피가 창공에 같지 안고, 구하지 끝까지 이상을 부패뿐이다.'
            ' 오직 가지에 청춘 같지 따뜻한 사람은 풀이 약동하다. 사랑의 인간은 대한 물방아 긴지라 '
            '고행을 수 시들어 없으면 것이다. 가슴이 얼마나 밥을 우리의 희망의 뜨고, 지혜는 풀이 '
            '아름다우냐? 몸이 사랑의 불러 구하지 새 사라지지 이것은 뿐이다. 크고 피는 싹이 것이다. '
            '석가는 심장은 방지하는 소금이라 가치를 귀는 튼튼하며, 이것이다. 바이며, 천지는 없으면, '
            '그들의 않는 이상이 피어나기 봄바람이다.'
      },
      {
        'type': 'divider'
      },
      {
        'type': 'placeCard',
        'title': '장소 1',
        'placeUrl': '',
        'placePicture': 'https://images.unsplash.com/photo-1694384580420-46ce717aa50b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1287&q=80',
        'placeContent': '이름자를 이제 이런 다 소학교 말 이런 까닭이요, 있습니다. 옥 가을로 무성할'
            ' 우는 하나에 하나에 이름과 당신은 까닭입니다. 이네들은 지나가는 헤는 언덕 노새, 가을로 '
            '봅니다. 릴케 이름과 때 위에 있습니다. 가슴속에 별들을 아무 불러 쓸쓸함과 추억과 별빛이 '
            '애기 있습니다. 무덤 이름을 하늘에는 딴은 아무 자랑처럼 아침이 봅니다.'
      },
      {
        'type': 'placeCard',
        'title': '장소 2',
        'placeUrl': '',
        'placePicture': 'https://images.unsplash.com/photo-1693529831174-17595f68be87?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1476&q=80',
        'placeContent': '이름자를 이제 이런 다 소학교 말 이런 까닭이요, 있습니다. 옥 가을로 무성할'
            ' 우는 하나에 하나에 이름과 당신은 까닭입니다. 이네들은 지나가는 헤는 언덕 노새, 가을로 '
            '봅니다. 릴케 이름과 때 위에 있습니다. 가슴속에 별들을 아무 불러 쓸쓸함과 추억과 별빛이 '
            '애기 있습니다. 무덤 이름을 하늘에는 딴은 아무 자랑처럼 아침이 봅니다.'
      }
    ]
  };

  Widget _createHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(_magazineContents['title'], style: PageTextStyle.headlineBold(Colors.black)),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(_magazineContents['author']['profileUrl']),
            ),
            const SizedBox(width: 10,),
            Text(_magazineContents['author']['name'], style: SectionTextStyle.sectionContent(Colors.black),),
            const SizedBox(width: 10,),
            Text(_magazineContents['createdAt'], style: SectionTextStyle.labelMedium(Colors.grey),),
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

  Widget _createPlaceContentSection(String title, String content, String imgUrl) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: SectionTextStyle.sectionTitle(),),
        const SizedBox(height: 18,),
        Container(
          constraints: const BoxConstraints(
            maxHeight: 200
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                // fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18,),
        Text(content, style: SectionTextStyle.sectionContentLine(Colors.black),)
      ],
    ),
  );

  List<Widget> _createMagazineSection() {
    List<Widget> section = [_createHeader(), const SizedBox(height: 24)];
    for (int i = 0;i < _magazineContents['contents'].length;i++) {
      Map<String, dynamic> content =  _magazineContents['contents'][i];
      if (i > 0) section.add(const SizedBox(height: 24,));
      switch(content['type']) {
        case 'text': {
          section.add(_createTextContentSection(content['content']));
          break;
        }
        case 'divider': {
          section.add(_createDividerSection());
          break;
        }
        case 'placeCard': {
          section.add(
              _createPlaceContentSection(
                  content['title'],
                  content['placeContent'],
                  content['placePicture']
              )
          );
          break;
        }
      }
    }
    return section;
  }

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
                  delegate: SliverChildListDelegate(_createMagazineSection()),
                )
              ],
            );
          },
        )
    );
  }
}
