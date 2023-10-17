import 'package:auto_size_text/auto_size_text.dart';
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
  RoundedRowRectanglePlaceCard({
    required this.tags,
    required this.imageUrl,
    required this.placeName,
    required this.placeType,
    required this.distance,
    required this.open,
    this.elevation=2.5,
    this.borderRadius=8,
    this.imageBorderRadius=0,
    this.imagePadding=EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  final List<Map<String, dynamic>> tags;

  final String imageUrl;
  String placeName;
  String placeType;

  String? distance;
  String open;

  double elevation;
  double borderRadius;
  double imageBorderRadius;

  EdgeInsets imagePadding;

  List<Widget> __createTags() {
    List<Widget> chips = [];
    int tagCount = tags.length < 2 ? tags.length : 2;
    for (int i = 0; i < tagCount; i++) {
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
    if (distance != null) {
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
      inform.add(SizedBox(width: 8,));
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
    ]);
    return inform;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shadowColor: Colors.grey[100],
      borderRadius: BorderRadius.circular(borderRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          height: 95,
          width: double.infinity,
          child: Row(
            children: [
              Padding(
                padding: imagePadding,
                child: ClipRRect(
                borderRadius: BorderRadius.circular(imageBorderRadius),
                  child: AspectRatio(
                    aspectRatio: 1.1 / 1,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                placeName,
                                overflow: TextOverflow.ellipsis,
                                style: SectionTextStyle.sectionContentExtraLarge(
                                    Colors.black),
                              ),
                            ),
                            // Text(
                            //   '카테고리',
                            //   maxLines: 1,
                            //   style: SectionTextStyle.labelMedium(
                            //       Colors.grey[600]!),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: __createTags(),
                        ),
                      ),
                      Row(
                        children: __createInfo(),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedPlaceCard extends StatelessWidget {
  SelectedPlaceCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomStart,
        children: [
          SizedBox(
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                    )
                ),
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        'https://source.unsplash.com/random',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: Text('장소 이름'),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: -5,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red
                ),
                child: const Center(
                  child: Icon(Icons.close, size: 14, color: Colors.white,),
                ),
              ),
            ),
          )
          // Positioned(
          //   top: -5,
          //   right: -5,
          //   child: Ink(
          //     width: 18,
          //     height: 18,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.red
          //     ),
          //     child: InkWell(
          //       customBorder: const CircleBorder(),
          //       child: const Padding(
          //         padding: EdgeInsets.zero,
          //         child: Icon(Icons.close, size: 14, color: Colors.white,),
          //       ),
          //       onTap: () {
          //         Navigator.pop(context);
          //       },
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
