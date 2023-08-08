import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/widget/search_bar.dart';

class BookmarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BookmarkPageState();
  }
}

class BookmarkPageState extends State<BookmarkPage> with AutomaticKeepAliveClientMixin<BookmarkPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
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
              ),

            ],
          ),
        )
      ),
    );
  }
}