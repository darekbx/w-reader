import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

class Api {

  Api(this.apiKey);

  final String apiKey;
  final String _endpoint = "http://a.wykop.pl";

  Future<String> loadTagContents(String tag, {int page = 0}) async {
    var url = "$_endpoint/tag/$tag/page/$page/appkey/$apiKey";
    var response = await get(url);
    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    } else {
      return null;
    }
  }

}