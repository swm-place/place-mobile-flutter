import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/tag/tag_chip.dart';

class RoundedRectanglePlaceCard extends StatelessWidget {
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
    Key? key,
  }) : super(key: key);

  List<TagChip> tags;

  String imageUrl;
  String placeName;
  String placeType;
  String distance;
  String open;
  String likeCount;

  double width;
  double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: GestureDetector(
        onTap: () {
          print("card clicked");
        },
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
                            Text(
                              placeName,
                              style: placeCardTitle,
                            ),
                            Text(
                              placeType,
                              style: placeCardCategory,
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
                          children: [
                            TagChip()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MdiIcons.mapMarkerOutline, size: 18,),
                              Text(
                                distance,
                                style: placeCardDetail,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MdiIcons.clockCheckOutline, size: 18),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                open,
                                style: placeCardDetail,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MdiIcons.heart, size: 18),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                likeCount,
                                style: placeCardDetail,
                              )
                            ],
                          )
                        ],
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