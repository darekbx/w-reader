import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:w_reader/api/api.dart';

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
        body: ListView.separated(
          separatorBuilder: (BuildContext context, index) =>
              Divider(color: Colors.black),
          itemCount: list.length,
          itemBuilder: (BuildContext context, index) => _buildItem(list[index]),
        ));
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
      var preview = embed["preview"];
      var url = embed["url"];
      var previewImage = _createPreviewImage(preview, url);
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[previewImage, _buildEntryContents(entry)]));
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: _buildEntryContents(entry));
    }
  }

  Widget _createPreviewImage(String previewUrl, String url) {
    return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: InkWell(
            child: Image.network(previewUrl),
            onTap: () {
              _launchURL(url);
            }));
  }

  Widget _buildLink(dynamic link) {
    return Padding(padding: EdgeInsets.all(16), child: Text("link"));
  }

  Widget _buildEntryContents(dynamic entry) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Text(entry["date"],
                          style: TextStyle(color: Colors.black45))),
                  InkWell(
                    child: Text("Comments count: ${entry["comments_count"]}",
                        style: TextStyle(
                            color: Colors.black45,
                            decoration: TextDecoration.underline)),
                    onTap: () {
                      var url = Api.itemUrl(entry["id"]);
                      _launchURL(url);
                    },
                  )
                ],
              )),
          _handleHtml(entry['body'])
        ]);
  }

  Widget _handleHtml(String html) {
    return Html(
        data: html,
        onLinkTap: (url) {
          if (url[0] == "#") {
            url = Api.tagUrl(url.substring(1));
          }
          _launchURL(url);
        });
  }

  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
