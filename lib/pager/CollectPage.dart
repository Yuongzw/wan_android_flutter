import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:wan_android_flutter/pager/WebView_Page.dart';
import 'package:wan_android_flutter/model/WanAndroidResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wan_android_flutter/model/CollectArticleData.dart';
import 'package:wan_android_flutter/utils/MyConstants.dart';

class CollectPage extends StatefulWidget {
  final title = "我的收藏";

  @override
  State<StatefulWidget> createState() {
    return _CollectPageState();
  }
}

class _CollectPageState extends State<CollectPage> {
  List<ArticleBean> articles = List();
  int _currentPage = 0; //当前页
  ScrollController _loadMore = new ScrollController(); //加载更多
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMore.addListener(() {
      if (_loadMore.position.pixels == _loadMore.position.maxScrollExtent) {
        _currentPage++;
        _getCollectData(_currentPage);
      }
    });
    _getCollectData(_currentPage);
  }

  @override
  void dispose() {
    _loadMore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget listView = RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: articles.length,
            controller: _loadMore,
            itemBuilder: (context, index) {
              if (index < articles.length) {
                return createCollectArticleItem(articles[index], index);
              } else if (index == articles.length) {
                return _buildProgressIndicator();
              }
            }));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: articles.length > 0 ? listView : _buildProgressIndicator(),
    );
  }

  Widget createCollectArticleItem(ArticleBean article, int index) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (ctx) =>
                    WebViewPage(title: article.title, url: article.link)));
      },
      onLongPress: () {
//        showDialog<Null>(
//            context: context, //BuildContext对象
//            barrierDismissible: false,//是否点击外部隐藏
//            builder: (BuildContext context) {
//              return new CancelCollectDialog( //调用对话框
//                id: article.id,
//                originId: article.originId,
//              );
//            });
        showCancelDialog(context, article, index);
      },
      child: Card(
        margin: EdgeInsets.all(5),
        child: Container(
//          color: Colors.blueGrey,
          decoration: BoxDecoration(
            border: new Border.all(color: Colors.black, width: 0.5), // 边色与边宽度
            color: Colors.blueGrey, // 底色,
            borderRadius: new BorderRadius.circular((5.0)), // 圆角度
          ),
          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Text(
                    article.title
                        .replaceAll("&rdquo;", "")
                        .replaceAll("&ldquo;", ""),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                child: Row(
                  children: <Widget>[
                    Text("作者:" + article.author,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    Container(
                      width: 30,
                    ),
                    Text(article.niceDate,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {
    setState(() {
      articles.clear();
    });
    _currentPage = 0;
    _getCollectData(_currentPage);
  }

  void _getCollectData(int currentPage) async {
    Response response =
        await WanAndroidApiManager().getCollectArticleData(currentPage);
    var collectArticleData = CollectArticleData.fromJson(response.data);
    setState(() {
      articles.addAll(collectArticleData.data.datas);
    });
  }

  void cancelCollect(int id, int originId, int index) async {
    Response response =
        await WanAndroidApiManager().cancelCollected1(id, originId);
    var wanAndroidResponse = WanAndroidResponse.fromJson(response.data);
    if (wanAndroidResponse.errorCode == 0) {
      Fluttertoast.showToast(
          msg: '取消收藏成功！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white);
      setState(() {
        MyConstants.myCollectId.remove(originId);
        articles.removeAt(index);
      });
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: wanAndroidResponse.errorMsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white);
    }
  }

  void showCancelDialog(BuildContext context, ArticleBean article, int index) async {
    var dialog = CupertinoAlertDialog(
      content: Text(
        "确定要取消收藏该文章吗？",
        style: TextStyle(fontSize: 18),
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text("取消", style: TextStyle(fontSize: 16),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoButton(
          child: Text("确定", style: TextStyle(fontSize: 16)),
          onPressed: () {
            cancelCollect(article.id, article.originId, index);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }
}
