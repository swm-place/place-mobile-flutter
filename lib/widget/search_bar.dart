import 'package:flutter/material.dart';

class TagSearchBar extends StatefulWidget {
  TagSearchBar({
    // this.width,
    // this.height,
    this.elevation,
    Key? key,
  }) : super(key: key);

  // double? width = 100.0;
  // double? height = 48.0;
  double? elevation = 4;

  @override
  State<StatefulWidget> createState() {
    return _TagSearchBarState();
  }
}

class _TagSearchBarState extends State<TagSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none
          ),
          hintText: "장소/코스 검색",
          suffixIcon: IconButton(
            onPressed: () {
              print("search clicked");
            },
            icon: Icon(Icons.search),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}