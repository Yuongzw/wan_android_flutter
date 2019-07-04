import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'dart:io';

class WanAndroidApiManager {
  Dio _dio;

  static WanAndroidApiManager _instance;

  static WanAndroidApiManager get instance => _getInstance();

  factory WanAndroidApiManager() => _getInstance();

  static WanAndroidApiManager _getInstance() {
    if (_instance == null) {
      _instance = new WanAndroidApiManager._internal();
    }
    return _instance;
  }

  WanAndroidApiManager._internal() {
    //初始化
    var option = BaseOptions(
      baseUrl: "https://www.wanandroid.com/",
      connectTimeout: 10000,
      receiveTimeout: 20000,
      //Http请求头.
      headers: {
        //do something
        "version": "1.0.0"
      },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: ContentType.json,
      //表示期望以那种格式(方式)接受响应数据。接受三种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    _dio = new Dio(option);

    //Cookie管理
    _dio.interceptors.add(CookieManager(CookieJar()));

    //添加拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("请求之前");
      // Do something before request is sent
      return options; //continue
    }, onResponse: (Response response) {
      print("响应之前");
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) {
      print("错误之前");
      // Do something with response error
      return e; //continue
    }));
  }

  //获取首页文章列表
  Future<Response> getHomeArticleData(int page) async {
    Response response = null;
    try {
      response = await _dio.get("article/list/$page/json");
    } catch (e) {
      print("getHomeArticleData ==>" + e.toString());
    }
    return response;
  }

  //获取首页Banner
  Future<Response> getHomeBannerData() async {
    Response response = null;
    try {
      response = await _dio.get("banner/json");
    } catch (e) {
      print("getHomeBannerData ==>" + e.toString());
    }
    return response;
  }

  //获取体系数据
  Future<Response> getTreeData() async {
    Response response = null;
    try {
      response = await _dio.get("tree/json");
    } catch (e) {
      print("getTreeData ==>" + e.toString());
    }
    return response;
  }

  //获取体系文章
  Future<Response> getTreeArticleData(int page, int cid) async {
    Response response = null;
    try {
      response = await _dio.get("article/list/$page/json?cid=$cid");
    } catch (e) {
      print("getTreeArticleData ==>" + e.toString());
    }
    return response;
  }

  //获取公众号列表
  Future<Response> getWeChatListData() async {
    Response response = null;
    try {
      response = await _dio.get("wxarticle/chapters/json");
    } catch (e) {
      print("getWeChatListData ==>" + e.toString());
    }
    return response;
  }

  //获取公众号文章
  Future<Response> getWeChatArticleData(int id, int currentPage) async {
    Response response = null;
    try {
      response = await _dio.get("wxarticle/list/$id/$currentPage/json");
    } catch (e) {
      print("getWeChatArticleData ==>" + e.toString());
    }
    return response;
  }

  //获取项目标题
  Future<Response> getProjectTabData() async {
    Response response = null;
    try {
      response = await _dio.get("project/tree/json");
    } catch (e) {
      print("getProjectTabData ==>" + e.toString());
    }
    return response;
  }

  //获取项目文章
  Future<Response> getProjectArticleData(int page, int cid) async {
    Response response = null;
    try {
      response = await _dio.get("project/list/$page/json?cid=$cid");
    } catch (e) {
      print("getProjectArticleData ==>" + e.toString());
    }
    return response;
  }

  //获取热搜关键字
  Future<Response> getHotKeyData() async {
    Response response;
    try {
      response = await _dio.get("hotkey/json");
    } catch (e) {
      print("getHotKeyData ==>" + e.toString());
    }
    return response;
  }

  //获取搜索的文章
  Future<Response> getSearchArticleData(int page, String keyWords) async {
    Response response;
    try {
      FormData formData = FormData.from({"k": keyWords});
      response = await _dio.post("article/query/${page}/json", data: formData);
    } catch (e) {
      print("getSearchArticleData ==>" + e.toString());
    }
    return response;
  }

  //登录
  Future<Response> login(String username, String password) async {
    Response response;
    try {
      FormData formData =
          FormData.from({"username": username, "password": password});
      response = await _dio.post("user/login", data: formData);
    } catch (e) {
      formatError(e);
    }
    return response;
  }

  //注册
  Future<Response> register(
      String username, String password, String repassword) async {
    Response response;
    try {
      FormData formData = FormData.from({
        "username": username,
        "password": password,
        "repassword": repassword
      });
      response = await _dio.post("user/register", data: formData);
    } catch (e) {
      formatError(e);
    }
    return response;
  }

  //收藏文章
  Future<Response> collectArticle(int id) async {
    Response response;
    try {
      response = await _dio.post("lg/collect/$id/json");
    } catch (e) {
      formatError(e);
    }
    return response;
  }

  //我的收藏页面取消收藏
  Future<Response> cancelCollected1(int id, int originId) async {
    Response response;
    try {
      FormData formData = FormData.from({"originId": originId});
      response = await _dio.post("lg/uncollect/$id/json", data: formData);
    } catch (e) {
      formatError(e);
    }
    return response;
  }

  //其他页面取消收藏
  Future<Response> cancelCollected2(int id) async {
    Response response;
    try {
      response = await _dio.post("lg/uncollect_originId/$id/json");
    } catch (e) {
      formatError(e);
    }
    return response;
  }

  //获取收藏文章
  Future<Response> getCollectArticleData(int page) async{
    Response response;
    try {
      response = await _dio.get("lg/collect/list/$page/json");
    } catch (e) {
      formatError(e);
    }
    return response;
  }

  //获取代办清单
  Future<Response> getTodoListData() async {
    Response response;
    try {
      response = await _dio.get("lg/todo/list/0/json");
    } catch (e) {
      formatError(e);
    }
    return response;
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }
}
