import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/place_provider.dart';
import 'package:place_mobile_flutter/state/gis_controller.dart';
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
  final PlaceProvider _placeProvider = PlaceProvider();

  late final TextEditingController placeEditController;

  List<dynamic> _selectedAddPlace = [];
  List<dynamic> _places = [];

  @override
  void initState() {
    placeEditController = TextEditingController();
    super.initState();
  }

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
                    textEditingController: placeEditController,
                    onSuffixIconPressed: () async {
                      String keyword = placeEditController.text.toString();
                      if (keyword == '') {
                        return;
                      }
                      List<dynamic>? result = await _placeProvider.getPlaceSearchData('google', null, keyword, 37.574863, 126.977725, 5000);
                      if (result != null) {
                        for (int c = 0;c < result.length;c++) {
                          for (int i = 0;i < result[c]['hashtags'].length;i++) {
                            String name = result[c]['hashtags'][i];
                            result[c]['hashtags'][i] = {
                              "text": name,
                              "color": RandomGenerator.generateRandomDarkHexColor()
                            };
                          }
                          if (GISController.to.userPosition.value == null) {
                            result[c]['distance'] = null;
                          } else {
                            double lat2 = result[c]['location']['lat'];
                            double lon2 = result[c]['location']['lon'];
                            result[c]['distance'] = GISController.to.haversineDistance(lat2, lon2);
                          }
                        }
                        setState(() {
                          _places = result;
                        });
                      }
                    },
                  ),
                  //TODO: search position check
                  // const SizedBox(height: 12,),
                  // RoundedRectangleSearchBar(
                  //   elevation: 0,
                  //   borderRadius: 8,
                  //   hintText: "검색어",
                  //   fillColor: Colors.grey[200]!,
                  //   contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  //   onSuffixIconPressed: () {
                  //     print("searchbar clicked");
                  //   },
                  // ),
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
                child: ListView.separated(
                  itemCount: _places.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {

                      },
                      child: RoundedRowRectangleCartPlaceCard(
                        imageUrl: _places[index]['photos'] != null && _places[index]['photos'].length > 0 ?
                        "$baseUrlDev/api-recommender/place-photo/?${_places[index]['photos'][0]['url'].split('?')[1]}&max_width=480" :
                        null,
                        tags: _places[index]['hashtags'],
                        placeName: _places[index]['name'],
                        placeType: _places[index]['category'],
                        open: _places[index]['open_now'] != null ? (_places[index]['open_now'] ? '영업중' : '영업중 아님') : null,
                        distance:_places[index]['distance'] == null ?
                        null : UnitConverter.formatDistance(_places[index]['distance']),
                        elevation: 0,
                        borderRadius: 0,
                        imageBorderRadius: 8,
                        imagePadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                        onAddPressed: () {
                          bool exist = false;
                          for (int i = 0;i < _selectedAddPlace.length;i++) {
                            if (_selectedAddPlace[i]['id'] == _places[index]['id']) {
                              exist = true;
                              break;
                            }
                          }
                          if (exist) {
                            Get.dialog(
                              AlertDialog(
                                contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                                titlePadding: EdgeInsets.zero,
                                content: const Text("해당 장소는 이미 추가 목록에 있거나 코스에 포함된 장소입니다. 그래도 추가하시겠습니까?"),
                                actions: [
                                  TextButton(onPressed: () {
                                      Get.back();
                                      addPlaceInCandidate(_places[index]);
                                    }, child: const Text('추가')),
                                  TextButton(onPressed: () {Get.back();}, child: const Text('취소', style: TextStyle(color: Colors.redAccent),))
                                ],
                              ),
                            );
                            return;
                          }
                          addPlaceInCandidate(_places[index]);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 4,);
                  },
                ),
              ),
              const SizedBox(height: 12,),
              SizedBox(
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

  void addPlaceInCandidate(dynamic placeData) {
    setState(() {
      _selectedAddPlace.insert(0, placeData);
    });
  }
}
