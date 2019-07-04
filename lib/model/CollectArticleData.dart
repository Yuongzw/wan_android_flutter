import 'dart:convert' show json;

class CollectArticleData {

  int errorCode;
  String errorMsg;
  DataBean data;

  CollectArticleData.fromParams({this.errorCode, this.errorMsg, this.data});

  factory CollectArticleData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CollectArticleData.fromJson(json.decode(jsonStr)) : new CollectArticleData.fromJson(jsonStr);

  CollectArticleData.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : new DataBean.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data": $data}';
  }
}

class DataBean {

  int curPage;
  int offset;
  int pageCount;
  int size;
  int total;
  bool over;
  List<ArticleBean> datas;

  DataBean.fromParams({this.curPage, this.offset, this.pageCount, this.size, this.total, this.over, this.datas});

  DataBean.fromJson(jsonRes) {
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
  int originId;
  int publishTime;
  int userId;
  int visible;
  int zan;
  String author;
  String chapterName;
  String desc;
  String envelopePic;
  String link;
  String niceDate;
  String origin;
  String title;

  ArticleBean.fromParams({this.chapterId, this.courseId, this.id, this.originId, this.publishTime, this.userId, this.visible, this.zan, this.author, this.chapterName, this.desc, this.envelopePic, this.link, this.niceDate, this.origin, this.title});

  ArticleBean.fromJson(jsonRes) {
    chapterId = jsonRes['chapterId'];
    courseId = jsonRes['courseId'];
    id = jsonRes['id'];
    originId = jsonRes['originId'];
    publishTime = jsonRes['publishTime'];
    userId = jsonRes['userId'];
    visible = jsonRes['visible'];
    zan = jsonRes['zan'];
    author = jsonRes['author'];
    chapterName = jsonRes['chapterName'];
    desc = jsonRes['desc'];
    envelopePic = jsonRes['envelopePic'];
    link = jsonRes['link'];
    niceDate = jsonRes['niceDate'];
    origin = jsonRes['origin'];
    title = jsonRes['title'];
  }

  @override
  String toString() {
    return '{"chapterId": $chapterId,"courseId": $courseId,"id": $id,"originId": ${origin != null?'${json.encode(origin)}':'null'}Id,"publishTime": $publishTime,"userId": $userId,"visible": $visible,"zan": $zan,"author": ${author != null?'${json.encode(author)}':'null'},"chapterName": ${chapterName != null?'${json.encode(chapterName)}':'null'},"desc": ${desc != null?'${json.encode(desc)}':'null'},"envelopePic": ${envelopePic != null?'${json.encode(envelopePic)}':'null'},"link": ${link != null?'${json.encode(link)}':'null'},"niceDate": ${niceDate != null?'${json.encode(niceDate)}':'null'},"origin": ${origin != null?'${json.encode(origin)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
  }
}

