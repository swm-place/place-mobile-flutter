import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/state/bookmark_controller.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
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
  final UserProvider _userProvider = UserProvider();

  late final TextEditingController _bookmarkNameController;
  late final  BookmarkController _bookmarkController;

  late ScrollController _placeScrollController;
  late ScrollController _courseScrollController;
  late ScrollController _bookmarkScrollController;

  bool loadVisibilityPlace = false;
  bool loadVisibilityCourse = false;
  bool loadVisibility = false;

  int placeBookmarkInit = -1;
  int courseBookmarkInit = -1;

  String? _bookmarkNameError;

  @override
  bool get wantKeepAlive => false;

  void addPlaceBookmarkList() async {
    loadVisibilityPlace = true;
    await _bookmarkController.addPlaceBookmarkList();
    loadVisibilityPlace = false;
  }

  void addCourseBookmarkList() async {
    loadVisibilityCourse = true;
    await _bookmarkController.addCourseBookmarkList();
    loadVisibilityCourse = false;
  }

  Future<void> initPlaceBookmark() async {
    setState(() {
      loadVisibilityPlace = true;
      placeBookmarkInit = 0;
    });
    bool result = await _bookmarkController.loadPlaceBookmark();
    if (result) {
      placeBookmarkInit = 1;
    } else {
      placeBookmarkInit = -1;
    }
    setState(() {
      loadVisibilityPlace = false;
    });
  }

  Future<void> initCourseBookmark() async {
    setState(() {
      loadVisibilityCourse = true;
      courseBookmarkInit = 0;
    });
    bool result = await _bookmarkController.loadCourseBookmark();
    if (result) {
      courseBookmarkInit = 1;
    } else {
      courseBookmarkInit = -1;
    }
    setState(() {
      loadVisibilityCourse = false;
    });
  }

  @override
  void initState() {
    _bookmarkNameController = TextEditingController();
    _bookmarkController = BookmarkController();
    _placeScrollController = ScrollController();
    _courseScrollController = ScrollController();
    _bookmarkScrollController = ScrollController();

    _placeScrollController.addListener(() {
      if (_placeScrollController.position.maxScrollExtent == _placeScrollController.offset && !loadVisibilityPlace) {
        addPlaceBookmarkList();
      }
    });

    _courseScrollController.addListener(() {
      if (_courseScrollController.position.maxScrollExtent == _courseScrollController.offset && !loadVisibilityCourse) {
        addCourseBookmarkList();
      }
    });

    initPlaceBookmark();
    initCourseBookmark();
    super.initState();
  }

  @override
  void dispose() {
    _bookmarkNameController.dispose();
    _bookmarkController.dispose();
    _placeScrollController.dispose();
    _courseScrollController.dispose();
    _bookmarkScrollController.dispose();
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
                // _searchSection(),
                // _myStorySection(),
                _locationBookmarkSection(),
                _storyBookmarkSection(),
                const SizedBox(height: 24,)
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

  void addPlaceBookmark(String text) async {
    Get.dialog(
      const AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
        actionsPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 24),
            Text('북마크 생성중'),
          ],
        ),
      ),
      barrierDismissible: false
    );
    bool result = await _bookmarkController.addPlaceBookmark(text);
    Get.back();
    if (result) {
      initPlaceBookmark();
    } else {
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("북마크 추가 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
    }
  }

  void addCourseBookmark(String text) async {
    Get.dialog(
      const AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
        actionsPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 24),
            Text('북마크 생성중'),
          ],
        ),
      ),
      barrierDismissible: false
    );
    bool result = await _bookmarkController.addCourseBookmark(text);
    Get.back();
    if (result) {
      initCourseBookmark();
    } else {
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("북마크 추가 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
    }
  }

  void deleteBookmark(dynamic bookmarkId, String type, String title) async {
    Get.dialog(
      const AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
        actionsPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 24),
            Text('북마크 삭제증'),
          ],
        ),
      ),
      barrierDismissible: false
    );

    bool result;
    if (type == 'place') {
      result = await _bookmarkController.deletePlaceBookmark(bookmarkId);
    } else {
      result = await _bookmarkController.deleteCourseBookmark(bookmarkId);
    }
    Get.back();

    if (result) {
      if (type == 'place') {
        initPlaceBookmark();
      } else {
        initCourseBookmark();
      }
    } else {
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("북마크 삭제 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
    }
  }

  void _showPlaceBookmarkSheet(String bookmarkTitle, dynamic bookmarkId) {
    //TODO: show place bookmark sheet
    bool stateFirst = true;
    bool loadVisibility = false;

    int page = 0;
    int size = 25;

    StateSetter? state;

    List<dynamic> _bookmarkData = [];

    void addPlaceData() async {
      state!(() {
        setState(() {
          loadVisibility = true;
        });
      });
      List<dynamic>? result = await _userProvider.getPlaceInBookmark(page, size, bookmarkId);

      if (result != null) {
        _bookmarkData.addAll(result);
        page++;
      }

      state!(() {
        setState(() {
          loadVisibility = false;
        });
      });
    }

    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter bottomState) {
              state = bottomState;
              if (stateFirst) {
                _bookmarkScrollController.addListener(() {
                  if (_bookmarkScrollController.position.maxScrollExtent == _bookmarkScrollController.offset && !loadVisibility) {
                    stateFirst = false;
                    addPlaceData();
                  }
                });
              }
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                                child: Text(bookmarkTitle, style: SectionTextStyle.sectionTitle(),)
                              ),
                              SizedBox(height: 18,),
                              Expanded(
                                child: Scrollbar(
                                  controller: _bookmarkScrollController,
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    controller: _bookmarkScrollController,
                                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    itemCount: _bookmarkData.length,
                                    itemBuilder: (context, index) {
                                      return Slidable(
                                        key: Key('$index'),
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) async {
                                                Get.dialog(
                                                    const AlertDialog(
                                                      contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                                                      actionsPadding: EdgeInsets.zero,
                                                      titlePadding: EdgeInsets.zero,
                                                      content: Row(
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(width: 24),
                                                          Text('장소 삭제 반영중'),
                                                        ],
                                                      ),
                                                    ),
                                                    barrierDismissible: false
                                                );
                                                bool result = await _userProvider.deletePlaceInBookmark(
                                                    bookmarkId, _bookmarkData[index]['id']);
                                                Get.back();
                                                if (result) {
                                                  _bookmarkData.clear();
                                                  page = 0;
                                                  addPlaceData();
                                                } else {
                                                  Get.dialog(
                                                    AlertDialog(
                                                      contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                                                      titlePadding: EdgeInsets.zero,
                                                      content: const Text("장소 삭제 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
                                                      actions: [
                                                        TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                              label: '삭제',
                                              backgroundColor: Colors.red,
                                              icon: Icons.delete,
                                            )
                                          ],
                                        ),
                                        child: RoundedRowBookmarkRectanglePlaceCard(
                                          imageUrl: _bookmarkData[index]['imgUrl'] != null ?
                                          ImageParser.parseImageUrl(_bookmarkData[index]['imgUrl']) :
                                          null,
                                          placeName: _bookmarkData[index]['name'],
                                          // placeType: _bookmarkData[index]['category'],
                                          placeType: '',
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 8,);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                              visible: loadVisibility,
                              child: AbsorbPointer(
                                absorbing: true,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(38),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: const CircularProgressIndicator(),
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    // SizedBox(height: 18,),
                    Container(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 18),
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('닫기')
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
    ).whenComplete(() {
      _bookmarkScrollController.dispose();
      _bookmarkScrollController = ScrollController();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      addPlaceData();
    });
  }

  void patchBookmark(dynamic bookmarkId, String type, String title) async {
    Get.dialog(
      const AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(32, 24, 32, 24),
        actionsPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 24),
            Text('북마크 이름 변경중'),
          ],
        ),
      ),
      barrierDismissible: false
    );

    bool result;
    if (type == 'place') {
      result = await _bookmarkController.patchPlaceBookmark(bookmarkId, title);
    } else {
      result = await _bookmarkController.patchCourseBookmark(bookmarkId, title);
    }
    Get.back();

    if (result) {
      if (type == 'place') {
        initPlaceBookmark();
      } else {
        initCourseBookmark();
      }
    } else {
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          titlePadding: EdgeInsets.zero,
          content: const Text("이름 변경 과정에서 오류가 발생했습니다. 다시 시도해주세요."),
          actions: [
            TextButton(onPressed: () {Get.back();}, child: const Text('확인'))
          ],
        ),
      );
    }
  }

  Widget _locationBookmarkSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
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
              _bookmarkNameController.text = '';
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
                                final String title = _bookmarkNameController.text.toString();
                                if (bookmarkTextFieldValidator(title) != null) return;
                                Navigator.of(context, rootNavigator: true).pop();
                                addPlaceBookmark(title);
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
              return Container(
                height: 288,
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
                controller: _placeScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
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
                    onTap: () {
                      print(_bookmarkController.placeBookmark.value![index]['title']);
                      _showPlaceBookmarkSheet(
                        _bookmarkController.placeBookmark.value![index]['title'],
                        _bookmarkController.placeBookmark.value![index]['placeBookmarkId']
                      );
                    },
                    onDelete: () {
                      deleteBookmark(
                        _bookmarkController.placeBookmark.value![index]['placeBookmarkId'],
                        'place',
                        _bookmarkController.placeBookmark.value![index]['title']
                      );
                    },
                    onRename: () {
                      _bookmarkNameController.text = _bookmarkController.placeBookmark.value![index]['title'];
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter dialogState) {
                                return AlertDialog(
                                  title: Text("북마크 이름 변경"),
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
                                        final String title = _bookmarkNameController.text.toString();
                                        if (bookmarkTextFieldValidator(title) != null) return;
                                        Navigator.of(context, rootNavigator: true).pop();
                                        if (_bookmarkController.placeBookmark.value![index]['title'] == title) return;
                                        patchBookmark(
                                            _bookmarkController.placeBookmark.value![index]['placeBookmarkId'],
                                            'place',
                                            title
                                        );
                                      },
                                      child: Text('변경', style: TextStyle(color: Colors.blue),),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                      );
                    },
                    placeImageUrls: _bookmarkController.placeBookmark.value![index]['thumbnailInfoList']
                        .map((item) => ImageParser.parseImageUrl(item['placeImgUrl'])).toList(),
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
              _bookmarkNameController.text = '';
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
                                final String title = _bookmarkNameController.text.toString();
                                if (bookmarkTextFieldValidator(title) != null) return;
                                Navigator.of(context, rootNavigator: true).pop();
                                addCourseBookmark(title);
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
              return Container(
                height: 288,
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
                controller: _courseScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
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
                    onTap: () {
                      print(_bookmarkController.courseBookmark.value![index]['title']);
                    },
                    onDelete: () {
                      deleteBookmark(
                          _bookmarkController.courseBookmark.value![index]['id'],
                          'course',
                          _bookmarkController.courseBookmark.value![index]['title']
                      );
                    },
                    onRename: () {
                      _bookmarkNameController.text = _bookmarkController.courseBookmark.value![index]['title'];
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter dialogState) {
                                return AlertDialog(
                                  title: Text("북마크 이름 변경"),
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
                                        final String title = _bookmarkNameController.text.toString();
                                        if (bookmarkTextFieldValidator(title) != null) return;
                                        Navigator.of(context, rootNavigator: true).pop();
                                        if (_bookmarkController.courseBookmark.value![index]['title'] == title) return;
                                        patchBookmark(
                                          _bookmarkController.courseBookmark.value![index]['id'],
                                          'course',
                                          title
                                        );
                                      },
                                      child: Text('변경', style: TextStyle(color: Colors.blue),),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                      );
                    },
                    placeImageUrls: [ImageParser.parseImageUrl(_bookmarkController.courseBookmark.value![index]['imgUrl'])],
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