import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/section/preference/preference_list.dart';
import 'package:place_mobile_flutter/widget/section/preference/preference_list_item.dart';

class PreferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {


  Widget _createRecommendPref() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
          title: "콘텐츠 추천",
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

  Widget _createAccountPref() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
          title: "계정",
          content: PreferenceListSection(
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
                title: '로그아웃',
                textColor: Colors.red,
                showIcon: false,
                onTap: () {
                  print("로그아웃");
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
      appBar: AppBar(
        title: Text('설정'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _createRecommendPref(),
              _createAccountPref()
            ],
          ),
        ),
      ),
    );
  }
}