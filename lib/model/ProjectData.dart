import 'dart:convert' show json;

class ProjectData {

  int errorCode;
  String errorMsg;
  List<DataBean> data;

  ProjectData.fromParams({this.errorCode, this.errorMsg, this.data});

  factory ProjectData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ProjectData.fromJson(json.decode(jsonStr)) : new ProjectData.fromJson(jsonStr);

  ProjectData.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
      data.add(dataItem == null ? null : new DataBean.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data": $data}';
  }
}

class DataBean {

  int courseId;
  int id;
  int order;
  int parentChapterId;
  int visible;
  bool userControlSetTop;
  String name;
  List<dynamic> children;

  DataBean.fromParams({this.courseId, this.id, this.order, this.parentChapterId, this.visible, this.userControlSetTop, this.name, this.children});

  DataBean.fromJson(jsonRes) {
    courseId = jsonRes['courseId'];
    id = jsonRes['id'];
    order = jsonRes['order'];
    parentChapterId = jsonRes['parentChapterId'];
    visible = jsonRes['visible'];
    userControlSetTop = jsonRes['userControlSetTop'];
    name = jsonRes['name'];
    children = jsonRes['children'] == null ? null : [];

    for (var childrenItem in children == null ? [] : jsonRes['children']){
      children.add(childrenItem);
    }
  }

  @override
  String toString() {
    return '{"courseId": $courseId,"id": $id,"order": $order,"parentChapterId": $parentChapterId,"visible": $visible,"userControlSetTop": $userControlSetTop,"name": ${name != null?'${json.encode(name)}':'null'},"children": $children}';
  }
}

class ArticleData {

  int errorCode;
  String errorMsg;
  ArticleItem data;

  ArticleData.fromParams({this.errorCode, this.errorMsg, this.data});

  factory ArticleData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ArticleData.fromJson(json.decode(jsonStr)) : new ArticleData.fromJson(jsonStr);

  ArticleData.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : new ArticleItem.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data": $data}';
  }
}

class ArticleItem {

  int curPage;
  int offset;
  int pageCount;
  int size;
  int total;
  bool over;
  List<ArticleBean> datas;

  ArticleItem.fromParams({this.curPage, this.offset, this.pageCount, this.size, this.total, this.over, this.datas});

  ArticleItem.fromJson(jsonRes) {
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
  List<Tag> tags;

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
      tags.add(tagsItem == null ? null : new Tag.fromJson(tagsItem));
    }
  }

  @override
  String toString() {
    return '{"chapterId": $chapterId,"courseId": $courseId,"id": $id,"publishTime": $publishTime,"superChapterId": $superChapterId,"type": $type,"userId": $userId,"visible": $visible,"zan": $zan,"collect": $collect,"fresh": $fresh,"apkLink": ${apkLink != null?'${json.encode(apkLink)}':'null'},"author": $author,"chapterName": ${chapterName != null?'${json.encode(chapterName)}':'null'},"desc": $desc,"envelopePic": ${envelopePic != null?'${json.encode(envelopePic)}':'null'},"link": ${link != null?'${json.encode(link)}':'null'},"niceDate": ${niceDate != null?'${json.encode(niceDate)}':'null'},"origin": ${origin != null?'${json.encode(origin)}':'null'},"prefix": ${prefix != null?'${json.encode(prefix)}':'null'},"projectLink": ${projectLink != null?'${json.encode(projectLink)}':'null'},"superChapterName": ${superChapterName != null?'${json.encode(superChapterName)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"tags": $tags}';
  }
}

class Tag {

  String name;
  String url;

  Tag.fromParams({this.name, this.url});

  Tag.fromJson(jsonRes) {
    name = jsonRes['name'];
    url = jsonRes['url'];
  }

  @override
  String toString() {
    return '{"name": ${name != null?'${json.encode(name)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'}}';
  }
}





