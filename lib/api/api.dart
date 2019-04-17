import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'apicache.dart';

class Api {

  Api(this.apiKey);

  final String apiKey;
  final String _endpoint = "http://a.wykop.pl";

  Future<String> loadTagContents(String tag, {int page = 0}) async {
    if (apiKey == null) {
      return "";
    }

    var cachedContents = ApiCache.get(tag);
    if (cachedContents != null) {
      return cachedContents;
    }

    var url = "$_endpoint/tag/$tag/page/$page/appkey/$apiKey";
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