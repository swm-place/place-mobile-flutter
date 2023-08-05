import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class MainSection extends StatelessWidget {
  MainSection({
    required this.title,
    required this.message,
    Key? key,
  }) : super(key: key);

  String title;
  String? message;

  List<Widget> __createHead() {
    List<Widget> colList = [];
    colList.add(
      SizedBox(
        width: double.infinity,
        child: Text(
          title,
          style: sectionTitle,
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
              style: sectionContent,
            ),
          )
      );
    }
    return colList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: __createHead(),
          ),
        )
      ],
    );
  }
}