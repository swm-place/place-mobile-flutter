import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';

class CourseAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CourseAddPageState();
}

class _CourseAddPageState extends State<CourseAddPage> {

  List<Map<String, dynamic>> _selectedAddPlace = [
    // {},
    // {},
    // {},
    // {},
    // {},
    // {},
  ];

  List<Map<String, dynamic>> _places = [
    {
      "imageUrl": "https://source.unsplash.com/random?seq=2",
      "placeName": "날쏘고가라",
      "placeType": "레포츠",
      "location": {
        'lat': 37.553979,
        'lon': 126.922668
      },
      "open": "영업중",
      "tags": [
        {"text": "조용한", "color": RandomGenerator.generateRandomDarkHexColor()},
        {"text": "넓은", "color": RandomGenerator.generateRandomDarkHexColor()},
      ]
    },
    {
      "imageUrl": "https://source.unsplash.com/random?seq=3",
      "placeName": "니컷네컷 홍대점",
      "placeType": "사진",
      "location": {
        'lat': 37.554218,
        'lon': 126.922398
      },
      "open": "영업중",
      "tags": [
        {"text": "조용한", "color": RandomGenerator.generateRandomDarkHexColor()},
        {"text": "넓은", "color": RandomGenerator.generateRandomDarkHexColor()},
      ]
    },
    {
      "imageUrl": "https://source.unsplash.com/random?seq=4",
      "placeName": "무신사 테라스 홍대",
      "placeType": "옷가게",
      "location": {
        'lat': 37.557574,
        'lon': 126.926882
      },
      "open": "영업중",
      "tags": [
        {"text": "조용한", "color": RandomGenerator.generateRandomDarkHexColor()},
        {"text": "넓은", "color": RandomGenerator.generateRandomDarkHexColor()},
      ]
    },
    {
      "imageUrl": "https://source.unsplash.com/random?seq=5",
      "placeName": "산울림1992",
      "placeType": "주점",
      "location": {
        'lat': 37.554666,
        'lon': 126.930591
      },
      "open": "영업중",
      "tags": [
        {"text": "조용한", "color": RandomGenerator.generateRandomDarkHexColor()},
        {"text": "넓은", "color": RandomGenerator.generateRandomDarkHexColor()},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    if (bottomPadding == 0) {
      bottomPadding = 24;
    } else {
      bottomPadding = 0;
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text('장소 추가', style: SectionTextStyle.sectionTitle(),)
                      ),
                      Ink(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                            child: Icon(Icons.close, size: 18,),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12,),
                  RoundedRectangleSearchBar(
                    elevation: 0,
                    borderRadius: 8,
                    hintText: "검색어",
                    fillColor: Colors.grey[200]!,
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    onSuffixIconPressed: () {
                      print("searchbar clicked");
                    },
                  ),
                  const SizedBox(height: 12,),
                  _selectedAddPlace.isEmpty ?
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey,
                        )
                    ),
                    child: const Center(
                      child: Text('추가할 장소를 선택해주세요'),
                    ),
                  ) : Container(
                    height: 45,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedAddPlace.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SelectedPlaceCard();
                      },
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 12,),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12,),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        RoundedRowRectanglePlaceCard(
                          imageUrl: _places[0]['imageUrl'],
                          tags: _places[0]['tags'],
                          placeName: _places[0]['placeName'],
                          placeType: _places[0]['placeType'],
                          open: _places[0]['open'],
                          distance: '1.3km',
                          elevation: 0,
                          borderRadius: 0,
                          imageBorderRadius: 8,
                          imagePadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                        ),
                        RoundedRowRectanglePlaceCard(
                          imageUrl: _places[0]['imageUrl'],
                          tags: _places[0]['tags'],
                          placeName: _places[0]['placeName'],
                          placeType: _places[0]['placeType'],
                          open: _places[0]['open'],
                          distance: '1.3km',
                          elevation: 0,
                          borderRadius: 0,
                          imageBorderRadius: 8,
                          imagePadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                        ),
                        RoundedRowRectanglePlaceCard(
                          imageUrl: _places[0]['imageUrl'],
                          tags: _places[0]['tags'],
                          placeName: _places[0]['placeName'],
                          placeType: _places[0]['placeType'],
                          open: _places[0]['open'],
                          distance: '1.3km',
                          elevation: 0,
                          borderRadius: 0,
                          imageBorderRadius: 8,
                          imagePadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                        ),
                      ],
                    )
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              Container(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('추가')
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
