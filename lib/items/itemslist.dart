import 'package:flutter/material.dart';
import 'entryhelper.dart';

class ItemsList extends StatefulWidget {
  final dynamic data;
  final String tagName;
  final entryHelper = EntryHelper();

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
          itemBuilder: (BuildContext context, index) => _buildItem(context, list[index]),
        ));
  }

  Widget _buildItem(BuildContext context, dynamic row) {
    var type = row["type"];
    if (type == "entry") {
      return widget.entryHelper.buildEntry(context, row["entry"]);
    } else if (type == "link") {
      return _buildLink(row["link"]);
    }
    return Text("Unknown type");
  }


  Widget _buildLink(dynamic link) {
    return Padding(padding: EdgeInsets.all(16), child: Text("link"));
  }
}
