import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class MainSection extends StatelessWidget {
  MainSection({
    required this.title,
    required this.content,

    this.message,
    this.action,
    this.titleStyle,
    Key? key,
  }) : super(key: key);

  String title;
  String? message;

  Widget content;
  Widget? action;

  TextStyle? titleStyle;

  Widget __createHead() {
    List<Widget> colList = [];
    titleStyle ??= SectionTextStyle.sectionTitle();

    colList.add(
      SizedBox(
        width: double.infinity,
        child: Text(
          title,
          style: titleStyle,
        ),
      )
    );

    if (message != null) {
      colList.add(const SizedBox(height: 8,));
      colList.add(
          SizedBox(
            width: double.infinity,
            child: Text(
              message!,
              style: SectionTextStyle.sectionContent(Colors.grey[500]!),
            ),
          )
      );
    }
    if (action != null) {
      return Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Column(children: colList,)),
          action!
        ],
      );
    } else {
      return Column(children: colList,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: __createHead(),
        ),
        const SizedBox(height: 10,),
        content
      ],
    );
  }
}