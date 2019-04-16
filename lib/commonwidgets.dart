import 'package:flutter/material.dart';

class CommonWidgets {

  static loadingView() => Center(
        child: CircularProgressIndicator(),
      );

  static error(String errorMessage) => Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(errorMessage),
      ));
}