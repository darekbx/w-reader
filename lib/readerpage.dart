import 'package:flutter/material.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage({Key key}) : super(key: key);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage>
    with SingleTickerProviderStateMixin {

  bool _addButtonVisible = false;
  int _tagsCount = 6;
  List<Tab> _tabs;
  TabController _tabController;

  @override
  void initState() {
    _initializeTabController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeTabController() {
    loadTabs();
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController.addListener(() {
      setState(() {
        _addButtonVisible = _tabController.index == 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var addButton;

    if (_addButtonVisible) {
      addButton = FloatingActionButton(
        onPressed: () {
          
          setState(() {
            _tagsCount++;
            loadTabs();
          });

        },
        tooltip: 'Add tag',
        child: Icon(Icons.add),
      );
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Reader"),
            bottom: TabBar(controller: _tabController, tabs: _tabs),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[Text("A"), Text("B")],
          ),
          floatingActionButton: addButton,
        ));
  }

  void loadTabs() {
    _tabs = <Tab>[
      Tab(text: "News feed"),
      Tab(text: "Tags ($_tagsCount)")
    ];
  }
}
