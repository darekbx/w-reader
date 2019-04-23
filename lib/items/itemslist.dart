import 'package:flutter/material.dart';

class ItemsList extends StatefulWidget {

  final dynamic items;

  ItemsList(this.items);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("TODO"));
  }
}
