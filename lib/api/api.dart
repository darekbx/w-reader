import 'dart:io';
import 'package:http/http.dart';
import 'apicache.dart';

class Api {

  Api(this.apiKey);

  final String apiKey;
  final String _endpoint = "http://a2.wykop.pl";
  static String tagUrl(String tag) => "https://www.wykop.pl/tag/$tag";
  static String itemUrl(int id) => "https://www.wykop.pl/wpis/$id";

  Future<String> loadEntry(int entryId, {bool forceRefresh = false}) async {
    var url = "$_endpoint/entries/entry/$entryId/appkey/$apiKey";
    return await _fetchCachedString("$entryId", url, forceRefresh: forceRefresh);
  }

  Future<String> loadTagContents(String tag, {int page = 1, bool forceRefresh = false}) async {
    var url = "$_endpoint/tags/$tag/page/$page/appkey/$apiKey";
    return await _fetchCachedString(tag, url, forceRefresh: forceRefresh);
  }

  Future<String> _fetchCachedString(String key, String url, {bool forceRefresh = false}) async {
    if (apiKey == null) {
      return null;
    }

    var cachedContents = ApiCache.get(key);
    if (cachedContents != null && !forceRefresh) {
      return cachedContents;
    }

    var response = await get(url);
    if (response.statusCode == HttpStatus.ok) {
      var contents = response.body;
      ApiCache.add(key, contents);
      return contents;
    } else {
      return null;
    }
  }
}