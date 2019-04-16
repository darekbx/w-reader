import 'package:flutter/material.dart';
import 'tagstorage.dart';
import 'package:w_reader/commonwidgets.dart';
import 'tag.dart';

class Tags extends StatefulWidget {
  Tags();

  Function reload;
  final _tagStorage = TagStorage();

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
    
    await widget._tagStorage.addTag('Test');

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
          return _handleTagsFuture(snapshot, (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, index) =>
                  _tagItem(data[index]),
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

  _handleTagsFuture(
      AsyncSnapshot<List<String>> snapshot, Function(List<String>) callback) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return CommonWidgets.loadingView();
      default:
        if (snapshot.hasError) {
          return CommonWidgets.error(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return CommonWidgets.error("Error :( ");
          } else {
            return callback(snapshot.data);
          }
        }
    }
  }
}
