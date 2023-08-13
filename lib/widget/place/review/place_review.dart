import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class ShortPlaceReviewCard extends StatefulWidget {
  ShortPlaceReviewCard({
    required this.vsync,
    required this.comment,
    required this.profileUrl,
    required this.name,
    required this.date,
    required this.likeComment,
    required this.likeCount,
    this.height=double.infinity,
    Key? key,
  }) : super(key: key);

  String name;
  String date;
  String comment;
  String profileUrl;
  String likeCount;

  bool likeComment;

  TickerProvider vsync;

  double height;

  @override
  State<StatefulWidget> createState() {
    return _ShortPlaceReviewCardState();
  }
}

class _ShortPlaceReviewCardState extends State<ShortPlaceReviewCard> {
  late final AnimationController _likeButtonController;

  @override
  void initState() {
  _likeButtonController = AnimationController(vsync: widget.vsync, duration: Duration(milliseconds: 100));
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () => {
          print("clicked")
        },
        onLongPress: () {
          print("report");
        },
        child: Container(
          color: Colors.grey[300],
          width: double.infinity,
          height: widget.height,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      widget.comment,
                      textAlign: TextAlign.center,
                      style: SectionTextStyle.sectionContentLine(Colors.black),
                    ),
                  ),
                )
              ),
              const SizedBox(height: 8,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(widget.profileUrl),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: SectionTextStyle.labelMedium(Colors.black),
                        ),
                        Text(
                          widget.date,
                          style: SectionTextStyle.labelSmall(Colors.grey[600]!),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        HapticFeedback.lightImpact();
                        widget.likeComment = !widget.likeComment;
                        if (widget.likeComment) {
                          _likeButtonController.animateTo(0.6);
                        } else {
                          _likeButtonController.animateBack(0.1);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // width: 24,
                            // height: 24,
                            child: Lottie.asset(
                                "assets/lottie/animation_thumbsup.json",
                                repeat: false,
                                reverse: false,
                                width: 24,
                                height: 24,
                                controller: _likeButtonController,
                                onLoaded: (composition) {
                                  _likeButtonController.duration = composition.duration;
                                  if (widget.likeComment) {
                                    _likeButtonController.value = 0.6;
                                  } else {
                                    _likeButtonController.value = 0.1;
                                  }
                                }
                            ),
                          ),
                          const SizedBox(width: 4,),
                          Text(widget.likeCount)
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}