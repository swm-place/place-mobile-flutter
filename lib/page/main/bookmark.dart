import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/state/bookmark_controller.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/validator.dart';
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

  late final TextEditingController _bookmarkNameController;
  late final  BookmarkController _bookmarkController;

  String? _bookmarkNameError;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    _bookmarkNameController = TextEditingController();
    _bookmarkController = BookmarkController();
    _bookmarkController.loadPlaceBookmark();
    _bookmarkController.loadCourseBookmark();
    super.initState();
  }

  @override
  void dispose() {
    _bookmarkNameController.dispose();
    _bookmarkController.dispose();
    super.dispose();
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
                // _myStorySection(),
                _locationBookmarkSection(),
                _storyBookmarkSection(),
                SizedBox(height: 24,)
              ],
            ),
          )
      ),
    );
  }

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

  // Widget _myStorySection() {
  //   List<Widget> placeCards = [const SizedBox(width: 24,)];
  //   for (int i = 0;i < _myStoryData.length;i++) {
  //     placeCards.add(
  //         MyStoryCard(
  //           title: _myStoryData[i]['title'],
  //           width: 250,
  //           height: 180,
  //           editors: _myStoryData[i]['editor'],
  //           places: _myStoryData[i]['places'],
  //         )
  //     );
  //     placeCards.add(const SizedBox(width: 8,));
  //   }
  //   placeCards.add(const SizedBox(width: 16,));
  //
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
  //     child: MainSection(
  //       title: "내 스토리",
  //       action: Ink(
  //         child: InkWell(
  //           onTap: () {},
  //           child: Text(
  //             "전체보기",
  //             style: SectionTextStyle.labelMedium(Colors.blue),
  //           ),
  //         ),
  //       ),
  //       content: SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: Row(
  //           children: placeCards,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _locationBookmarkSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
        title: "장소 북마크",
        action: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: lightColorScheme.primary
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Icon(Icons.add, size: 18, color: Colors.black,),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter dialogState) {
                        return AlertDialog(
                          title: Text("북마크 추가"),
                          content: TextField(
                            maxLength: 50,
                            controller: _bookmarkNameController,
                            onChanged: (text) {
                              dialogState(() {
                                setState(() {
                                  _bookmarkNameError = bookmarkTextFieldValidator(text);
                                });
                              });
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "북마크 이름",
                                errorText: _bookmarkNameError
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: Text('취소', style: TextStyle(color: Colors.red),),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: Text('만들기', style: TextStyle(color: Colors.blue),),
                            )
                          ],
                        );
                      },
                    );
                  }
              );
            },
          ),
        ),
        content: SizedBox(
          width: double.infinity,
          child: Obx(() {
            String? msg;
            if (_bookmarkController.placeBookmark.value == null) {
              msg = "북마크를 가져오는 과정에서 오류가 발생했습니다 :(";
            } else if (_bookmarkController.placeBookmark.value!.isEmpty) {
              msg = "아직 생성한 북마크가 없습니다 :(";
            }

            if (msg != null) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300]
                  ),
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(msg),
                  ),
                ),
              );
            }

            return SizedBox(
              width: double.infinity,
              height: 288,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _bookmarkController.placeBookmark.value!.length,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                itemBuilder: (context, index) {
                  return BookmarkCard(
                    title: _bookmarkController.placeBookmark.value![index]['title'],
                    width: 140,
                    height: 140,
                    placeImageUrls: _bookmarkController.placeBookmark.value![index]['thumbnailInfoList']
                        .map((item) => "$baseUrlDev${item['placeImgUrl'].toString()}").toList(),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _storyBookmarkSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
        title: "코스 북마크",
        action: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: lightColorScheme.primary
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Icon(Icons.add, size: 18, color: Colors.black,),
            ),
            onTap: () {
              // Navigator.pop(context);
            },
          ),
        ),
        // action: Ink(
        //   child: InkWell(
        //     onTap: () {},
        //     child: Text(
        //       "전체보기",
        //       style: SectionTextStyle.labelMedium(Colors.blue),
        //     ),
        //   ),
        // ),
        content: SizedBox(
          width: double.infinity,
          child: Obx(() {
            String? msg;
            if (_bookmarkController.courseBookmark.value == null) {
              msg = "북마크를 가져오는 과정에서 오류가 발생했습니다 :(";
            } else if (_bookmarkController.courseBookmark.value!.isEmpty) {
              msg = "아직 생성한 북마크가 없습니다 :(";
            }

            if (msg != null) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300]
                  ),
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(msg),
                  ),
                ),
              );
            }

            return SizedBox(
              width: double.infinity,
              height: 288,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _bookmarkController.courseBookmark.value!.length,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                itemBuilder: (context, index) {
                  return BookmarkCard(
                    title: _bookmarkController.courseBookmark.value![index]['title'],
                    width: 140,
                    height: 140,
                    placeImageUrls: ["$baseUrlDev${_bookmarkController.courseBookmark.value![index]['imgUrl']}"],
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}