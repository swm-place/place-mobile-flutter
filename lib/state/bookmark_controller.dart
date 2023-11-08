import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();

  final UserProvider _userProvider = UserProvider();

  Rxn<List<dynamic>> placeBookmark = Rxn([]);
  Rxn<List<dynamic>> courseBookmark = Rxn([]);

  void loadPlaceBookmark() async {
    if (placeBookmark.value != null) placeBookmark.value!.clear();

    Map<String, dynamic>? result = await _userProvider.getPlaceBookmark();

    if (result == null) {
      placeBookmark.value = null;
      placeBookmark.refresh();
      return;
    }

    placeBookmark.value = result['result'];
    placeBookmark.refresh();
  }

  void loadCourseBookmark() async {
    if (courseBookmark.value != null) courseBookmark.value!.clear();

    List<dynamic>? result = await _userProvider.getCourseBookmark();

    if (result == null) {
      courseBookmark.value = null;
      courseBookmark.refresh();
      return;
    }

    courseBookmark.value = result;
    courseBookmark.refresh();
  }
}