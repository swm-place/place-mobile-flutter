import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/page/account/login.dart';
import 'package:place_mobile_flutter/page/preference/preference.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/state/user_controller.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/section/preference/preference_list.dart';
import 'package:place_mobile_flutter/widget/section/preference/preference_list_item.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {
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
            String? nickname = ProfileController.to.nickname.value;
            nickname ??= 'null';
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://source.unsplash.com/random'),
                  ),
                ),
                SizedBox(width: 24,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 12,),
                      Text(nickname!, style: PageTextStyle.headlineBold(Colors.black),),
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
        },
      )
    );
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
                  print("관심 키워드 설정");
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

  Widget _createAccountPref() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
          title: "계정",
          titleStyle: SectionTextStyle.sectionTitleSmall(Colors.black),
          content: GetBuilder<AuthController>(
            init: AuthController(),
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
                        print("비번 변경");
                      },
                    ),
                    PreferenceItem(
                      title: '프로필 변경',
                      textColor: Colors.black,
                      onTap: () {
                        print("프로필 변경");
                      },
                    ),
                    PreferenceItem(
                      title: '구글 연동',
                      textColor: Colors.black,
                      onTap: () {
                        AuthController.to.linkGoogle();
                      },
                    ),
                    PreferenceItem(
                      title: '구글 연동 해제',
                      textColor: Colors.black,
                      onTap: () {
                        AuthController.to.unLinkGoogle();
                      },
                    ),
                    PreferenceItem(
                      title: '로그아웃',
                      textColor: Colors.red,
                      showIcon: false,
                      onTap: () {
                        AuthController.to.signOut();
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
              _createStoryPref(),
              _createRecommendPref(),
              _createAccountPref(),
              const SizedBox(height: 24,),
              // GetBuilder<AuthController>(
              //   init: AuthController(),
              //   builder: (controller) {
              //     if (controller.user.value == null) {
              //       return FilledButton(child: Text("로그인"), onPressed: () => {
              //         Get.to(() => LoginPage())
              //       });
              //     } else {
              //       return FilledButton(child: Text("로그아웃"), onPressed: () => {
              //         controller.signOut()
              //       });
              //     }
              //   },
              // )
              // _createWatchPlace()
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Center(
  //         child: GetBuilder<AuthController>(
  //           init: AuthController(),
  //           builder: (controller) {
  //             if (controller.user.value == null) {
  //               return FilledButton(child: Text("로그인"), onPressed: () => {
  //                 Get.to(() => LoginPage())
  //               });
  //             } else {
  //               return FilledButton(child: Text("로그아웃"), onPressed: () => {
  //                 controller.signOut()
  //               });
  //             }
  //           },
  //         )
  //       ),
  //     ),
  //   );
  // }
}