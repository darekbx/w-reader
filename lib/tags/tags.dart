import 'package:flutter/material.dart';
import 'tagstorage.dart';

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

  Widget _tagItem(String tag) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(tag),
    );
  }

  _handleTagsFuture(
      AsyncSnapshot<List<String>> snapshot, Function(List<String>) callback) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return _buildError("Error :( ");
          } else {
            return callback(snapshot.data);
          }
        }
    }
  }

  _buildLoadingView() => Center(
        child: CircularProgressIndicator(),
      );

  _buildError(String errorMessage) => Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(errorMessage),
      ));
}
