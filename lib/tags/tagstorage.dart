import 'package:shared_preferences/shared_preferences.dart';

class TagStorage {

  final String _tagsKey = "tags";

  Future<void> addTag(String tag) async {
    var preferences = await SharedPreferences.getInstance();
    var tags = await fetchTags();
    tags.add(tag);
    await preferences.setStringList(_tagsKey, tags);
  }

  Future<List<String>> fetchTags() async {
    var preferences = await SharedPreferences.getInstance();
    var list = preferences.getStringList(_tagsKey);
    return list == null ? List<String>() : list;
  }

  void deleteTag(String tag) async {
    var preferences = await SharedPreferences.getInstance();
    var tags = await fetchTags();
    tags.remove(tag);
    await preferences.setStringList(_tagsKey, tags);
  }

  Future<int> countTags() async => (await fetchTags()).length;
}