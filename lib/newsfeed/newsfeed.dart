import 'package:flutter/material.dart';
import 'package:w_reader/tags/tagstorage.dart';

class NewsFeed extends StatefulWidget {
  NewsFeed();

  final _tagStorage = TagStorage();

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget._tagStorage.fetchTags(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        return _handleTagsFuture(snapshot, (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, index) => _tagItem(data[index]),
          );
        });
      },
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
