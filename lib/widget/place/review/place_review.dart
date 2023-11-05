import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:place_mobile_flutter/api/provider/place_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/utility.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';
import 'package:get/get.dart';

class ShortPlaceReviewCard extends StatefulWidget {
  final Function() onDeletePressed;

  ShortPlaceReviewCard({
    required this.vsync,
    required this.comment,
    this.profileUrl,
    this.myReview=false,
    required this.name,
    required this.date,
    required this.likeComment,
    required this.likeCount,
    required this.placeId,
    required this.reviewId,
    this.height=double.infinity,
    required this.onDeletePressed,
    Key? key,
  }) : super(key: key);

  String name;
  String date;
  String comment;
  String? profileUrl;

  int likeCount;

  String placeId;
  dynamic reviewId;

  bool likeComment;
  bool myReview;

  TickerProvider vsync;

  double height;

  @override
  State<StatefulWidget> createState() {
    return _ShortPlaceReviewCardState();
  }
}

class _ShortPlaceReviewCardState extends State<ShortPlaceReviewCard> {
  late final AnimationController _likeButtonController;
  late final PlaceProvider _placeProvider;

  bool awaitLikes = false;

  void like() async {
    awaitLikes = true;
    await _placeProvider.postPlaceReviewLike(widget.placeId, widget.reviewId);
    awaitLikes = false;
  }

  void unLike() async {
    awaitLikes = true;
    await _placeProvider.deletePlaceReviewLike(widget.placeId, widget.reviewId);
    awaitLikes = false;
  }

  @override
  void initState() {
  _likeButtonController = AnimationController(vsync: widget.vsync, duration: const Duration(milliseconds: 100));
  _placeProvider = PlaceProvider();
  super.initState();
  }

  @override
  void dispose() {
    _likeButtonController.dispose();
    super.dispose();
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.profileUrl != null ?
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(widget.profileUrl!),
                    ) :
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage('assets/images/avatar_male.png'),
                    )
                  ,
                  const SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: SectionTextStyle.labelMedium(Colors.black),
                        ),
                        const SizedBox(height: 4,),
                        Text(
                          widget.date,
                          style: SectionTextStyle.labelSmall(Colors.grey[600]!),
                        )
                      ],
                    ),
                  ),
                  if (!widget.myReview)
                    GestureDetector(
                      onTap: () {
                        if (awaitLikes) return;

                        if (AuthController.to.user.value == null) {
                          Get.showSnackbar(
                              WarnGetSnackBar(
                                  title: "로그인 필요",
                                  message: "한줄평 작성은 로그인이 필요합니다."
                              )
                          );
                          return;
                        }

                        setState(() {
                          HapticFeedback.lightImpact();
                          widget.likeComment = !widget.likeComment;
                          if (widget.likeComment) {
                            like();
                            _likeButtonController.animateTo(0.6);
                            widget.likeCount += 1;
                          } else {
                            unLike();
                            _likeButtonController.animateBack(0.1);
                            widget.likeCount -= 1;
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
                            Text(UnitConverter.formatNumber(widget.likeCount))
                          ],
                        ),
                      ),
                    ),
                  if (widget.myReview)
                    GestureDetector(
                      onTap: widget.onDeletePressed,
                      child: const Icon(Icons.delete, color: Colors.redAccent,),
                    )
                  // if (widget.myReview)
                  //   GestureDetector(
                  //     onTap: () {
                  //
                  //     },
                  //     child: const Icon(Icons.delete, color: Colors.redAccent,),
                  //   )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}