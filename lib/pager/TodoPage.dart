import 'package:flutter/material.dart';
import 'TodoDeTailPage.dart';

class TodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TodoPageState();
  }
}

class _TodoPageState extends State<TodoPage>
    with SingleTickerProviderStateMixin {
  final title = "我的代办";
  List<String> tabs = List();

  TabController _tabController;


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        //Basic List
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text(title),
            bottom: _buildBottomBar(),
          ),
          body: TabBarView(
            controller: _tabController,
            children: tabs.map((String item) {
              return new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new TodoDetailPage(),
              );
            }).toList(),
          ),
        ));
  }

  Widget _buildBottomBar() {
    tabs.add('代办清单');
    tabs.add('已完成清单');
    if (_tabController == null) {
      _tabController = TabController(vsync: this, length: tabs.length);
    }
    return TabBar(
      isScrollable: false,
      controller: _tabController,
      tabs: tabs.map((String item) {
        return new Tab(
          text: item,
        );
      }).toList(),
    );
  }
}
