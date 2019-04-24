import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'apicache.dart';

class Api {

  Api(this.apiKey);

  final String apiKey;
  final String _endpoint = "http://a2.wykop.pl";
  static String tagPrefix() => "https://www.wykop.pl/tag/";

  Future<String> loadTagContents(String tag, {int page = 1, bool forceRefresh = false}) async {
    if (apiKey == null) {
      return "";
    }

    var cachedContents = ApiCache.get(tag);
    if (cachedContents != null && !forceRefresh) {
      return cachedContents;
    }

    var url = "$_endpoint/tags/$tag/page/$page/appkey/$apiKey";
    var response = await get(url);
    if (response.statusCode == HttpStatus.ok) {
      var contents = response.body;
      ApiCache.add(tag, contents);
      return contents;
    } else {
      return null;
    }
  }
}