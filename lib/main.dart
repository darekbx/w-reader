import 'package:flutter/material.dart';
import 'readerpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  Map<int, Color> color = {
    50: Color.fromRGBO(199, 92, 92, .1),
    100: Color.fromRGBO(199, 92, 92, .2),
    200: Color.fromRGBO(199, 92, 92, .3),
    300: Color.fromRGBO(199, 92, 92, .4),
    400: Color.fromRGBO(199, 92, 92, .5),
    500: Color.fromRGBO(199, 92, 92, .6),
    600: Color.fromRGBO(199, 92, 92, .7),
    700: Color.fromRGBO(199, 92, 92, .8),
    800: Color.fromRGBO(199, 92, 92, .9),
    900: Color.fromRGBO(199, 92, 92, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reader',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFC75C5C, color),
      ),
      home: ReaderPage(),
    );
  }
}
