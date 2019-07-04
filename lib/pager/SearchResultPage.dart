import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:wan_android_flutter/model/SearchData.dart';
import 'package:wan_android_flutter/pager/WebView_Page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wan_android_flutter/utils/MyConstants.dart';
import 'package:wan_android_flutter/pager/LoginPage.dart';
import 'package:wan_android_flutter/model/WanAndroidResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchResultPage extends StatefulWidget {
  String keyWord;

  SearchResultPage({Key key, this.keyWord}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchResultPageState();
  }
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<ArticleBean> articles = List();
  ScrollController _loadMore = new ScrollController(); //加载更多
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMore.addListener(() {
      if (_loadMore.position.pixels == _loadMore.position.maxScrollExtent) {
        _currentPage++;
        _getArticleData(_currentPage, widget.keyWord);
      }
    });
    _getArticleData(_currentPage, widget.keyWord);
  }

  @override
  void dispose() {
    _loadMore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.keyWord,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: articles.length > 0 ? RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
              itemCount: articles.length,
              controller: _loadMore,
              itemBuilder: (context, index) {
                return createArticleItem(articles[index]);
              })) : _buildProgressIndicator()
    );
  }

  Widget createArticleItem(ArticleBean article) {
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
                  child: RichText(
                    text: new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                            text: article.title.split(
                                "<em class='highlight'>${widget.keyWord}</em>")[0]
                                .replaceAll("&ldquo;", "").replaceAll("&rdquo;", "")),
                        new TextSpan(
                          text: widget.keyWord,
                          style: new TextStyle(
                              color: Colors.redAccent, fontSize: 18),
                        ),
                        new TextSpan(
                            text: article.title.split(
                                "<em class='highlight'>${widget.keyWord}</em>")[1]
                                .replaceAll("&ldquo;", "").replaceAll("&rdquo;", ""))
                      ],
                    ),
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
          style: TextStyle(
              fontSize: 16,
              color: Colors.black
          ),
        )
      ],
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
    _getArticleData(_currentPage, widget.keyWord);
  }

  void _getArticleData(int currentPage, String keyWord) async {
    Response response =
        await WanAndroidApiManager().getSearchArticleData(currentPage, keyWord);
    var searchResultData = SearchResultData.fromJson(response.data);
    setState(() {
      articles.addAll(searchResultData.data.datas);
    });
  }
}
