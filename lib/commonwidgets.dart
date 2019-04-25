import 'package:flutter/material.dart';

class CommonWidgets {
  static handleFuture(
      AsyncSnapshot<dynamic> snapshot, Function(dynamic) callback) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return loadingView();
      default:
        if (snapshot.hasError) {
          return error(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return error("Error :( ");
          } else {
            return callback(snapshot.data);
          }
        }
    }
  }

  static loadingView() =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(child: CircularProgressIndicator(), width: 16, height: 16)
      ]);

  static error(String errorMessage) => Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(errorMessage),
      ));
}
