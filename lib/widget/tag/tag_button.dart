import 'package:flutter/material.dart';

class RoundedRectangleTagButton extends StatefulWidget {
  RoundedRectangleTagButton({
    this.borderRadius=8.0,
    this.width=48.0,
    this.height=48.0,
    this.itemColor,
    this.backgroundColor,

    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  double borderRadius;
  double width;
  double height;

  IconData icon;

  Color? itemColor;
  Color? backgroundColor;

  String text;

  @override
  State<StatefulWidget> createState() {
    return _RoundedRectangleTagButtonState();
  }
}

class _RoundedRectangleTagButtonState extends State<RoundedRectangleTagButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.backgroundColor
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.itemColor,
              size: 32,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                widget.text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: widget.itemColor,
                ),
              ),
            )
          ],
        ),
        onTap: () {
          print("tag clicked");
        },
      ),
    );
  }
}