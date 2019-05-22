import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:w_reader/repository/localstorage.dart';
import 'package:w_reader/api/api.dart';
import 'package:w_reader/commonwidgets.dart';
import 'package:w_reader/items/entryhelper.dart';
import 'package:w_reader/repository/database.dart';
import 'package:w_reader/model/savedlink.dart';

class NewsFeed extends StatefulWidget {
  final entryHelper = EntryHelper();

  NewsFeed();

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  ScrollController _scrollController;
  var _localStorage = LocalStorage();
  var _forceRefresh = false;
  var _apiKey;
  var _paginationInfo;
  var _errorMessage;
  List<dynamic> _itemsList;
  
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _loadApiKey();
  }

  void _loadApiKey() async {
    var apiKey = await _localStorage.getApiKey();
    setState(() {
      _apiKey = apiKey;
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadNextPage();
    }
  }

  void _loadNextPage() async {
    var startPosition = _scrollController.position.pixels;
    CommonWidgets.showLoadingDialog(context);
    if (_paginationInfo != null && _paginationInfo["next"] != null) {
      var nextPageData = await Api(_apiKey).loadUrl(_paginationInfo["next"]);
      setState(() {
        _appendToList(nextPageData);

        Future.delayed(Duration(microseconds: 10)).then((a) {
          setState(() {
            _scrollController.jumpTo(startPosition);
          });
        });
        
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_itemsList == null) {
      return FutureBuilder(
        future: Api(_apiKey).loadPromotedLinks(forceRefresh: _forceRefresh),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return CommonWidgets.handleFuture(snapshot, (data) {
            _itemsList = List();
            _forceRefresh = false;
            _appendToList(data);
            return _buildList();
          });
        }
      );
    } else {
      return _buildList();
    }
  }

  _appendToList(String jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      _errorMessage = "Empty data!";
      return;
    }
    var json = JsonDecoder().convert(jsonString);
    if (json["error"] != null) {
        _errorMessage = json["error"]["message_en"];
        return;
    } else {
      _itemsList.addAll(json["data"] as List);
      _paginationInfo = json["pagination"];
      _errorMessage = null;
    }
  }

  Widget _buildList() {
    if (_errorMessage != null) {
      return _errorView(_errorMessage);
    }
    return ListView.builder(
        controller: _scrollController,
        itemCount: _itemsList.length,
        itemBuilder: (BuildContext context, index) => 
        InkWell(
          child: widget.entryHelper.buildLink(context, _itemsList[index], extended: true),
          onLongPress: () async { 
            var link = _itemsList[index];
            _saveLink(link);
          },
        ),
      );
  }

  Widget _errorView(String message) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(child: Text(message, style: TextStyle(color: Colors.red))),
        FlatButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _forceRefresh = true;
            });
          },
        )
      ]);

    void _saveLink(dynamic link) async {
      var savedLink = SavedLink(
        null, link["id"], link["title"], link["description"], link["preview"]
      );
      await DatabaseProvider.instance.add(savedLink);
    }
}
