import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RecentSearchesController extends GetxController {
  final GetStorage _storage = GetStorage();
  final recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
  }

  void loadRecentSearches() {
    List<dynamic>? storedSearches =
        _storage.read<List<dynamic>>('recentSearches');
    if (storedSearches != null) {
      recentSearches.assignAll(storedSearches.cast<String>());
    }
  }

  void addSearch(String search) {
    if (!recentSearches.contains(search)) {
      recentSearches.add(search);
      _storage.write('recentSearches', recentSearches);
    }
  }

  void removeSearch(String search) {
    recentSearches.remove(search);
    _storage.write('recentSearches', recentSearches);
  }
}
