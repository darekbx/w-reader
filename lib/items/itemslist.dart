import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ItemsList extends StatefulWidget {

  final dynamic data;
  final String tagName;

  ItemsList(this.data, this.tagName);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  
  @override
  Widget build(BuildContext context) {
    var list = (widget.data["data"] as List);
    return Scaffold(
      appBar: AppBar(title: Text("#${widget.tagName}")),
      body:   
      ListView.separated(
        separatorBuilder: (BuildContext context, index) => Divider(color: Colors.black),
        itemCount: list.length,
        itemBuilder: (BuildContext context, index) => _buildItem(list[index]),
      )
    );
  }

  Widget _buildItem(dynamic row) {
    var type = row["type"];
    if (type == "entry") {
      return _buildEntry(row["entry"]);
    } else if (type == "link") {
      return _buildLink(row["link"]);
    }
    return Text("Unknown type");
  }

  Widget _buildEntry(dynamic entry) {
    var embed = entry["embed"];
    if (embed != null) {
      var url = embed["url"];
      var preview = embed["preview"];
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(preview),
            _handleHtml(entry['body'])
          ]
        )
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(16),
        child: _handleHtml(entry['body'])
      );
    }
  }

  Widget _buildLink(dynamic link) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text("link")
    );
  }
  
  Widget _handleHtml(String html) {
    return Html(
      data: html,
      onLinkTap: (url) { 
        throw Exception("TODO");
      });
  }
}
