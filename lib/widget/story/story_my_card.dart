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
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 0,
                  blurRadius: 6.0,
                  offset: Offset(-1, 0), // changes position of shadow
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(editors![i]['profileUrl']),
            ),
          ),
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
          Text('+${editors!.length - showProfile}', style: SectionTextStyle.labelSmall(Colors.white),)
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
            // SizedBox(
            //   width: width,
            //   height: height,
            //   child: Image.network(imageUrl, fit: BoxFit.cover,),
            // ),
            Container(
              width: width,
              height: height,
              color: const Color.fromARGB(102, 1, 1, 1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            this.title,
                            style: SectionTextStyle.sectionTitleSmall(Colors.white),
                          ),
                        ),
                        SizedBox(height: 4,),
                        _editorSection()
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: _editorSection(),
                        // )
                        // Stack(alignment: Alignment.centerLeft, children: avatar)
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
