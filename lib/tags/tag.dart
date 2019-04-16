import 'package:flutter/material.dart';

class Tag extends StatefulWidget {

  final String tagName;

  Tag(String this.tagName);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text("${widget.tagName} (5234)"),
    );
  }
}