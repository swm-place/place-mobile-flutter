import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/page/account/login.dart';
import 'package:place_mobile_flutter/page/place/place_detail.dart';
import 'package:place_mobile_flutter/page/preference/preference.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/state/user_controller.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/async_dialog.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';
import 'package:place_mobile_flutter/widget/place/place_card.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/section/preference/preference_list.dart';
import 'package:place_mobile_flutter/widget/section/preference/preference_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

enum Sex {male, female}

class ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode phoneNumberFocusNode = FocusNode();

  PageController pageController = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();

  TextEditingController nicknameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  late final ScrollController _placeLogScrollController;

  bool checkNicknameDup = false;

  String? nicknameError;
  String? nicknameHelper;
  String? phoneNumberError;
  String? birthError;

  DateTime? selectedBirth;

  Sex selectedSex = Sex.male;

  final UserProvider userProvider = UserProvider();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _placeLogScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _placeLogScrollController.dispose();
    super.dispose();
  }

  Widget _createProfileSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) {
          if (controller.user.value == null) {
            return GestureDetector(
              onTap: () {
                Get.to(() => LoginPage());
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('로그인 하기', style: PageTextStyle.headlineBold(Colors.black),),
                  Icon(Icons.keyboard_arrow_right, size: 36,)
                ],
              ),
            );
          } else {
            return Obx(() {
              String? nickname = ProfileController.to.nickname.value;
              nickname ??= 'null';
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar_male.png'),
                      ),
                      // child: CircleAvatar( //TODO: avatar network image
                      //   backgroundImage: NetworkImage(
                      //       'https://source.unsplash.com/random'),
                      // ),
                    ),
                    SizedBox(width: 24,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: 12,),
                            Text(nickname, style: PageTextStyle.headlineBold(
                                Colors.black),),
                            // SizedBox(height: 6,),
                            // Row(
                            //   children: [
                            //     Text("팔로워 20", style: SectionTextStyle.labelMedium(Colors.black),),
                            //     SizedBox(width: 12,),
                            //     Text("팔로잉 20", style: SectionTextStyle.labelMedium(Colors.black),),
                            //   ],
                            // )
                          ],
                        )
                    )
                  ],
                );
              }
            );
          }
        },
      )
    );
  }



  void _createTagPrefSheet() async {
    List<dynamic> _categoryCandidates = [];
    Map<String, dynamic> _refinedCategory = {};
    int _countTagBestRating = 0;
    bool loadVisibility = true;

    StateSetter? state;

    void getPreferenceData() async {
      state!(() {
        setState(() {
          loadVisibility = true;
        });
      });

      List<dynamic>? result = await userProvider.getUserTagPreferences();

      if (result != null) {
        _categoryCandidates = result;
      }

      state!(() {
        setState(() {
          loadVisibility = false;
        });
      });
    }

    void putTagData(List<dynamic> data, int i) async {
      if (data[i]['rating'] == 1 && _countTagBestRating == 5) {
        Get.showSnackbar(
            WarnGetSnackBar(
              title: '선호도 설정 불가',
              message: '최고 선호도 태그는 최대 5개만 설정할 수 있습니다.',
              showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
            )
        );
        return;
      }

      state!(() {
        setState(() {
          loadVisibility = true;
        });
      });

      data[i]['rating']++;
      if (data[i]['rating'] > 2) data[i]['rating'] = 0;

      List<dynamic> putData = [];
      for (var k in _refinedCategory.keys) {
        if (k == data[i]['group_large']) continue;
        putData.addAll(_refinedCategory[k]);
      }
      putData.addAll(data);

      bool result = await userProvider.putUserTagPreferences(putData);

      if (result) {
        if (data[i]['rating'] == 2) _countTagBestRating++;
        if (data[i]['rating'] == 0) _countTagBestRating--;
        state!(() {
          setState(() {
            loadVisibility = false;
          });
        });
      } else {
        data[i]['rating']--;
        if (data[i]['rating'] < 0) data[i]['rating'] = 2;
        state!(() {
          setState(() {
            loadVisibility = false;
          });
        });
      }
    }

    Widget _createChipSection(StateSetter bottomState, List<dynamic> data, String categoryName) {
      List<Widget> chips = [];
      for (int i = 0;i < data.length;i++) {
        // int rating = data[i]['rating'];
        chips.add(
            TagPreferenceChip(
              label: Text(data[i]['hashtag'], style: const TextStyle(color: Colors.black),),
              priority: data[i]['rating'],
              onTap: () {
                putTagData(data, i);
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
      _countTagBestRating = 0;
      for (int i = 0;i < _categoryCandidates.length;i++) {
        String? group_large = _categoryCandidates[i]['group_large'];
        if (group_large == null) {
          if (!data.containsKey(_categoryCandidates[i]['hashtag'])) {
            data[_categoryCandidates[i]['hashtag']] = [];
          }
          continue;
        }
        // if (_categoryCandidates[i]['rating'] > 0) _selectedCategory.add(_categoryCandidates[i]);
        if (_categoryCandidates[i]['rating'] == 2) _countTagBestRating++;
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
      _refinedCategory = data;
      print(_refinedCategory);

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
        section.add(_createChipSection(bottomState, data[k], k));
        section.add(const SizedBox(height: 24,));
      }
      return section;
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter bottomState) {
              state = bottomState;
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
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: _createTagPreferenceSection(bottomState),
                            ),
                          ),
                          Visibility(
                            visible: loadVisibility,
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
                        ],
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPreferenceData();
    });
  }

  Widget _createRecommendPref() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
          title: "콘텐츠 추천",
          titleStyle: SectionTextStyle.sectionTitleSmall(Colors.black),
          content: PreferenceListSection(
            children: [
              PreferenceItem(
                title: '관심 키워드 설정',
                textColor: Colors.black,
                onTap: () {
                  _createTagPrefSheet();
                },
              ),
            ],
          )
      ),
    );
  }

  Widget _createStoryPref() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
          title: "스토리",
          titleStyle: SectionTextStyle.sectionTitleSmall(Colors.black),
          content: PreferenceListSection(
            children: [
              PreferenceItem(
                title: '최근 팀색한 스토리',
                textColor: Colors.black,
                onTap: () {
                  print("최근 팀색한 스토리");
                },
              ),
            ],
          )
      ),
    );
  }

  Future<bool> checkNickname(String prevNickName, String nickname, StateSetter bottomState) async {
    if (prevNickName != '' && prevNickName == nickname) {
      checkNicknameDup = true;
      bottomState(() {
        nicknameError = null;
        nicknameHelper = '사용 가능한 닉네임입니다!';
      });
      return true;
    }
    bottomState(() {
      nicknameHelper = null;
      nicknameError = nicknameTextFieldValidator(nickname);
    });
    if (nicknameError == null) {
      int? result = await userProvider.checkNickname(nickname);
      if (result == 200) {
        checkNicknameDup = true;
        bottomState(() {
          nicknameError = null;
          nicknameHelper = '사용 가능한 닉네임입니다!';
        });
        return true;
      } else if (result == 409) {
        checkNicknameDup = false;
        bottomState(() {
          nicknameError = "이미 사용중인 닉네임입니다.";
        });
        return false;
      } else {
        print(result);
        bottomState(() {
          nicknameError = "다시 시도해주세요.";
        });
        return false;
      }
    }
    return false;
  }

  void _changeProfileData(String prevNickName, StateSetter bottomState) async {
    final nickname = nicknameController.text.tr;
    final phoneNumber = phoneNumberController.text.tr;
    final sex = selectedSex;
    final birth = birthController.text.tr;

    if (_formKey.currentState!.validate() && await checkNickname(prevNickName, nickname, bottomState)) {
      bool result = await ProfileController.to.changeUserProfile(nickname, phoneNumber, birth.replaceAll('/', '-') + "T00:00:00.000Z", sex.index);
      if (result == true) {
        Navigator.pop(context);
        Get.showSnackbar(
            SuccessGetSnackBar(
                title: "프로필 변경 완료",
                message: "프로필 정보가 성공적으로 변경되었습니다"
            )
        );
      } else {
        Get.showSnackbar(
            ErrorGetSnackBar(
              title: "프로필 변경 실패",
              message: "프로필 정보 변경 과정에서 오류가 발생했습니다"
            )
        );
      }
    }
  }

  Widget _createAccountPref() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
          title: "계정",
          titleStyle: SectionTextStyle.sectionTitleSmall(Colors.black),
          content: GetX<AuthController>(
            builder: (controller) {
              if (controller.user.value == null) {
                return PreferenceListSection(
                  children: [
                    PreferenceItem(
                      title: '로그인',
                      textColor: Colors.black,
                      onTap: () {
                        Get.to(() => LoginPage());
                      },
                    ),
                  ],
                );
              } else {
                return PreferenceListSection(
                  children: [
                    PreferenceItem(
                      title: '비밀번호 변경',
                      textColor: Colors.black,
                      onTap: () {
                        controller.resetPassword(controller.user.value!.email!);
                      },
                    ),
                    PreferenceItem(
                      title: '프로필 설정',
                      textColor: Colors.black,
                      onTap: () {
                        pageController = PageController();
                        emailController = TextEditingController();
                        passwordController = TextEditingController();
                        passwordCheckController = TextEditingController();

                        nicknameController = TextEditingController();
                        phoneNumberController = TextEditingController();
                        birthController = TextEditingController();

                        String prevNickName = '';
                        if (ProfileController.to.nickname.value != null) {
                          nicknameController.text = ProfileController.to.nickname.value!;
                          prevNickName = ProfileController.to.nickname.value!;
                        }

                        if (ProfileController.to.phoneNumber.value != null) {
                          phoneNumberController.text = ProfileController.to.phoneNumber.value!;
                        }

                        DateTime birth = DateTime.now();
                        if (ProfileController.to.birthday.value != null) {
                          birth = DateTime.parse(ProfileController.to.birthday.value!);
                          birthController.text = DateFormat('yyyy/MM/dd').format(birth);
                        }

                        checkNicknameDup = false;

                        nicknameError = null;
                        nicknameHelper = null;
                        phoneNumberError = null;
                        birthError = null;

                        selectedBirth = null;

                        if (ProfileController.to.gender.value != null) {
                          selectedSex = Sex.values[ProfileController.to.gender.value!];
                        } else {
                          selectedSex = Sex.male;
                        }

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
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text('프로필 설정', style: SectionTextStyle.sectionTitle(),),
                                                ),
                                                // const SizedBox(height: 8,),
                                                // SizedBox(
                                                //   width: double.infinity,
                                                //   child: Text('프로필 정보를 변경할 수 있습니다.', style: SectionTextStyle.sectionContent(Colors.grey[500]!),),
                                                // ),
                                                const SizedBox(height: 24,),
                                                Form(
                                                  autovalidateMode: AutovalidateMode.always,
                                                  key: _formKey,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width: double.infinity,
                                                              child: Text("닉네임 *"),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  child: TextFormField(
                                                                    decoration: InputDecoration(
                                                                        hintText: "닉네임",
                                                                        hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                                                                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                                                        errorText: nicknameError,
                                                                        helperText: nicknameHelper
                                                                    ),
                                                                    textInputAction: TextInputAction.next,
                                                                    controller: nicknameController,
                                                                    style: PageTextStyle.headlineSmall(Colors.black),
                                                                    validator: nicknameTextFieldValidator,
                                                                    onFieldSubmitted: (String value) {
                                                                      FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                                                                    },
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed: () async {
                                                                      await checkNickname(prevNickName, nicknameController.text.tr, bottomState);
                                                                    },
                                                                    child: Text("중복확인")
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 24,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Text("전화번호 *"),
                                                      ),
                                                      TextFormField(
                                                        focusNode: phoneNumberFocusNode,
                                                        decoration: InputDecoration(
                                                          hintText: "01012341234",
                                                          hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                                                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                                          errorText: phoneNumberError,
                                                        ),
                                                        textInputAction: TextInputAction.done,
                                                        controller: phoneNumberController,
                                                        style: PageTextStyle.headlineSmall(Colors.black),
                                                        validator: phoneNumberTextFieldValidator,
                                                      ),
                                                      SizedBox(
                                                        height: 24,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Text("성별 *"),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: SegmentedButton<Sex>(
                                                          segments: [
                                                            ButtonSegment<Sex>(
                                                                value: Sex.male,
                                                                label: Text("남성"),
                                                                icon: Icon(Icons.male)
                                                            ),
                                                            ButtonSegment<Sex>(
                                                                value: Sex.female,
                                                                label: Text("여성"),
                                                                icon: Icon(Icons.female)
                                                            ),
                                                          ],
                                                          selected: <Sex>{selectedSex},
                                                          onSelectionChanged: (newValue) {
                                                            bottomState(() {
                                                              selectedSex = newValue.first;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 24,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Text("생년월일 *"),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          selectedBirth = await showDatePicker(
                                                              locale: Locale('ko', 'KR'),
                                                              context: context,
                                                              initialDate: birth,
                                                              firstDate: DateTime(1900),
                                                              lastDate: DateTime.now()
                                                          );
                                                          if (selectedBirth != null) {
                                                            birthController.text = DateFormat('yyyy/MM/dd').format(selectedBirth!);
                                                          }
                                                        },
                                                        child: TextFormField(
                                                          enabled: false,
                                                          decoration: InputDecoration(
                                                              hintText: "yyyy/mm/dd",
                                                              hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                                              errorText: birthError
                                                          ),
                                                          controller: birthController,
                                                          style: PageTextStyle.headlineSmall(Colors.black),
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return "생년월일을 선택해주세요";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: 24,),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                                          width: double.infinity,
                                          child: FilledButton(
                                              onPressed: () {
                                                _changeProfileData(prevNickName, bottomState);
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
                    ),
                    PreferenceItem(
                      title: controller.providerId.contains('google.com') ? '구글 연결 해제' : '구글 연결',
                      textColor: Colors.black,
                      onTap: () {
                        if (controller.providerId.contains('google.com')) {
                          controller.unLinkGoogle();
                        } else {
                          controller.linkGoogle();
                        }
                      },
                    ),
                    PreferenceItem(
                      title: controller.providerId.contains('apple.com') ? '애플 연결 해제' : '애플 연결',
                      textColor: Colors.black,
                      onTap: () {
                        if (controller.providerId.contains('apple.com')) {
                          controller.unLinkApple();
                        } else {
                          controller.linkApple();
                        }
                      },
                    ),
                    PreferenceItem(
                      title: '로그아웃',
                      textColor: Colors.red,
                      showIcon: false,
                      onTap: () {
                        controller.signOut();
                      },
                    ),
                  ],
                );
              }
            },
          )
      ),
    );
  }

  void _showPlaceLogSheet() {
    bool stateFirst = true;
    bool loadVisibility = false;

    int page = 0;
    int size = 25;

    StateSetter? state;

    List<dynamic> _placeLogData = [];

    void addPlaceLogData() async {
      state!(() {
        setState(() {
          loadVisibility = true;
        });
      });

      List<dynamic>? result = await userProvider.getLogPlace(page, size);

      if (result != null) {
        _placeLogData.addAll(result);
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
                _placeLogScrollController.addListener(() {
                  if (_placeLogScrollController.position.maxScrollExtent == _placeLogScrollController.offset && !loadVisibility) {
                    stateFirst = false;
                    addPlaceLogData();
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
                                  child: Text('장소 탐색 기록', style: SectionTextStyle.sectionTitle(),)
                              ),
                              SizedBox(height: 18,),
                              Expanded(
                                child: Scrollbar(
                                  controller: _placeLogScrollController,
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    controller: _placeLogScrollController,
                                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    itemCount: _placeLogData.length,
                                    itemBuilder: (context, index) {
                                      String? imgUrl;
                                      if (_placeLogData[index]['place']['photos'] != null && _placeLogData[index]['place']['photos'].length > 0) {
                                        imgUrl = ImageParser.parseImageUrl(_placeLogData[index]['place']['photos'][0]['url']);
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => PlaceDetailPage(placeId: _placeLogData[index]['place_id']));
                                        },
                                        child: RoundedRowBookmarkRectanglePlaceCard(
                                          imageUrl: imgUrl,
                                          placeName: _placeLogData[index]['place']['name'],
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
      _placeLogScrollController.dispose();
      _placeLogScrollController = ScrollController();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      addPlaceLogData();
    });
  }

  Widget _createWatchPref() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: MainSection(
        title: '장소',
        titleStyle: SectionTextStyle.sectionTitleSmall(Colors.black),
        content: PreferenceListSection(
          children: [
            PreferenceItem(
              title: '최근 탐색한 장소',
              textColor: Colors.black,
              onTap: () {
                _showPlaceLogSheet();
              },
            ),
            PreferenceItem(
              title: '장소 추가 요청',
              textColor: Colors.black,
              onTap: () {
                String content = '장소 이름:\n장소 주소(지번/도로명):\n상세 주소(ex 가나다 건물 2층):\n전화번호:\n운영 시간:';
                final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'our.email@gmail.com',
                    query: 'subject=[장소추가] 장소추가 요청 정보&body=오류 내용: $content'
                );
                launchUrl(emailLaunchUri);
              },
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
        // title: Text('프로필', style: PageTextStyle.headlineExtraLarge(Colors.black),),
        // centerTitle: false,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Get.to(() => PreferencePage());
        //     },
        //     icon: const Icon(Icons.settings),
        //   )
        // ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12,),
              _createProfileSection(),
              _createWatchPref(),
              // _createStoryPref(),
              _createRecommendPref(),
              _createAccountPref(),
              const SizedBox(height: 24,),
            ],
          ),
        ),
      ),
    );
  }
}