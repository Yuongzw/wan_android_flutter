import 'package:flutter/material.dart';
import 'package:wan_android_flutter/model/WeChatData.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wan_android_flutter/pager/WebView_Page.dart';
import 'package:wan_android_flutter/pager/SearchPage.dart';
import 'package:wan_android_flutter/utils/MyConstants.dart';
import 'package:wan_android_flutter/pager/LoginPage.dart';
import 'package:wan_android_flutter/model/WanAndroidResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WeChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WeChatPageState();
  }
}

class _WeChatPageState extends State<WeChatPage>
    with AutomaticKeepAliveClientMixin {
  final title = "公众号";
  List<WeChatBean> weChats = List();
  List<WeChatArticleBean> weChatArticles = List();
  int currentIndex = 0;
  int _currentPage = 1;
  int _id = 0;
  ScrollController _loadMore = new ScrollController(); //加载更多
//  BuildContext context;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadMore.addListener(() {
      if (_loadMore.position.pixels == _loadMore.position.maxScrollExtent) {
        _currentPage++;
        _getWeChatArticle(_id);
      }
    });
    _getWeChatsData();
  }

  @override
  void dispose() {
    _loadMore.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
//    this.context = context;
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
          body: weChats.length > 0 && weChatArticles.length > 0
              ? _getList()
              : _buildProgressIndicator()),
    );
  }

  void _toSearchPage() {
    Navigator.push(
      context,
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

  Widget _getList() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _getWeChatsList(),
        ),
        Container(
          width: 5,
          color: Colors.white70,
        ),
        Expanded(
          flex: 3,
          child: _getWeChatArticleList(),
        ),
      ],
    );
  }

  Widget _getWeChatsList() {
    Widget leftList = ListView.builder(
        itemCount: weChats.length,
        itemBuilder: (context, index) {
          if (index < weChats.length - 1) {
            return new Column(
              children: <Widget>[
                ListTile(
                  title: new Text(
                    '${weChats[index].name}',
                    style: TextStyle(
                        color: index == this.currentIndex
                            ? Colors.blueAccent
                            : Colors.black),
                  ),
                  onTap: () {
                    setState(() {
                      this.currentIndex = index;
                      _id = weChats[index].id;
                      weChatArticles.clear();
                      _currentPage = 1;
                    });
                    _getWeChatArticle(_id);
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
              title: new Text('${weChats[index].name}',
                  style: TextStyle(
                      color: index == this.currentIndex
                          ? Colors.blueAccent
                          : Colors.black)),
            );
          }
        });
    return leftList;
  }

  Widget _getWeChatArticleList() {

    Widget rightList = RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            controller: _loadMore,
            itemCount: weChatArticles.length,
            itemBuilder: (context, index) {
              bool isCollect = false;
              if(MyConstants.myCollectId.contains(weChatArticles[index].id)) {
                isCollect = true;
              }
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      this.context,
                      new MaterialPageRoute(
                          builder: (ctx) =>
                              WebViewPage(title: weChatArticles[index].title, url:  weChatArticles[index].link)));
                },
                child: Card(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 18, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      weChatArticles[index].author,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                    ),
                                  )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                weChatArticles[index]
                                    .title
                                    .replaceAll("&rdquo;", "")
                                    .replaceAll("&ldquo;", ""),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 15,
                              ),
                              Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      weChatArticles[index].niceDate,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )),
                              IconButton(
                                padding: EdgeInsets.only(top: 0),
                                icon: Icon(
                                  Icons.favorite,
                                  color: isCollect
                                      ? Colors.redAccent
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  if (!MyConstants.isLogin) {
                                    Navigator.push(
                                      this.context,
                                      new MaterialPageRoute(
                                          builder: (context) => new LoginPage()),
                                    );
                                    return;
                                  }
                                  if(isCollect) {//已收藏
                                    setState(() {
                                      isCollect = !isCollect;
                                    });
                                    cancelCollectArticle(weChatArticles[index].id);
                                    return;
                                  } else {//收藏
                                    setState(() {
                                      isCollect = !isCollect;
                                    });
                                    collectArticle(weChatArticles[index].id);
                                    return;
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              );
            }));
    return rightList;
  }

  void _getWeChatArticle(int id) async {
    Response response =
        await WanAndroidApiManager().getWeChatArticleData(id, _currentPage);
    var weChatArticle = WeChatArticle.fromJson(response.data);
    setState(() {
      weChatArticles.addAll(weChatArticle.data.datas);
    });
  }

  void _getWeChatsData() async {
    Response response = await WanAndroidApiManager().getWeChatListData();
    var weChatData = WeChatData.fromJson(response.data);
    setState(() {
      weChats.addAll(weChatData.data);
      if (weChats.length > 0) {
        _id = weChats[0].id;
        _getWeChatArticle(_id);
      }
    });
  }


  void collectArticle(int id) async {
    var response = await WanAndroidApiManager().collectArticle(id);
    var wanAndroidResponse = WanAndroidResponse.fromJson(response.data);
    if(wanAndroidResponse.errorCode == 0) {
      setState(() {
        MyConstants.myCollectId.add(id);
      });
      Fluttertoast.showToast(
          msg: '收藏成功！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white);
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

  void cancelCollectArticle(int id) async {
    var response = await WanAndroidApiManager().cancelCollected2(id);
    var wanAndroidResponse = WanAndroidResponse.fromJson(response.data);
    if(wanAndroidResponse.errorCode == 0) {
      setState(() {
        MyConstants.myCollectId.remove(id);
      });
      Fluttertoast.showToast(
          msg: '取消收藏成功！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white);
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

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {
    setState(() {
      weChatArticles.clear();
    });
    _currentPage = 0;
    _getWeChatArticle(_id);
  }
}
