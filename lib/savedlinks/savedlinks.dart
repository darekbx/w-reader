import 'package:flutter/material.dart';
import 'package:w_reader/repository/database.dart';

class SavedLinks extends StatefulWidget {
  SavedLinks();

  @override
  _SavedLinksState createState() => _SavedLinksState();
}

class _SavedLinksState extends State<SavedLinks> {

  int count = 0;

  @override
  Widget build(BuildContext context) {
    _test();
    return Scaffold(
      body: Text("Count: $count")
    );
  }

  _test() async {
    var results = await DatabaseProvider.instance.list();
    print(results);
  }
}