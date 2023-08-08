import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class RoundedRectangleStoryCard extends StatelessWidget {
  RoundedRectangleStoryCard({
    required this.title,
    required this.message,
    required this.location,
    required this.imageUrl,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  String title;
  String message;
  String location;
  String imageUrl;

  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    width ??= double.infinity;
    height ??= double.infinity;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () => {
          print("$title, $message, $location")
        },
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Image.network(imageUrl, fit: BoxFit.cover,),
            ),
            Container(
              width: width,
              height: height,
              color: const Color.fromARGB(102, 1, 1, 1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        location,
                        style: SectionTextStyle.labelMedium(Colors.white),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            title,
                            style: SectionTextStyle.sectionTitleSmall(Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                              message,
                              style: SectionTextStyle.sectionContentLarge(Colors.white)
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}