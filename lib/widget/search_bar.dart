import 'package:flutter/material.dart';

class TagSearchBar extends StatefulWidget {
  TagSearchBar({
    this.width,
    this.height,
    this.elevation,
    Key? key,
  }) : super(key: key);

  double? width = 100.0;
  double? height = 48.0;
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
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.red,
        child: Padding(

        ),
      ),
    );
  }
}