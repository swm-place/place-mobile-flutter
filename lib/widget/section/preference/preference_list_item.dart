import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class PreferenceItem extends StatefulWidget {
  final Function() onTap;

  PreferenceItem({
    required this.title,
    required this.onTap,
    this.textColor=Colors.black,
    this.showIcon=true,
    Key? key,
  }) : super(key: key);

  String title;
  Color textColor;
  bool showIcon;

  bool isClick = false;

  @override
  State<StatefulWidget> createState() => _PreferenceItemState();
}

class _PreferenceItemState extends State<PreferenceItem> {
  Color backgroundColor = Colors.grey[200]!;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.grey[200]
        ),
        child: InkWell(
          onTap: widget.onTap,
          highlightColor: Colors.grey[400],
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: SectionTextStyle.sectionContent(widget.textColor),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: widget.showIcon ? const Icon(Icons.keyboard_arrow_right) : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}