import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class TagChip extends StatelessWidget {
  TagChip({
    required this.text,
    this.backgroundColor=Colors.red,
    this.textStyle,
    this.padding=const EdgeInsets.fromLTRB(6, 4, 6, 4),
    Key? key,
  }) : super(key: key);

  String text;
  Color backgroundColor;
  TextStyle? textStyle;
  EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    textStyle ??= SectionTextStyle.labelSmall(Colors.white);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor
      ),
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}

class TagPreferenceChip extends StatefulWidget {
  TagPreferenceChip({
    required this.label,
    required this.priority,
    super.key
  });

  Text label;

  int priority;

  @override
  State<StatefulWidget> createState() => _TagPreferenceChipState();
}

class _TagPreferenceChipState extends State<TagPreferenceChip> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () {
          print('chip clicked');
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(80)),
            border: Border.all(
              color: Colors.black
            ),
            color: Colors.black.withOpacity(widget.priority * 0.15)
          ),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: widget.label,
        ),
      ),
    );
  }
}
