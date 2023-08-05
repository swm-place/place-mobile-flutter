import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class MainSection extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "title",
                  style: sectionTitle,
                ),
              ),
              SizedBox(height: 8,),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "content",
                  style: sectionContent,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}