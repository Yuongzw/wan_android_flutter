import 'package:flutter/material.dart';
import 'package:wan_android_flutter/model/HomeArticleData.dart';
import 'package:wan_android_flutter/model/HomeBannerData.dart';
import 'package:wan_android_flutter/widget/Banner.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wan_android_flutter/pager/WebView_Page.dart';
import 'package:wan_android_flutter/pager/SearchPage.dart';
import 'package:wan_android_flutter/pager/LoginPage.dart';
import 'package:wan_android_flutter/utils/MyConstants.dart';
import 'package:wan_android_flutter/model/WanAndroidResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final title = "主页";
  List<ArticleData> articles = List();
  List<BannerDataBean> banners = List();
  List<BannerItem> bannerItems = List();
  int _currentPage = 0; //当前页
  ScrollController _loadMore = new ScrollController(); //加载更多
  bool isPerformingRequest = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMore.addListener(() {
      if (_loadMore.position.pixels == _loadMore.position.maxScrollExtent) {
        _currentPage++;
        _getHomeData(_currentPage);
      }
    });
    _getHomeData(_currentPage);
    _getBannerData();
  }

  @override
  void dispose() {
    _loadMore.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    Widget listView = RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: articles.length + 1,
            controller: _loadMore,
            itemBuilder: (context, index) {
              if (index == 0) {
                return createBannerItem(200, bannerItems);
              } else {
                if (index - 1 < articles.length) {
                  return createHomeArticleItem(articles[index - 1]);
                } else if (index == articles.length) {
                  return _buildProgressIndicator();
                }
              }
            }));
    return MaterialApp(
      //Basic List
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text(title),
            actions: <Widget>[
              new IconButton(
                // action button
                icon: new Icon(Icons.search),
                onPressed: () {
                  _toSearchPage();
                },
              ),
            ],
          ),
          body: articles.length > 0 ? listView : _buildProgressIndicator()),
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

  Widget createBannerItem(double height, List<BannerItem> datas) {
    return BannerWidget(
      height,
      datas,
      bannerPress: (pos, item) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (ctx) => WebViewPage(
                    title: banners[pos].title, url: banners[pos].url)));

//        Fluttertoast.showToast(
//            msg: '第 $pos 点击了',
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIos: 1,
//            backgroundColor: Colors.black45,
//            textColor: Colors.white);
      },
    );
  }

  Widget createHomeArticleItem(ArticleData article) {
    bool isCollect = false;
    if(MyConstants.myCollectId.contains(article.id)) {
      isCollect = true;
    }
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (ctx) =>
                    WebViewPage(title: article.title, url: article.link)));

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
              Row(
                children: <Widget>[
                  Expanded(
//                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        article.author,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                  Text(
                    article.niceDate,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
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
              Row(
                children: <Widget>[
                  Expanded(
//                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        article.chapterName,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.only(top: 10),
                    icon: Icon(
                      Icons.favorite,
                      color: isCollect
                          ? Colors.redAccent
                          : Colors.white70,
                    ),
                    onPressed: () {
                      if (!MyConstants.isLogin) {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new LoginPage()),
                        );
                        return;
                      }
                      if(isCollect) {//已收藏

                        cancelCollectArticle(article.id);
                        return;
                      } else {//为收藏
                        setState(() {
                          isCollect = !isCollect;
                        });
                        collectArticle(article.id);
                        return;
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
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
    _getHomeData(_currentPage);
  }

  void _toSearchPage() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SearchPage()),
    );
  }

  void _getHomeData(int currentPage) async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      Response response =
          await WanAndroidApiManager().getHomeArticleData(currentPage);
      var homeArticleBean = HomeArticleBean.fromJson(response.data);
      setState(() {
        articles.addAll(homeArticleBean.data.datas);
        isPerformingRequest = false;
      });
    }
  }

  void _getBannerData() async {
    Response response = await WanAndroidApiManager().getHomeBannerData();
    var bannerData = BannerData.fromJson(response.data);
    setState(() {
      banners.addAll(bannerData.data);
      for (BannerDataBean item in banners) {
        BannerItem bannerItem =
            BannerItem.defaultBannerItem(item.imagePath, item.title);
        bannerItems.add(bannerItem);
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
}
