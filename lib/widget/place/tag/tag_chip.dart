import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
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
  final Function()? onTap;

  TagPreferenceChip({
    required this.label,
    required this.onTap,
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
        onTap: widget.onTap,
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

class TagSelectionChip extends StatefulWidget {
  final Function()? onTap;

  TagSelectionChip({
    required this.label,
    required this.onTap,
    this.prefixIcon,
    this.selection=false,
    this.borderColor=Colors.black,
    super.key
  });

  Text label;
  Icon? prefixIcon;

  bool selection;

  Color borderColor;

  @override
  State<StatefulWidget> createState() => _TagSelectionChipState();
}

class _TagSelectionChipState extends State<TagSelectionChip> {

  List<Widget> _createItems() {
    List<Widget> items = [];

    if (widget.prefixIcon != null) {
      items.addAll([
        widget.prefixIcon!,
        const SizedBox(width: 8,)
      ]);
    }

    items.add(widget.label);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: widget.onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(80)),
            border: Border.all(
              color: widget.borderColor
            ),
            color: widget.selection ? Colors.black.withOpacity(0.45) : Colors.transparent
          ),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _createItems(),
          ),
        ),
      ),
    );
  }
}
