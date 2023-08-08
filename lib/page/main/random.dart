import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/widget/tag/tag_search_bar.dart';

class RandomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomPageState();
  }
}

class RandomPageState extends State<RandomPage> with AutomaticKeepAliveClientMixin<RandomPage> {
  @override
  bool get wantKeepAlive => true;

  List<Widget> _createSection() {
    List<Widget> sections = [];
    sections.add(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: TagSearchBar(
          elevation: 2,
          borderRadius: 8,
          hintText: "검색어",
          contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          onSuffixIconPressed: () {
            print("searchbar clicked");
          },
        ),
      )
    );
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
          child: Column(
            children: _createSection()
          ),
        ),
      ),
    );
  }
}