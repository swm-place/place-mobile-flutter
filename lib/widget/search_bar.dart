import 'package:flutter/material.dart';

class TagSearchBar extends StatefulWidget {
  TagSearchBar({
    this.elevation=4,
    this.borderRadius=8.0,
    this.hintText,
    Key? key,
  }) : super(key: key);

  double elevation;
  double borderRadius;

  String? hintText;

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
          hintText: widget.hintText,
          suffixIcon: IconButton(
            onPressed: () {
              print("search clicked");
            },
            icon: const Icon(Icons.search),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}