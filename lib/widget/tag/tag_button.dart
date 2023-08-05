import 'package:flutter/material.dart';

class RoundedRectangleTagButton extends StatefulWidget {
  RoundedRectangleTagButton({
    this.borderRadius=8.0,
    this.width=48.0,
    this.height=48.0,
    Key? key,
  }) : super(key: key);

  double borderRadius;
  double width;
  double height;

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
        color: Colors.blue
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.volume_mute,
              color: Colors.white,
              size: 32,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "조용한",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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