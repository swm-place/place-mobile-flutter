import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/story/story_my_card.dart';

class BookmarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BookmarkPageState();
  }
}

class BookmarkPageState extends State<BookmarkPage> with AutomaticKeepAliveClientMixin<BookmarkPage> {
  final List<Map<String, dynamic>> _myStoryData =[
    {
      "title": "23",
      'share': true,
      'editor': [
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=9",
        },
      ],
      "places": null
    },
    {
      "title": "23",
      'share': true,
      'editor': [
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=9",
        },
      ],
      "places": [
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=15"
        },
      ]
    },
    {
      "title": "title",
      'share': false,
      "places": [
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=1"
        },
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=2"
        },
      ]
    },
    {
      "title": "23",
      'share': true,
      'editor': [
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=3",
        },
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=4",
        },
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=5",
        },
      ],
      "places": [
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=6"
        },
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=7"
        },
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=8"
        },
      ]
    },
    {
      "title": "23",
      'share': true,
      'editor': [
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=9",
        },
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=10",
        },
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=11",
        },
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=12",
        },
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=13",
        },
        {
          'name': 'name',
          'profileUrl': "https://source.unsplash.com/random?sig=14",
        },
      ],
      "places": [
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=15"
        },
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=16"
        },
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=17"
        },
        {
          "name": "name",
          'imageUrl': "https://source.unsplash.com/random?sig=18"
        },
      ]
    },
  ];

  @override
  bool get wantKeepAlive => true;

  Widget _searchSection() => Padding(
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
    child: RoundedRectangleSearchBar(
      elevation: 0,
      borderRadius: 8,
      hintText: "검색어",
      fillColor: Colors.grey[200]!,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      onSuffixIconPressed: () {
        print("searchbar clicked");
      },
    ),
  );

  Widget _myStorySection() {
    List<Widget> placeCards = [const SizedBox(width: 24,)];
    for (int i = 0;i < _myStoryData.length;i++) {
      placeCards.add(
          MyStoryCard(
            title: _myStoryData[i]['title'],
            // message: _relevanceStoryData[i]['message'],
            // location: _relevanceStoryData[i]['location'],
            // imageUrl: _relevanceStoryData[i]['background'],
            width: 250,
            height: 180,
            editors: _myStoryData[i]['editor'],
            places: _myStoryData[i]['places'],
          )
      );
      placeCards.add(const SizedBox(width: 8,));
    }
    placeCards.add(const SizedBox(width: 16,));

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
        title: "내 스토리",
        action: Ink(
          child: InkWell(
            onTap: () {},
            child: Text(
              "전체보기",
              style: SectionTextStyle.labelMedium(Colors.blue),
            ),
          ),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: placeCards,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _searchSection(),
              _myStorySection()
            ],
          ),
        )
      ),
    );
  }
}