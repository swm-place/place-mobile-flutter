import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';

class BookmarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BookmarkPageState();
  }
}

class BookmarkPageState extends State<BookmarkPage> with AutomaticKeepAliveClientMixin<BookmarkPage> {
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

  Widget _myStorySection() => Padding(
    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
    child: MainSection(
      title: "내 스토리",
      content: Text("test"),
      action: Ink(
        child: InkWell(
          onTap: () {

          },
          child: Text(
            "전체보기",
            style: SectionTextStyle.labelMedium(Colors.blue),
          ),
        ),
      ),
    ),
  );

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