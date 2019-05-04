import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:w_reader/api/api.dart';
import 'package:w_reader/localstorage.dart';
import 'package:w_reader/commonwidgets.dart';
import 'entryhelper.dart';

class Item extends StatefulWidget {
  final int itemId;
  final String type;
  final entryHelper = EntryHelper();

  Item(this.itemId, this.type);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  var _localStorage = LocalStorage();
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
    var future;
    if (widget.type == "entry") {
      future = Api(_apiKey).loadEntry(widget.itemId);
    } else {
      future = Api(_apiKey).loadLink(widget.itemId);
    }
    return Scaffold(
        appBar: AppBar(title: Text("Entry")),
        body: Padding(
          padding: EdgeInsets.only(top: 8),
          child: FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return CommonWidgets.handleFuture(snapshot, (jsonString) {
                var json = JsonDecoder().convert(jsonString);
                return _buildCommentsList(context, json["data"]);
              });
            })));
  }

  Widget _buildHeader(BuildContext context, dynamic data) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.entryHelper
              .buildItem(context, data, widget.type, hideComments: true),
          Divider(color: Colors.black)
        ]);
  }

  Widget _buildCommentsList(BuildContext context, dynamic data) {
    var comments = data["comments"];
    return ListView.builder(
        itemCount: comments.length + 1,
        itemBuilder: (BuildContext context, index) {
          if (index == 0) {
            return _buildHeader(context, data);
          }

          var comment = comments[index - 1];
          return _buildSingleComment(comment);
        });
  }

  Widget _buildSingleComment(dynamic comment) {
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                          child: Text(comment["date"],
                              style: TextStyle(color: Colors.black45))),
                      Text(comment["author"]["login"],
                          style: TextStyle(color: Colors.black45))
                    ],
                  )),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.entryHelper.createEmbed(comment["embed"]),
                    widget.entryHelper.handleHtml(context, comment["body"])
                  ]),
              Divider(color: Colors.black45)
            ]));
  }
}
