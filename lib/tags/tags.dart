import 'package:flutter/material.dart';
import 'package:w_reader/localstorage.dart';
import 'package:w_reader/commonwidgets.dart';
import 'tag.dart';

class Tags extends StatefulWidget {
  Tags();

  Function reload;
  final _tagStorage = LocalStorage();

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  var _tagFieldController = TextEditingController();

  void _addTagDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add new tag"),
            content: TextField(
              controller: _tagFieldController,
              decoration: InputDecoration(hintText: "Tag name without #"),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text("Add"),
                  onPressed: () {
                    setState(() {
                      _addTag(_tagFieldController.text);
                      _tagFieldController.clear();
                    });
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  void _addTag(String tag) async {
    await widget._tagStorage.addTag(tag);
    if (widget.reload != null) {
      widget.reload();
    }
  }

  @override
  void dispose() {
    _tagFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget._tagStorage.fetchTags(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          return CommonWidgets.handleFuture(snapshot, (json) {
            return ListView.builder(
              itemCount: (json as List<String>).length,
              itemBuilder: (BuildContext context, index) =>
                  _tagItem((json as List<String>)[index]),
            );
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTagDialog(context),
        tooltip: 'Add tag',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _tagItem(String tagName) {
    return Tag(tagName);
  }
}
