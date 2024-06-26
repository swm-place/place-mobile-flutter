import 'package:flutter/material.dart';

class RoundedRectangleSearchBar extends StatefulWidget {
  final Function()? onSuffixIconPressed;

  RoundedRectangleSearchBar({
    this.elevation=4,
    this.borderRadius=8.0,
    this.fillColor=Colors.white,
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

  Color fillColor;

  @override
  State<StatefulWidget> createState() {
    return _RoundedRectangleSearchBarState();
  }
}

class _RoundedRectangleSearchBarState extends State<RoundedRectangleSearchBar> {
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
          fillColor: widget.fillColor,
          contentPadding: widget.contentPadding,
        ),
        controller: widget.textEditingController,
      ),
    );
  }
}