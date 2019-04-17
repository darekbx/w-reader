import 'package:flutter/material.dart';
import 'package:w_reader/newsfeed/newsfeed.dart';
import 'package:w_reader/tags/tags.dart';
import 'package:w_reader/localstorage.dart';
import 'package:w_reader/settings/settings.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage({Key key}) : super(key: key);

  final _tagStorage = LocalStorage();

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage>
    with SingleTickerProviderStateMixin {
  NewsFeed _newsFeed = NewsFeed();
  int _tagsCount = 0;
  Tags _tags = Tags();
  List<Tab> _tabs;
  TabController _tabController;

  @override
  void initState() {
    _initializeTabController();

    _tags.reload = () => _loadTagsCount();
    _loadTagsCount();

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTagsCount() async {
    var count = await widget._tagStorage.countTags();

    setState(() {
      _tagsCount = count;
      _loadTabs();
    });
  }

  void _initializeTabController() {
    _loadTabs();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Reader"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                ),
              ],
              bottom: TabBar(controller: _tabController, tabs: _tabs),
            ),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[_newsFeed, _tags],
            )));
  }

  void _loadTabs() {
    _tabs = <Tab>[Tab(text: "News feed"), Tab(text: "Tags ($_tagsCount)")];
  }
}
