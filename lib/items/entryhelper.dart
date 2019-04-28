import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:w_reader/api/api.dart';
import 'item.dart';

class EntryHelper {
  Widget buildEntry(BuildContext context, dynamic entry,
      {hideComments = false, hidePhoto = false}) {
    var embed = entry["embed"];
    if (!hidePhoto && embed != null) {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                createEmbed(embed),
                _buildEntryContents(context, entry, hideComments: hideComments)
              ]));
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child:
              _buildEntryContents(context, entry, hideComments: hideComments));
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

  Widget _buildEntryContents(BuildContext context, dynamic entry,
      {hideComments = false}) {
    var comments;
    if (!hideComments) {
      comments = InkWell(
        child: Padding(
            padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
            child: Text("Comments count: ${entry["comments_count"]}",
                style: TextStyle(
                    color: Colors.black45,
                    decoration: TextDecoration.underline))),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Item(entry["id"])));
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
                          child: Text(entry["date"],
                              style: TextStyle(color: Colors.black45)))),
                  comments
                ],
              )),
          handleHtml(entry['body'])
        ]);
  }

  Widget handleHtml(String html) {
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
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
