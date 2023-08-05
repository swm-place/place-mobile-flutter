import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  Widget __searchSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          TagSearchBar(
            elevation: 2,
            borderRadius: 8,
            hintText: "장소/코스 검색",
            contentPadding: EdgeInsets.fromLTRB(18, 18, 18, 18),
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