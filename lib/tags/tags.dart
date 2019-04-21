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
  void addPressed() {
    setState(() {
      _addTag();
    });
  }

  void _addTag() async {
    
    await widget._tagStorage.addTag('bikepacking');

    if (widget.reload != null) {
      widget.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget._tagStorage.fetchTags(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          return CommonWidgets.handleFuture(snapshot, (data) {
            return ListView.builder(
              itemCount: (data as List<String>).length,
              itemBuilder: (BuildContext context, index) =>
                  _tagItem((data as List<String>)[index]),
            );
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addPressed(),
        tooltip: 'Add tag',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _tagItem(String tagName) {
    return Tag(tagName);
  }
}
