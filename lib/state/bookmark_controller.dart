import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();

  final UserProvider _userProvider = UserProvider();

  Rxn<List<dynamic>> placeBookmark = Rxn([]);
  Rxn<List<dynamic>> courseBookmark = Rxn([]);

  int _courseCount = 20;
  int _coursePage = 0;
  int _placeCount = 20;
  int _placePage = 0;

  void loadPlaceBookmark() async {
    _placePage = 0;

    if (placeBookmark.value != null) placeBookmark.value!.clear();

    Map<String, dynamic>? result = await _userProvider.getPlaceBookmark(_placePage, _placeCount, null);

    if (result == null) {
      placeBookmark.value = null;
      placeBookmark.refresh();
      return;
    }

    placeBookmark.value = result['result'];
    placeBookmark.refresh();
  }

  void loadCourseBookmark() async {
    _coursePage = 0;

    if (courseBookmark.value != null) courseBookmark.value!.clear();

    List<dynamic>? result = await _userProvider.getCourseBookmark(_coursePage, _courseCount, null);

    if (result == null) {
      courseBookmark.value = null;
      courseBookmark.refresh();
      return;
    }

    courseBookmark.value = result;
    courseBookmark.refresh();
  }

  Future<void> addPlaceBookmarkList() async {
    if (placeBookmark.value == null) return;

    _placePage++;
    Map<String, dynamic>? result = await _userProvider.getPlaceBookmark(_placePage, _placeCount, null);

    if (result == null) {
      _placePage--;
      return;
    }

    placeBookmark.value!.addAll(result['result']);
    placeBookmark.refresh();
  }

  Future<void> addCourseBookmarkList() async {
    if (courseBookmark.value == null) return;

    _coursePage++;
    List<dynamic>? result = await _userProvider.getCourseBookmark(_coursePage, _courseCount, null);

    if (result == null) {
      _placePage--;
      return;
    }

    courseBookmark.value!.addAll(result);
    courseBookmark.refresh();
  }

  Future<bool> addPlaceBookmark(String title) async {
    if (AuthController.to.user.value == null) return false;
    return await _userProvider.postPlaceBookmark(title);
  }

  Future<bool> addCourseBookmark(String title) async {
    if (AuthController.to.user.value == null) return false;
    return await _userProvider.postCourseBookmark(title);
  }

  Future<bool> deletePlaceBookmark(dynamic bookmarkId) async {
    if (AuthController.to.user.value == null) return false;
    return await _userProvider.deletePlaceBookmark(bookmarkId);
  }

  Future<bool> deleteCourseBookmark(dynamic bookmarkId) async {
    if (AuthController.to.user.value == null) return false;
    return await _userProvider.deleteCourseBookmark(bookmarkId);
  }

  Future<bool> patchPlaceBookmark(dynamic bookmarkId, String title) async {
    if (AuthController.to.user.value == null) return false;
    return false;
    return await _userProvider.deletePlaceBookmark(bookmarkId);
  }

  Future<bool> patchCourseBookmark(dynamic bookmarkId, String title) async {
    if (AuthController.to.user.value == null) return false;
    return await _userProvider.patchCourseBookmark(bookmarkId, title);
  }
}