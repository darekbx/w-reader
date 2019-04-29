import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:w_reader/api/api.dart';
import 'item.dart';

class EntryHelper {
  Widget buildItem(BuildContext context, dynamic item, String type,
      {hideComments = false}) {
    if (type == "entry") {
      return buildEntry(context, item, hideComments: hideComments);
    } else {
      return buildLink(context, item, hideComments: hideComments);
    }
  }

  Widget buildLink(BuildContext context, dynamic link, {hideComments = false}) {
    link["body"] = link["description"];
    link["type"] = "link";
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              createEmbed(
                  {"url": link["source_url"], "preview": link["preview"]}),
              _buildContents(context, link, hideComments: hideComments)
            ]));
  }

  Widget buildEntry(BuildContext context, dynamic entry,
      {hideComments = false, hidePhoto = false}) {
    entry["type"] = "entry";
    var embed = entry["embed"];
    if (!hidePhoto && embed != null) {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                createEmbed(embed),
                _buildContents(context, entry, hideComments: hideComments)
              ]));
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: _buildContents(context, entry, hideComments: hideComments));
    }
  }

  Widget createEmbed(dynamic embed) {
    if (embed != null) {
      var preview = embed["preview"];
      var url = embed["url"];
      return _createPreviewImage(preview, url);
    }
    return Text("");
  }

  Widget _createPreviewImage(String previewUrl, String url) {
    return InkWell(
        child: Image.network(previewUrl),
        onTap: () {
          launchURL(url);
        });
  }

  Widget _buildContents(BuildContext context, dynamic data,
      {hideComments = false}) {
    var comments;
    if (!hideComments) {
      comments = InkWell(
        child: Padding(
            padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
            child: Text("Comments count: ${data["comments_count"]}",
                style: TextStyle(
                    color: Colors.black45,
                    decoration: TextDecoration.underline))),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Item(data["id"], data["type"]);
          }));
        },
      );
    } else {
      comments = Spacer();
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(data["date"],
                              style: TextStyle(color: Colors.black45)))),
                  comments
                ],
              )),
          handleHtml(data['body'])
        ]);
  }

  Widget handleHtml(String html) {
    if (html == null) {  
      return Text("");
    }
    return Html(
        data: html,
        onLinkTap: (url) {
          if (url[0] == "#") {
            url = Api.tagUrl(url.substring(1));
          }
          launchURL(url);
        });
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
