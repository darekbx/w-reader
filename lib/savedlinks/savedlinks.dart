import 'package:flutter/material.dart';
import 'package:w_reader/repository/database.dart';
import 'package:w_reader/commonwidgets.dart';
import 'package:w_reader/model/savedlink.dart';
import 'package:w_reader/items/entryhelper.dart';

class SavedLinks extends StatefulWidget {
  SavedLinks();

  @override
  _SavedLinksState createState() => _SavedLinksState();
}

class _SavedLinksState extends State<SavedLinks> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(16),
            child: FutureBuilder(
              future: _savedLinks(),
              builder: (BuildContext contet, AsyncSnapshot<dynamic> snapshot) {
                return CommonWidgets.handleFuture(snapshot, (data) {
                  return _buildItemsList(data);
                });
              },
            )));
  }

  Widget _buildItemsList(List<SavedLink> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, index) => _buildItem(items[index]),
    );
  }

  Widget _buildItem(SavedLink link) {
    return InkWell(
      child: Text(link.title),
      onTap: () {
        
        // TODO: open url or single link in new page?

      },
      onLongPress: () {

        // TODO: remove on long press

      },
    );
  }

  _savedLinks() async => await DatabaseProvider.instance.list();
}
