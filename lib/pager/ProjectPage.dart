import 'package:flutter/material.dart';
import 'package:wan_android_flutter/model/ProjectData.dart';
import 'package:wan_android_flutter/widget/ProgressView.dart';
import 'package:wan_android_flutter/pager/ProjectArticlePage.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:wan_android_flutter/pager/SearchPage.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProjectPageState();
  }
}

class _ProjectPageState extends State<ProjectPage>
    with  SingleTickerProviderStateMixin {
  List<DataBean> tabs = List();
  TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProjectTab();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("项目"),
        actions: <Widget>[
          new IconButton( // action button
            icon: new Icon(Icons.search),
            onPressed: () { _toSearchPage();},
          ),
        ],
        bottom: _buildBottomBar(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map(
                (DataBean item) {
          return new Padding(
            padding: const EdgeInsets.all(16.0),
            child: tabs.length == 0
                ? new ProgressView()
                : new ProjectArticlePage(id: item.id),
          );
        }).toList(),
      ),
    );
  }


  void _toSearchPage() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SearchPage()),
    );
  }

  Widget _buildBottomBar() {
    if (tabs.length <= 0) {
      return Text('正在加载标签...');
    } else {
      if (_tabController == null) {
        _tabController = TabController(vsync: this, length: tabs.length);
      }

      return TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: tabs.map((DataBean choice) {
          return new Tab(
            text: choice.name,
          );
        }).toList(),
      );
    }
  }

  void _getProjectTab() async {
    Response response = await WanAndroidApiManager().getProjectTabData();
    var projectTab = ProjectData.fromJson(response.data);
    setState(() {
      tabs.addAll(projectTab.data);
    });
  }
}
