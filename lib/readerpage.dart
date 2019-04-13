import 'package:flutter/material.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage({Key key}) : super(key: key);

  bool _addButtonVisible = false;

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with SingleTickerProviderStateMixin {

  final List<Tab> _tabs = <Tab>[
    Tab(text: "News feed"), 
    Tab(text: "Tags (6)")
  ];

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
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController.addListener(() {
      setState(() {
        widget._addButtonVisible = _tabController.index == 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var addButton;

    if (widget._addButtonVisible) {
      addButton = FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add tag',
        child: Icon(Icons.add),
      );
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Reader"),
            bottom: TabBar(
              controller: _tabController,
              tabs: _tabs
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Text("A"),
              Text("B")
            ],
          ),
          floatingActionButton: addButton,
        ));
  }
}
