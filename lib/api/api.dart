import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

class Api {

  Api(this.apiKey);

  final String apiKey;

  final String _endpoint = "http://a.wykop.pl";

  Future<String> loadTagContents(String tag, {int page = 0}) async {
    var url = "$_endpoint/tag/$tag/page/$page/appkey/$apiKey";
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      return response.transform(Utf8Decoder()).first;
    } else {
      return null;
    }
  }

}