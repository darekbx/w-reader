import 'package:shared_preferences/shared_preferences.dart';

class TagStorage {

  final String _tagsKey = "tags";

  void addTag(String tag) async {
    var preferences = await SharedPreferences.getInstance();
    var tags = await fetchTags();
    tags.add(tag);
    await preferences.setStringList(_tagsKey, tags);
  }

  Future<List<String>> fetchTags() async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(_tagsKey);
  }
}