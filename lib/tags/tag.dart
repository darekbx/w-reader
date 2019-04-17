import 'package:flutter/material.dart';
import 'package:w_reader/api/api.dart';
import 'package:w_reader/commonwidgets.dart';

class Tag extends StatefulWidget {

  final String tagName;

  Tag(this.tagName);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: FutureBuilder(
        future: Api("").loadTagContents(widget.tagName),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return CommonWidgets.handleFuture(snapshot, (data) {
            return _tagView((data as String).length);
          });
        },
      ),
    );
  }

  Widget _tagView(int count) => Text("${widget.tagName} ($count)");
}