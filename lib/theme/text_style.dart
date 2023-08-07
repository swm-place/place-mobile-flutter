import 'package:flutter/material.dart';

class PageTextStyle {
  static TextStyle titleLarge() => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: Color(0xff000000),
    height: 28/22,
  );

  static TextStyle bodyLarge(Color color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
    height: 24/16,
  );
}

const headlineSmallGray = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w400,
  color: Color(0xff525151),
  height: 32/24,
);

const headlineSmall = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w400,
  color: Color(0xff000000),
  height: 32/24,
);

const labelLarge = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xff000000),
  height: 20/14,
);

const sectionTitle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: Color(0xff000000),
  height: 20/24,
);

const sectionContent = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xff8d8d8d),
  height: 14/16,
);

const storyLocation = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Color(0xffffffff),
  // height: 14/12,
);

const storyTitle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
  color: Color(0xffffffff),
  height: 20/22,
);

const storyMessage = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w500,
  color: Color(0xffffffff),
  // height: 13/15,
);

const placeCardTitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Color(0xff000000),
  height: 0.9,
);

const placeCardCategory = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xff807c7c),
  height: 1,
);

const placeTagText = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color(0xffffffff),
  height: 1,
);

const placeCardDetail = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  // color: Color(0xff42474e),
  height: 1,
);

const placeDetailTitle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
  color: Color(0xff000000),
  height: 1,
);

const placeDetailTagText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Color(0xffffffff),
  height: 1,
);

const placeDetailIntroduce = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  color: Color(0xff000000),
  height: 1,
);

const placeDetailInfo = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  // color: Color(0xff42474e),
  height: 1,
);
