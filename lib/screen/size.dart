import 'package:flutter/cupertino.dart';

double getDynamicPixel(BuildContext context, double pixel) {
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  print(devicePixelRatio);
  return pixel * devicePixelRatio;
}