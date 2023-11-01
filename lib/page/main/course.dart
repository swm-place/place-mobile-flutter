import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/page/course/course_main.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';
import 'package:place_mobile_flutter/widget/story/story_card.dart';

class CoursePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CoursePageState();
}

class CoursePageState extends State<CoursePage> with AutomaticKeepAliveClientMixin<CoursePage> {

  final Map<String, dynamic> _courseData = {
    'title': '코스 추천',
    'summary': '코스 설명',
    'courses': [
      {
        'background': "https://images.unsplash.com/photo-1495567720989-cebdbdd97913?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2370&q=80",
        'title': '감성여행',
        'message': '바쁜 일상에 지친 마음을 회복',
        'location': '대부도, 안산'
      },
      {
        'background': "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2560&q=80",
        'title': '피톤치드',
        'message': '도심에서는 느낄수 없는 맑은 공기',
        'location': '사려니 숲길, 제주도'
      },
      {
        'background': "https://images.unsplash.com/photo-1548115184-bc6544d06a58?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2370&q=80",
        'title': '전통',
        'message': '한국의 전통적인 아름다움',
        'location': '한옥마을, 전주'
      }
    ]
  };

  @override
  bool get wantKeepAlive => true;

  Widget _createMyCourseSection() {
    return MainSection(
      title: '나의 코스',
      content: SizedBox(
        height: 160,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: _courseData['courses'].length + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0 || index == _courseData['courses'].length + 1) {
              return const SizedBox(width: 16,);
            } else {
              index -= 1;
              return RoundedRectangleStoryCard(
                title: _courseData['courses'][index]['title'],
                message: _courseData['courses'][index]['message'],
                location: _courseData['courses'][index]['location'],
                imageUrl: _courseData['courses'][index]['background'],
                width: 250,
                height: 194,
                titleStyle: SectionTextStyle.lineContentExtraLarge(Colors.white),
                messageStyle: SectionTextStyle.labelMedium(Colors.white),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                onTap: () {
                  Get.to(() => CourseMainPage());
                },
              );
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: 8,);
          },
        ),
      )
    );
  }

  Widget _recentlyDiscoverCourseSection() {
    return MainSection(
      title: '최근 탐색한 코스',
      content: Text("sss")
    );
  }

  Widget _recentlyEditedCourseSection() {
    return MainSection(
      title: '최근 편집한 코스',
      content: Text("sss")
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: lightColorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24,),
              _createMyCourseSection(),
              SizedBox(height: 24,),
              _recentlyDiscoverCourseSection(),
              SizedBox(height: 24,),
              _recentlyEditedCourseSection(),
              SizedBox(height: 24,)
            ],
          ),
        ),
      ),
    );
  }
}