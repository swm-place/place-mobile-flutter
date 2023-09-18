import 'package:flutter/material.dart';

class PageTextStyle {
  static TextStyle titleLarge() => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    height: 28/22,
  );

  static TextStyle bodyLarge(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
    height: 24/16,
  );

  static TextStyle headlineSmall(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: color,
    height: 32/24,
  );

  static TextStyle headlineBold(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1,
  );

  static TextStyle headlineExtraLarge(Color color) => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Color(0xff000000),
    height: 1,
  );
}


class SectionTextStyle {
  static TextStyle labelMedium(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1,
    // height: 20/14,
  );

  static TextStyle labelMediumThick(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1,
  );

  static TextStyle labelSmall(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1,
  );

  static TextStyle sectionTitle() => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xff000000),
    height: 1,
  );

  static TextStyle sectionTitleSmall(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: color,
    // height: 1,
  );

  static TextStyle sectionContent(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1,
  );

  static TextStyle sectionContentLine(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.1,
  );

  static TextStyle sectionContentLarge(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: color,
    height: 14/16,
  );

  static TextStyle sectionContentLargeLine(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.1,
  );

  static TextStyle sectionContentExtraLarge(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
    height: 0.9,
  );

  static TextStyle lineContentExtraLarge(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.1,
  );
}
