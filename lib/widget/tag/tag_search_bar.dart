import 'package:flutter/material.dart';

class TagSearchBar extends StatefulWidget {
  final Function()? onSuffixIconPressed;

  TagSearchBar({
    this.elevation=4,
    this.borderRadius=8.0,
    this.hintText,
    this.contentPadding,
    this.textEditingController,
    this.onSuffixIconPressed,
    Key? key,
  }) : super(key: key);

  double elevation;
  double borderRadius;

  String? hintText;

  EdgeInsets? contentPadding;

  TextEditingController? textEditingController;

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
            onPressed: widget.onSuffixIconPressed,
            icon: const Icon(Icons.search),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: widget.contentPadding,
        ),
        controller: widget.textEditingController,
      ),
    );
  }
}