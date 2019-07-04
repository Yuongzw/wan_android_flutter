import 'package:flutter/material.dart';
import 'package:wan_android_flutter/model/TreeData.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wan_android_flutter/pager/TreeArticlePage.dart';
import 'package:wan_android_flutter/pager/SearchPage.dart';

class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage>
    with AutomaticKeepAliveClientMixin {
  final title = "体系";
  List<FathersBean> fathers = List();
  List<ChildrenBean> childrens = List();
  int index = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTreeData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text(title),
            actions: <Widget>[
              new IconButton( // action button
                icon: new Icon(Icons.search),
                onPressed: () { _toSearchPage();},
              ),
            ],
          ),
          body: fathers.length > 0 && childrens.length > 0
              ? _getList()
              : _buildProgressIndicator()),
    );
  }

  Widget _getList() {
    return new Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _getLeftList(),
        ),
        Container(
          width: 15,
          color: Colors.white70,
        ),
        Expanded(
          flex: 2,
          child: _getRightList(),
        ),
      ],
    );
  }

  Widget _getLeftList() {
    Widget leftList = ListView.builder(
        itemCount: fathers.length,
        itemBuilder: (context, index) {
          if (index < fathers.length - 1) {
            return new Column(
              children: <Widget>[
                ListTile(
                  title: new Text(
                    '${fathers[index].name}',
                    style: TextStyle(
                        color: index == this.index
                            ? Colors.blueAccent
                            : Colors.black),
                  ),
                  onTap: () {
                    setState(() {
                      this.index = index;
                    });
                    _setChildren(fathers[index].children);
                  },
                ),
                Divider(
                  height: 1.0,
                  indent: 0,
                  color: Colors.black,
                ),
              ],
            );
          } else {
            return ListTile(
              title: new Text('${fathers[index].name}',
                  style: TextStyle(
                      color: index == this.index
                          ? Colors.blueAccent
                          : Colors.black)),
            );
          }
        });
    return leftList;
  }

  Widget _getRightList() {
    Widget rightList = ListView.builder(
        itemCount: childrens.length,
        itemBuilder: (context, index) {
          return new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: new Text(
                  '${childrens[index].name}',
                  style: TextStyle(color: Colors.black54),
                ),
                onTap: () {
                  Navigator.push(this.context, new MaterialPageRoute(builder: (BuildContext context){
                    return new TreeArticlePage(cid: childrens[index].id, title:childrens[index].name);
                  }));
                },
              ),
              Divider(
                height: 1.0,
                indent: 0,
                color: Colors.black,
              ),
            ],
          );
        });
    return rightList;
  }

  void _toSearchPage() {
    Navigator.push(
      this.context,
      new MaterialPageRoute(builder: (context) => new SearchPage()),
    );
  }

  //加载动画
  Widget _buildProgressIndicator() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitFadingCircle(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.blue : Colors.green,
              ),
            );
          },
        ),
        Text(
          '加载数据中...',
          style: TextStyle(fontSize: 16, color: Colors.black),
        )
      ],
    );
  }

  void _getTreeData() async {
    Response response = await WanAndroidApiManager().getTreeData();
    var treeData = TreeData.fromJson(response.data);
    setState(() {
      fathers.addAll(treeData.data);
      childrens.addAll(treeData.data[0].children);
    });
  }

  _setChildren(List<ChildrenBean> children) {
    setState(() {
      childrens.clear();
      childrens.addAll(children);
    });
  }
}
