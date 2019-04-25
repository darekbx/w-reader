import 'package:flutter/material.dart';
import 'package:w_reader/api/api.dart';
import 'package:w_reader/commonwidgets.dart';
import 'package:w_reader/localstorage.dart';
import 'package:w_reader/items/itemslist.dart';
import 'dart:convert';

class Tag extends StatefulWidget {
  final String tagName;

  Tag(this.tagName);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
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
      future: Api(_apiKey)
          .loadTagContents(widget.tagName, forceRefresh: _forceRefresh),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return CommonWidgets.handleFuture(snapshot, (data) {
          _forceRefresh = false;
          return _tagView(data as String);
        });
      },
    );
  }

  Widget _tagView(String contents) {
    if (contents.isNotEmpty) {
      var json = JsonDecoder().convert(contents);
      if (json["error"] == null) {
        var total = json["meta"]["counters"]["total"];
        return InkWell(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("#${widget.tagName} ($total)")),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemsList(json, widget.tagName)));
          },
          onLongPress: () {
            setState(() {
              // TODO: Reload tags
              _localStorage.deleteTag(widget.tagName);
            });
          }
        );
      } else {
        return _errorView(json["error"]["message_en"]);
      }
    } else {
      return Text("Check api key");
    }
  }

  Widget _errorView(String message) => Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(child: Text(message, style: TextStyle(color: Colors.red))),
        FlatButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _forceRefresh = true;
            });
          },
        )
      ]));
}
