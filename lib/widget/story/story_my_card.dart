import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/cache_image.dart';

class BookmarkCard extends StatelessWidget {
  final Function()? onTap;
  final Function()? onDelete;
  final Function()? onRename;

  BookmarkCard({
    required this.title,
    required this.onTap,
    required this.onDelete,
    required this.onRename,
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
      if (placeImageUrls!.isEmpty) {
        return Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
      }
      if (placeImageUrls!.length == 1) {
        return placeImageUrls![0] != null ?
          NetworkCacheImage(
            placeImageUrls![0],
            fit: BoxFit.cover,
          ) :
          Image.asset('assets/images/no_image.png', fit: BoxFit.cover,);
      }
      if (placeImageUrls!.length == 2) {
        return Column(
          children: [
            SizedBox(
              width: width!,
              height: height! / 2,
              child: placeImageUrls![0] != null ?
                NetworkCacheImage(
                  placeImageUrls![0],
                  fit: BoxFit.cover,
                ) :
                Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
            ),
            SizedBox(
              width: width!,
              height: height! / 2,
              child: placeImageUrls![1] != null ?
                NetworkCacheImage(
                  placeImageUrls![1],
                  fit: BoxFit.cover,
                ) :
                Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
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
                  child: placeImageUrls![0] != null ?
                    NetworkCacheImage(
                      placeImageUrls![0],
                      fit: BoxFit.cover,
                    ) :
                    Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
                ),
                SizedBox(
                  width: width! / 2,
                  height: height! / 2,
                  child: placeImageUrls![1] != null ?
                    NetworkCacheImage(
                      placeImageUrls![1],
                      fit: BoxFit.cover,
                    ) :
                    Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
                ),
              ],
            ),
            SizedBox(
              width: width! / 2,
              height: height!,
              child: placeImageUrls![2] != null ?
                NetworkCacheImage(
                  placeImageUrls![2],
                  fit: BoxFit.cover,
                ) :
                Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
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
                child: placeImageUrls![0] != null ?
                  NetworkCacheImage(
                    placeImageUrls![0],
                    fit: BoxFit.cover,
                  ) :
                  Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
              ),
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: placeImageUrls![1] != null ?
                  NetworkCacheImage(
                    placeImageUrls![1],
                    fit: BoxFit.cover,
                  ) :
                  Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: placeImageUrls![2] != null ?
                  NetworkCacheImage(
                    placeImageUrls![2],
                    fit: BoxFit.cover,
                  ) :
                  Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
              ),
              SizedBox(
                width: width! / 2,
                height: height! / 2,
                child: placeImageUrls![3] != null ?
                  NetworkCacheImage(
                    placeImageUrls![3],
                    fit: BoxFit.cover,
                  ) :
                  Image.asset('assets/images/no_image.png', fit: BoxFit.cover,),
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
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white,)),
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: Colors.white,),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(onTap: onRename, child: const Text('이름 변경'),),
                        PopupMenuItem(onTap: onDelete, child: const Text('삭제'),)
                      ];
                    },
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: AutoSizeText(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1,
                          ),
                          maxLines: 1,
                          minFontSize: 18,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: editors == null ? 0: 4,),
                  _editorSection()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LikeCard extends StatelessWidget {
  final Function()? onTap;

  LikeCard({
    required this.title,
    required this.onTap,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  String title;
  // String message;
  // String location;
  // String imageUrl;

  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    width ??= double.infinity;
    height ??= double.infinity;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            child: Center(
              child: Icon(Icons.favorite, size: 48,),
            ),
          ),
          Container(
            width: width,
            height: height,
            color: const Color.fromARGB(102, 1, 1, 1),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: AutoSizeText(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1,
                          ),
                          maxLines: 1,
                          minFontSize: 18,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
