import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  final String _tagsKey = "tags";
  final String _apiKey = "apiKey";

  void setApiKey(String apiKey) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(_apiKey, apiKey);
  }

  Future<String> getApiKey() async => (await SharedPreferences.getInstance()).getString(_apiKey);

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