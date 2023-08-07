import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class ShortPlaceReviewCard extends StatefulWidget {
  ShortPlaceReviewCard({
    required this.vsync,
    Key? key,
  }) : super(key: key);

  bool likeComment = false;

  TickerProvider vsync;

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
        child: Container(
          color: Colors.grey[300],
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("ddddddd", textAlign: TextAlign.center,),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage("https://www.w3schools.com/howto/img_avatar.png"),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "name"
                        ),
                        Text("time")
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
                      padding: EdgeInsets.all(4),
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
                                    _likeButtonController.animateTo(0.6);
                                  } else {
                                    _likeButtonController.animateBack(0.1);
                                  }
                                }
                            ),
                          ),
                          SizedBox(width: 4,),
                          Text("1.2K")
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