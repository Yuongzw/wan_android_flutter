import 'package:flutter/material.dart';
import 'package:wan_android_flutter/model/TodoData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:dio/dio.dart';

class TodoDetailPage extends StatefulWidget {
  String title;

  TodoDetailPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TodoDetailPageState();
  }
}

class _TodoDetailPageState extends State<TodoDetailPage>
    with AutomaticKeepAliveClientMixin {
  List<ListBean> todos = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.title == '未完成清单') {
      _getTodoList();
    } else {
      _getTodoDoneList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Basic List
      title: widget.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.title),
          ),
          body: todos.length > 0 ? createTodoItem() : _buildProgressIndicator()),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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

  Widget createTodoItem() {
    Widget rightList = ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: new Text(
                  todos[index].date.toString(),
                  style: TextStyle(color: widget.title == '未完成清单' ? Colors.greenAccent : Colors.orange),
                ),
                onTap: () {
                  Navigator.push(this.context, new MaterialPageRoute(builder: (BuildContext context){
//                    return new TreeArticlePage(cid: childrens[index].id, title:childrens[index].name);
                  }));
                },
              ),
//              Text(todos[index].title),
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

  void _getTodoList() async {
    Response response = await WanAndroidApiManager().getTodoListData();
    var todoData = TodoData.fromJson(response.data);
    if(widget.title == '未完成清单') {
      todos.addAll(todoData.data.todoList);
    }
  }

  void _getTodoDoneList() async {}
}
