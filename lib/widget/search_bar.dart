import 'package:flutter/material.dart';

class TagSearchBar extends StatefulWidget {
  TagSearchBar({
    // this.width,
    // this.height,
    this.elevation = 4,
    this.borderRadius = 8.0,
    Key? key,
  }) : super(key: key);

  // double? width = 100.0;
  // double? height = 48.0;
  double elevation = 4;
  double borderRadius = 8.0;

  @override
  State<StatefulWidget> createState() {
    return _TagSearchBarState();
  }
}

class _TagSearchBarState extends State<TagSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
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