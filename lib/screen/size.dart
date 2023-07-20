import 'package:flutter/cupertino.dart';

double getDynamicPixel(BuildContext context, double pixel) {
  double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  return pixel * devicePixelRatio;
}