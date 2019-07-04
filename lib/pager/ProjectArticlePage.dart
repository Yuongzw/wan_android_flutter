import 'package:flutter/material.dart';
import 'package:wan_android_flutter/model/ProjectData.dart';
import 'package:wan_android_flutter/widget/ProgressView.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:wan_android_flutter/pager/WebView_Page.dart';
import 'package:wan_android_flutter/utils/MyConstants.dart';
import 'package:wan_android_flutter/pager/LoginPage.dart';
import 'package:wan_android_flutter/model/WanAndroidResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class ProjectArticlePage extends StatefulWidget {
  int id;

  ProjectArticlePage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProjectArticlePageState();
  }
}

class _ProjectArticlePageState extends State<ProjectArticlePage>
    with AutomaticKeepAliveClientMixin {
  List<ArticleBean> articles = List();

  int _currentPage = 1;

  ScrollController _loadMore = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMore.addListener(() {
      // 小于50px时，触发上拉加载；
      if (_loadMore.position.pixels == _loadMore.position.maxScrollExtent) {
        _currentPage++;
        _getProjectArticle(_currentPage);
      }
    });
    _getProjectArticle(_currentPage);
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
          controller: _loadMore,
          itemCount: articles.length,
          itemBuilder: (context, index) {
            if (index < articles.length) {
              return createProjectArticleItem(articles[index]);
            }
          }),
    );

    return new Scaffold(
        body: Stack(children: <Widget>[
      articles.length == 0 ? new ProgressView() : listView,
    ]));
  }

  Widget createProjectArticleItem(ArticleBean article) {
    bool isCollect = false;
    if(MyConstants.myCollectId.contains(article.id)) {
      isCollect = true;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (ctx) =>
                    WebViewPage(title: article.title, url: article.link)));
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 2, 5, 3),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          article.title,
                          maxLines: 1,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          article.desc,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              article.author.length < 10 ? "作者:" + article.author : "作者:" + article.author.substring(0, 10) + "...",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                              TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                  ),
                                  Text(
                                    article.niceDate,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                size: 20,
                                color: isCollect
                                    ? Colors.redAccent
                                    : Colors.grey,
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
                                  setState(() {
                                    isCollect = !isCollect;
                                  });
                                  cancelCollectArticle(article.id);
                                  return;
                                } else {//收藏
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
                  Container(
                    height: 140,
                    width: 80,
                    child: new CachedNetworkImage(
                      placeholder: Image.asset("assets/images/default_project_img.png"),
                      imageUrl: article.envelopePic,
                    ),
//                    Image.network(article.envelopePic),
                  ),
                ],
              ))),
    );
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
      articles.clear();
    });
    _currentPage = 0;
    _getProjectArticle(_currentPage);
  }

  void _getProjectArticle(int currentPage) async {
    Response response = await WanAndroidApiManager()
        .getProjectArticleData(currentPage, widget.id);
    var projectArticle = ArticleData.fromJson(response.data);
    setState(() {
      articles.addAll(projectArticle.data.datas);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
