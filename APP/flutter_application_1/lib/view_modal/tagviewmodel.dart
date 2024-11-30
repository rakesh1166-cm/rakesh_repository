import 'package:flutter/foundation.dart';

class TagViewModel extends ChangeNotifier {
  List<String> tags = [];
  bool isLoading = false;

  TagViewModel() {
    fetchTags();
  }

  Future<void> fetchTags() async {
    isLoading = true;
    notifyListeners();

    try {
      // Static data

      
      tags = [
        'facebook',
        'twitter',
        'youtube',
        'wordpress',
        'tumblr',
        'instagram',
        'pinterest',
        'quora',
        'reddit',
        'telegram',
        'linkedin',
      
      ];
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}