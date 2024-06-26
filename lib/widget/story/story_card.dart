import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/cache_image.dart';

class RoundedRectangleMagazineCard extends StatelessWidget {
  final Function()? onTap;

  RoundedRectangleMagazineCard({
    required this.title,
    required this.message,
    this.location='',
    this.imageUrl,
    required this.onTap,
    this.padding=const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.width,
    this.height,
    this.titleStyle,
    this.messageStyle,
    this.locationStyle,
    Key? key,
  }) : super(key: key);

  String title;
  String message;
  String location;
  String? imageUrl;

  double? width;
  double? height;

  TextStyle? titleStyle;
  TextStyle? messageStyle;
  TextStyle? locationStyle;

  EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    width ??= double.infinity;
    height ??= double.infinity;
    titleStyle ??= SectionTextStyle.sectionTitleSmall(Colors.white);
    messageStyle ??= SectionTextStyle.sectionContentLarge(Colors.white);
    locationStyle ??= SectionTextStyle.labelMedium(Colors.white);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: imageUrl != null ?
                // Image.network(imageUrl!, fit: BoxFit.cover,) :
                NetworkCacheImage(imageUrl!, fit: BoxFit.cover,) :
                Image.asset('assets/images/empty.png', fit: BoxFit.fitHeight,),
            ),
            Container(
              width: width,
              height: height,
              color: const Color.fromARGB(102, 1, 1, 1),
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        location,
                        style: locationStyle,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            title,
                            style: titleStyle,
                          ),
                        ),
                        const SizedBox(height: 4,),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                              message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: messageStyle
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

class RoundedRectangleCourseCard extends StatelessWidget {
  final Function()? onTap;

  RoundedRectangleCourseCard({
    required this.title,
    required this.location,
    required this.imageUrls,
    required this.onTap,
    this.padding=const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.width,
    this.height,
    this.titleStyle,
    this.locationStyle,
    Key? key,
  }) : super(key: key);

  String title;
  String location;
  List<String> imageUrls;

  double? width;
  double? height;

  TextStyle? titleStyle;
  TextStyle? locationStyle;

  EdgeInsets padding;

  List<Widget> _generateImages() {
    List<Widget> images = [];
    int length = imageUrls.length;
    if (length > 5) length = 5;
    for (int i = 0;i < length;i++) {
      images.add(Expanded(child:
        NetworkCacheImage(
          imageUrls[i],
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        )
      ));
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    width ??= double.infinity;
    height ??= double.infinity;
    titleStyle ??= SectionTextStyle.sectionTitleSmall(Colors.white);
    locationStyle ??= SectionTextStyle.labelMedium(Colors.white);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Row(
                children: _generateImages(),
              ),
            ),
            Container(
              width: width,
              height: height,
              color: const Color.fromARGB(102, 1, 1, 1),
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        location,
                        style: locationStyle,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        title,
                        style: titleStyle,
                      ),
                    ),
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
