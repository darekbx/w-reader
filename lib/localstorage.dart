import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final String _tagCounterKey = "tagCounter";
  final String _tagsKey = "tags";
  final String _apiKey = "apiKey";

  void setTagCount(String tag, int count) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setInt("${_tagCounterKey}_$tag", count);
  }

  Future<int> getTagCount(String tag) async {
    var preferences = await SharedPreferences.getInstance();
    var key = "${_tagCounterKey}_$tag";
    if (preferences.containsKey(key)) {
      return preferences.getInt(key);
    }
    return 0;
  }

  void setApiKey(String apiKey) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(_apiKey, apiKey);
  }

  Future<String> getApiKey() async =>
      (await SharedPreferences.getInstance()).getString(_apiKey);

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
