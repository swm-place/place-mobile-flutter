import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class MyStoryCard extends StatelessWidget {
  MyStoryCard({
    required this.title,
    // required this.message,
    // required this.location,
    // required this.imageUrl,
    this.width,
    this.height,
    this.placeImageUrls,
    this.editors,
    Key? key,
  }) : super(key: key);

  String title;
  // String message;
  // String location;
  // String imageUrl;

  double? width;
  double? height;

  List<Map<String, dynamic>>? editors;
  List<dynamic>? placeImageUrls;

  Widget _editorSection() {
    if (editors == null) return const SizedBox();

    List<Widget> avatar = [];
    int showProfile = editors!.length;
    if (showProfile > 5) showProfile = 5;

    double leftOffset = 0;
    for (int i = 0;i < showProfile;i++) {
      avatar.add(
        Positioned(
          left: leftOffset,
          child: Material(
            elevation: 1,
            shape: const CircleBorder(),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(editors![i]['profileUrl']),
              ),
            ),
          )
        )
      );
      leftOffset += 12;
    }

    Widget avatarSection = SizedBox(
      width: avatar.length * 12.0 + 18.0,
      height: 24,
      child: Stack(children: avatar),
    );
    if (showProfile == editors!.length) {
      return SizedBox(
        width: double.infinity,
        child: avatarSection,
      );
    } else {
      return Row(
        children: [
          avatarSection,
          Text('+${editors!.length - showProfile}', style: SectionTextStyle.labelMedium(Colors.white),)
        ],
      );
    }
  }

  Widget _createBackground() {
    if (placeImageUrls == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      );
    } else {
      List<Widget> top = [];
      List<Widget> bottom = [];
      if (placeImageUrls!.length == 1) {
        return Image.network(
          placeImageUrls![0],
          fit: BoxFit.cover,
          errorBuilder: (context, exception, stackTrace) {
            return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
          },
        );
      }
      if (placeImageUrls!.length == 2) {
        return Column(
          children: [
            SizedBox(
              width: width!,
              height: height! / 2,
              child: Image.network(
                placeImageUrls![0],
                fit: BoxFit.cover,
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                },
              ),
            ),
            SizedBox(
              width: width!,
              height: height! / 2,
              child: Image.network(
                placeImageUrls![1],
                fit: BoxFit.cover,
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                },
              ),
            ),
          ],
        );
      }
      if (placeImageUrls!.length == 3) {
        return Row(
          children: [
            Column(
              children: [
                SizedBox(
                  width: width! / 2,
                  height: height! / 2,
                  child: Image.network(
                    placeImageUrls![0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, exception, stackTrace) {
                      return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                    },
                  ),
                ),
                SizedBox(
                  width: width! / 2,
                  height: height! / 2,
                  child: Image.network(
                    placeImageUrls![1],
                    fit: BoxFit.cover,
                    errorBuilder: (context, exception, stackTrace) {
                      return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: width! / 2,
              height: height!,
              child: Image.network(
                placeImageUrls![2],
                fit: BoxFit.cover,
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                },
              ),
            ),
          ],
        );
      }
      return Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: Image.network(
                  placeImageUrls![0],
                  fit: BoxFit.cover,
                  errorBuilder: (context, exception, stackTrace) {
                    return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                  },
                ),
              ),
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: Image.network(
                  placeImageUrls![1],
                  fit: BoxFit.cover,
                  errorBuilder: (context, exception, stackTrace) {
                    return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: Image.network(
                  placeImageUrls![2],
                  fit: BoxFit.cover,
                  errorBuilder: (context, exception, stackTrace) {
                    return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                  },
                ),
              ),
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: Image.network(
                  placeImageUrls![3],
                  fit: BoxFit.cover,
                  errorBuilder: (context, exception, stackTrace) {
                    return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    width ??= double.infinity;
    height ??= double.infinity;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () => {
          print("story card")
        },
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: _createBackground(),
            ),
            Container(
              width: width,
              height: height,
              color: const Color.fromARGB(102, 1, 1, 1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: AutoSizeText(
                            title,
                            style: SectionTextStyle.sectionTitleSmall(Colors.white),
                            maxLines: 1,
                            minFontSize: 18,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: editors == null ? 0: 4,),
                        _editorSection()
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
