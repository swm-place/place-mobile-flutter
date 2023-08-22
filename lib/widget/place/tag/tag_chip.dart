import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  Widget _createItems() {
    if (widget.prefixIcon != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.prefixIcon!,
          const SizedBox(width: 4,),
          widget.label
        ],
      );
    }
    return widget.label;
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
            color: widget.selection ? Colors.black.withOpacity(0.4) : Colors.transparent
          ),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _createItems(),
              widget.selection ? Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Icon(MdiIcons.close, size: 18,),
              ) : const SizedBox(width: 0,)
            ],
          ),
        ),
      ),
    );
  }
}
