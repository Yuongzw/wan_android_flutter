import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:wan_android_flutter/model/SearchData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android_flutter/pager/SearchResultPage.dart';

class SearchPage extends StatefulWidget {
  final title = "搜索";

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  List<HotKeyBean> hotKeys = List();
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHotKeyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: new SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration: BoxDecoration(
                  color: Colors.grey, // 底色,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        decoration: BoxDecoration(
                          border: new Border.all(
                              color: Colors.blueAccent, width: 0.5),
                          // 边色与边宽度
                          color: Colors.white70,
                          // 底色,
                          borderRadius: new BorderRadius.circular((5.0)), // 圆角度
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: '请输入搜索关键字',
                                  border: InputBorder.none,
                                ),
                                autofocus: false,
                              ),
                            ),
                            Offstage(
                              offstage: _textEditingController.text.length > 0? false: true,
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _textEditingController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if(_textEditingController.text == "") {
                            Fluttertoast.showToast(
                                msg: '输入不能为空',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.black45,
                                textColor: Colors.white);
                          } else {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (ctx) =>
                                        SearchResultPage(keyWord: _textEditingController.text)));
                          }
                          print("_textEditingController" +
                              _textEditingController.text);
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Text(
                            "搜索",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ))
                  ],
                ),
              ),
              Text(
                "热门搜索",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
              WrapWidget(
                hotKeys: hotKeys,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getHotKeyList() async {
    Response response = await WanAndroidApiManager().getHotKeyData();
    var hotKeyData = HotKeyData.fromJson(response.data);
    setState(() {
      hotKeys.addAll(hotKeyData.data);
    });
  }
}

/*
* 可以让子控件自动换行的控件
*
* */
// ignore: must_be_immutable
class WrapWidget extends StatefulWidget {
  List hotKeys;

  WrapWidget({Key key, this.hotKeys}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WrapWidgetState();
  }
}

class _WrapWidgetState extends State<WrapWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2, //主轴上子控件的间距
      runSpacing: 5, //交叉轴上子控件之间的间距
      children: Boxs(widget.hotKeys), //要显示的子控件集合
    );
  }

  /*一个渐变颜色的正方形集合*/
  List<Widget> Boxs(List hotKeys) => List.generate(hotKeys.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (ctx) =>
                        SearchResultPage(keyWord: (hotKeys as List<HotKeyBean>)[index].name)));
            print("Boxs" + (hotKeys as List<HotKeyBean>)[index].name);
          },
          child: Container(
            width: 100,
            height: 50,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.lightBlueAccent,
                Colors.lightBlue,
                Colors.blueAccent
              ]),
              borderRadius: new BorderRadius.circular((10.0)), // 圆角度
            ),
            child: Text(
              (hotKeys as List<HotKeyBean>)[index].name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      });
}
