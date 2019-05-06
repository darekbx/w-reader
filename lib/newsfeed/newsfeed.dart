import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:w_reader/localstorage.dart';
import 'package:w_reader/api/api.dart';
import 'package:w_reader/commonwidgets.dart';
import 'package:w_reader/items/entryhelper.dart';

class NewsFeed extends StatefulWidget {
  final entryHelper = EntryHelper();
  
  NewsFeed();

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  var _localStorage = LocalStorage();
  var _forceRefresh = false;
  var _apiKey;
  
  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  void _loadApiKey() async {
    var apiKey = await _localStorage.getApiKey();
    setState(() {
      _apiKey = apiKey;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api(_apiKey).loadPromotedLinks(forceRefresh: _forceRefresh),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return CommonWidgets.handleFuture(snapshot, (data) {
          _forceRefresh = false;
          return _buildList(data);
        });
      }
    );
  }

  Widget _buildList(String jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return _errorView("Empty data!");
    }
    var json = JsonDecoder().convert(jsonString);

    if (json["error"] != null) {
        return _errorView(json["error"]["message_en"]);
    } else {
      var data = json["data"] as List;
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, index) => 
          widget.entryHelper.buildLink(context, data[index], extended: true),
      );
    }
  }

  Widget _errorView(String message) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(child: Text(message, style: TextStyle(color: Colors.red))),
        FlatButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _forceRefresh = true;
            });
          },
        )
      ]);
}
