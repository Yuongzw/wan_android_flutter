import 'dart:convert' show json;

class HotKeyData {

  int errorCode;
  String errorMsg;
  List<HotKeyBean> data;

  HotKeyData.fromParams({this.errorCode, this.errorMsg, this.data});

  factory HotKeyData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new HotKeyData.fromJson(json.decode(jsonStr)) : new HotKeyData.fromJson(jsonStr);

  HotKeyData.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
      data.add(dataItem == null ? null : new HotKeyBean.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data": $data}';
  }
}

class HotKeyBean {

  int id;
  int order;
  int visible;
  String link;
  String name;

  HotKeyBean.fromParams({this.id, this.order, this.visible, this.link, this.name});

  HotKeyBean.fromJson(jsonRes) {
    id = jsonRes['id'];
    order = jsonRes['order'];
    visible = jsonRes['visible'];
    link = jsonRes['link'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"id": $id,"order": $order,"visible": $visible,"link": ${link != null?'${json.encode(link)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}

class SearchResultData {

  int errorCode;
  String errorMsg;
  ArticleDatas data;

  SearchResultData.fromParams({this.errorCode, this.errorMsg, this.data});

  factory SearchResultData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SearchResultData.fromJson(json.decode(jsonStr)) : new SearchResultData.fromJson(jsonStr);

  SearchResultData.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : new ArticleDatas.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data": $data}';
  }
}

class ArticleDatas {

  int curPage;
  int offset;
  int pageCount;
  int size;
  int total;
  bool over;
  List<ArticleBean> datas;

  ArticleDatas.fromParams({this.curPage, this.offset, this.pageCount, this.size, this.total, this.over, this.datas});

  ArticleDatas.fromJson(jsonRes) {
    curPage = jsonRes['curPage'];
    offset = jsonRes['offset'];
    pageCount = jsonRes['pageCount'];
    size = jsonRes['size'];
    total = jsonRes['total'];
    over = jsonRes['over'];
    datas = jsonRes['datas'] == null ? null : [];

    for (var datasItem in datas == null ? [] : jsonRes['datas']){
      datas.add(datasItem == null ? null : new ArticleBean.fromJson(datasItem));
    }
  }

  @override
  String toString() {
    return '{"curPage": $curPage,"offset": $offset,"pageCount": $pageCount,"size": $size,"total": $total,"over": $over,"datas": $datas}';
  }
}

class ArticleBean {

  int chapterId;
  int courseId;
  int id;
  int publishTime;
  int superChapterId;
  int type;
  int userId;
  int visible;
  int zan;
  bool collect;
  bool fresh;
  String apkLink;
  String author;
  String chapterName;
  String desc;
  String envelopePic;
  String link;
  String niceDate;
  String origin;
  String prefix;
  String projectLink;
  String superChapterName;
  String title;
  List<dynamic> tags;

  ArticleBean.fromParams({this.chapterId, this.courseId, this.id, this.publishTime, this.superChapterId, this.type, this.userId, this.visible, this.zan, this.collect, this.fresh, this.apkLink, this.author, this.chapterName, this.desc, this.envelopePic, this.link, this.niceDate, this.origin, this.prefix, this.projectLink, this.superChapterName, this.title, this.tags});

  ArticleBean.fromJson(jsonRes) {
    chapterId = jsonRes['chapterId'];
    courseId = jsonRes['courseId'];
    id = jsonRes['id'];
    publishTime = jsonRes['publishTime'];
    superChapterId = jsonRes['superChapterId'];
    type = jsonRes['type'];
    userId = jsonRes['userId'];
    visible = jsonRes['visible'];
    zan = jsonRes['zan'];
    collect = jsonRes['collect'];
    fresh = jsonRes['fresh'];
    apkLink = jsonRes['apkLink'];
    author = jsonRes['author'];
    chapterName = jsonRes['chapterName'];
    desc = jsonRes['desc'];
    envelopePic = jsonRes['envelopePic'];
    link = jsonRes['link'];
    niceDate = jsonRes['niceDate'];
    origin = jsonRes['origin'];
    prefix = jsonRes['prefix'];
    projectLink = jsonRes['projectLink'];
    superChapterName = jsonRes['superChapterName'];
    title = jsonRes['title'];
    tags = jsonRes['tags'] == null ? null : [];

    for (var tagsItem in tags == null ? [] : jsonRes['tags']){
      tags.add(tagsItem);
    }
  }

  @override
  String toString() {
    return '{"chapterId": $chapterId,"courseId": $courseId,"id": $id,"publishTime": $publishTime,"superChapterId": $superChapterId,"type": $type,"userId": $userId,"visible": $visible,"zan": $zan,"collect": $collect,"fresh": $fresh,"apkLink": ${apkLink != null?'${json.encode(apkLink)}':'null'},"author": ${author != null?'${json.encode(author)}':'null'},"chapterName": ${chapterName != null?'${json.encode(chapterName)}':'null'},"desc": ${desc != null?'${json.encode(desc)}':'null'},"envelopePic": ${envelopePic != null?'${json.encode(envelopePic)}':'null'},"link": ${link != null?'${json.encode(link)}':'null'},"niceDate": ${niceDate != null?'${json.encode(niceDate)}':'null'},"origin": ${origin != null?'${json.encode(origin)}':'null'},"prefix": ${prefix != null?'${json.encode(prefix)}':'null'},"projectLink": ${projectLink != null?'${json.encode(projectLink)}':'null'},"superChapterName": ${superChapterName != null?'${json.encode(superChapterName)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"tags": $tags}';
  }
}



