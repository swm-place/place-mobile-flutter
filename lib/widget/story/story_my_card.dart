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
    this.places,
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
  List<Map<String, dynamic>>? places;

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
          Text('+${editors!.length - showProfile}', style: SectionTextStyle.labelSmall(Colors.white),)
        ],
      );
    }
  }

  Widget _createBackground() {
    if (places == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      );
    } else {
      List<Widget> top = [];
      List<Widget> bottom = [];
      if (places!.length == 1) {
        return Image.network(
          places![0]['imageUrl'],
          fit: BoxFit.cover,
        );
      }
      if (places!.length == 2) {
        return Column(
          children: [
            SizedBox(
              width: width!,
              height: height! / 2,
              child: Image.network(
                places![0]['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: width!,
              height: height! / 2,
              child: Image.network(
                places![1]['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ],
        );
      }
      if (places!.length == 3) {
        return Row(
          children: [
            Column(
              children: [
                SizedBox(
                  width: width! / 2,
                  height: height! / 2,
                  child: Image.network(
                    places![0]['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: width! / 2,
                  height: height! / 2,
                  child: Image.network(
                    places![1]['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: width! / 2,
              height: height!,
              child: Image.network(
                places![2]['imageUrl'],
                fit: BoxFit.cover,
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
                  places![0]['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: Image.network(
                  places![1]['imageUrl'],
                  fit: BoxFit.cover,
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
                  places![2]['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: Image.network(
                  places![3]['imageUrl'],
                  fit: BoxFit.cover,
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
