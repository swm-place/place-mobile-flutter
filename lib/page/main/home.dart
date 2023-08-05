import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/widget/tag/tag_button.dart';
import 'package:place_mobile_flutter/widget/tag/tag_search_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  final GlobalKey _tagSection = GlobalKey();

  final List<Widget> tags = [];

  @override
  bool get wantKeepAlive => true;

  void __createTagSection() {
    final RenderBox tagRow = _tagSection.currentContext!.findRenderObject() as RenderBox;
    final double tagCount = tagRow.size.width / 75;
    for (int i = 0;i < tagCount;i++) {
      tags.add(
        RoundedRectangleTagButton(
          width: 60,
          height: 60,
        )
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        __createTagSection();
      });
    });
    super.initState();
  }

  Widget __searchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          TagSearchBar(
            elevation: 2,
            borderRadius: 8,
            hintText: "장소/코스 검색",
            contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            onSuffixIconPressed: () {
              print("searchbar clicked");
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
            child: Container(
              key: _tagSection,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: tags,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              __searchSection()
            ],
          ),
        ),
      ),
    );
  }
}