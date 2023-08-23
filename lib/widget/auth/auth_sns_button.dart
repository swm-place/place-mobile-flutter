import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class AuthButton extends StatefulWidget {
  final Function() onTap;

  AuthButton({
    required this.title,
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  String title;

  Color textColor;
  Color backgroundColor;

  Icon icon;

  @override
  State<StatefulWidget> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
            color: widget.backgroundColor
        ),
        child: InkWell(
          onTap: widget.onTap,
          highlightColor: Colors.grey[400],
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: widget.icon,
                ),
                const SizedBox(width: 24,),
                Text(
                  widget.title,
                  style: SectionTextStyle.sectionContent(widget.textColor),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}