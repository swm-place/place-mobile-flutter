import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();

  final UserProvider _userProvider = UserProvider();

  Rxn<List<dynamic>> placeBookmark = Rxn([]);

  void loadPlaceBookmark() async {
    Map<String, dynamic>? result = await _userProvider.getPlaceBookmark();
    if (result == null) {
      placeBookmark.value = null;
      placeBookmark.refresh();
      return;
    }

    placeBookmark.value = result['result'];
    placeBookmark.refresh();
  }
}