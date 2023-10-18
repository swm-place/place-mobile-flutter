import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/page/account/login.dart';
import 'package:place_mobile_flutter/page/preference/preference.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/state/user_controller.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/async_dialog.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/section/preference/preference_list.dart';
import 'package:place_mobile_flutter/widget/section/preference/preference_list_item.dart';

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

  bool checkNicknameDup = false;

  String? nicknameError;
  String? nicknameHelper;
  String? phoneNumberError;
  String? birthError;

  DateTime? selectedBirth;

  Sex selectedSex = Sex.male;

  final UserProvider userProvider = UserProvider();

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

  int _countTagBestRating = 0;

  @override
  bool get wantKeepAlive => true;

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
                        backgroundImage: NetworkImage(
                            'https://source.unsplash.com/random'),
                      ),
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

  Widget _createChipSection(StateSetter bottomState, List<Map<String, dynamic>> data, String categoryName) {
    List<Widget> chips = [];
    for (int i = 0;i < data.length;i++) {
      // int rating = data[i]['rating'];
      chips.add(
        TagPreferenceChip(
          label: Text(data[i]['tag'], style: const TextStyle(color: Colors.black),),
          priority: data[i]['rating'],
          onTap: () {
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
            if (data[i]['rating'] == 1) _countTagBestRating++;
            if (data[i]['rating'] == 2) _countTagBestRating--;
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
    _countTagBestRating = 0;
    for (int i = 0;i < _categoryCandidates.length;i++) {
      // print(_categoryCandidates[i]);
      String? group_large = _categoryCandidates[i]['group_large'];
      if (group_large == null) {
        if (!data.containsKey(group_large)) {
          data[_categoryCandidates[i]['tag']] = [];
          continue;
        }
      }
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
      section.add(_createChipSection(bottomState, List<Map<String, dynamic>>.from(data[k]), k));
      section.add(const SizedBox(height: 24,));
    }
    return section;
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

  Future<bool> checkNickname(String nickname) async {
    setState(() {
      nicknameHelper = null;
      nicknameError = nicknameTextFieldValidator(nickname);
    });
    if (nicknameError == null) {
      int? result = await userProvider.checkNickname(nickname);
      if (result == 200) {
        checkNicknameDup = true;
        setState(() {
          nicknameError = null;
          nicknameHelper = '사용 가능한 닉네임입니다!';
        });
        return true;
      } else if (result == 409) {
        checkNicknameDup = false;
        setState(() {
          nicknameError = "이미 사용중인 닉네임입니다.";
        });
        return false;
      } else {
        print(result);
        setState(() {
          nicknameError = "다시 시도해주세요.";
        });
        return false;
      }
    }
    return false;
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

                        if (ProfileController.to.nickname.value != null) {
                          nicknameController.text = ProfileController.to.nickname.value!;
                        }

                        if (ProfileController.to.phoneNumber.value != null) {
                          phoneNumberController.text = ProfileController.to.phoneNumber.value!;
                        }

                        DateTime? birth;
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
                                                                      await checkNickname(nicknameController.text.tr);
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
                                                            setState(() {
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
                                                              initialDate: DateTime.now(),
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

  Widget _createWatchPref() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
        title: '장소',
        titleStyle: SectionTextStyle.sectionTitleSmall(Colors.black),
        content: PreferenceListSection(
          children: [
            PreferenceItem(
              title: '최근 탐색한 장소',
              textColor: Colors.black,
              onTap: () {
                print('최근 탐색한 장소');
              },
            ),
            PreferenceItem(
              title: '장소 추가 요청',
              textColor: Colors.black,
              onTap: () {
                print('장소 추가 요청');
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
              const SizedBox(height: 24,),
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