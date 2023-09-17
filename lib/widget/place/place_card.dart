import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/place/tag/tag_chip.dart';

class RoundedRectanglePlaceCard extends StatelessWidget {
  final Function()? onPressed;

  RoundedRectanglePlaceCard({
    required this.tags,
    required this.imageUrl,
    required this.placeName,
    required this.placeType,
    required this.distance,
    required this.open,
    required this.likeCount,

    this.width=220,
    this.aspectRatio=18/15,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  List<Map<String, dynamic>> tags;

  String imageUrl;
  String placeName;
  String placeType;
  String? distance;
  String open;
  String likeCount;

  double width;
  double aspectRatio;

  List<Widget> __createTags() {
    List<Widget> chips = [];
    int tagCount = tags.length < 2 ? tags.length : 2;
    for (int i = 0;i < tagCount;i++) {
      if (i != 0) chips.add(SizedBox(width: 4,));
      chips.add(
        TagChip(
          text: tags[i]['text'],
          backgroundColor: UnitConverter.hexToColor(tags[i]['color']),
        )
      );
    }
    return chips;
  }


  List<Widget> __createInfo() {
    List<Widget> inform = [];
    if(distance != null) {
      inform.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(MdiIcons.mapMarkerOutline, size: 18,),
            Text(
              distance!,
              style: SectionTextStyle.labelSmall(Colors.grey[700]!),
            )
          ],
        )
      );
    }
    inform.addAll([
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(MdiIcons.clockCheckOutline, size: 18),
          const SizedBox(
            width: 2,
          ),
          Text(
            open,
            style: SectionTextStyle.labelSmall(Colors.grey[700]!),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(MdiIcons.heart, size: 18),
          const SizedBox(
            width: 2,
          ),
          Text(
            likeCount,
            style: SectionTextStyle.labelSmall(Colors.grey[700]!),
          )
        ],
      )
    ]);
    return inform;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: GestureDetector(
        onTap: onPressed,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            surfaceTintColor: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Image.network(imageUrl, fit: BoxFit.fill,),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                placeName,
                                overflow: TextOverflow.ellipsis,
                                style: SectionTextStyle.sectionContentExtraLarge(Colors.black),
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Text(
                              placeType,
                              style: SectionTextStyle.labelMedium(Colors.grey[600]!),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 6
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: __createTags(),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: __createInfo(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedRowRectanglePlaceCard extends StatelessWidget {
  const RoundedRowRectanglePlaceCard({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1/1,
              child: Image.network(
                'https://source.unsplash.com/random',
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
