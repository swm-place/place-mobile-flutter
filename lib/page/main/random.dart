import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_search_bar.dart';

class RandomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomPageState();
  }
}

class RandomPageState extends State<RandomPage> with AutomaticKeepAliveClientMixin<RandomPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 24, 12),
              child: TagSearchBar(
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: GridView.custom(
                  // physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  gridDelegate: SliverQuiltedGridDelegate(
                      mainAxisSpacing: 6,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                      crossAxisSpacing: 6,
                      crossAxisCount: 5,
                      pattern: [
                        QuiltedGridTile(2, 2),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 2),
                        QuiltedGridTile(1, 3),
                        QuiltedGridTile(2, 1),
                        QuiltedGridTile(1, 2),
                        QuiltedGridTile(2, 2),
                        QuiltedGridTile(1, 2),
                      ]
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(((context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network("https://source.unsplash.com/random?sig=$index", fit: BoxFit.cover,),
                    );
                  })),
                ),
              )
            )
          ],
        )
      ),
    );
  }
}