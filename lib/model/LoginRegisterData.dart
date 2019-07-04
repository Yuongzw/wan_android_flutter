import 'dart:convert' show json;

class LoginRegister {

  int errorCode;
  String errorMsg;
  DataBean data;

  LoginRegister.fromParams({this.errorCode, this.errorMsg, this.data});

  factory LoginRegister(jsonStr) => jsonStr == null ? null : jsonStr is String ? new LoginRegister.fromJson(json.decode(jsonStr)) : new LoginRegister.fromJson(jsonStr);

  LoginRegister.fromJson(jsonRes) {
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

  int id;
  int type;
  bool admin;
  String email;
  String icon;
  String nickname;
  String password;
  String token;
  String username;
  List<dynamic> chapterTops;
  List<int> collectIds;

  DataBean.fromParams({this.id, this.type, this.admin, this.email, this.icon, this.nickname, this.password, this.token, this.username, this.chapterTops, this.collectIds});

  DataBean.fromJson(jsonRes) {
    id = jsonRes['id'];
    type = jsonRes['type'];
    admin = jsonRes['admin'];
    email = jsonRes['email'];
    icon = jsonRes['icon'];
    nickname = jsonRes['nickname'];
    password = jsonRes['password'];
    token = jsonRes['token'];
    username = jsonRes['username'];
    chapterTops = jsonRes['chapterTops'] == null ? null : [];

    for (var chapterTopsItem in chapterTops == null ? [] : jsonRes['chapterTops']){
      chapterTops.add(chapterTopsItem);
    }

    collectIds = jsonRes['collectIds'] == null ? null : [];

    for (var collectIdsItem in collectIds == null ? [] : jsonRes['collectIds']){
      collectIds.add(collectIdsItem);
    }
  }

  @override
  String toString() {
    return '{"id": $id,"type": $type,"admin": $admin,"email": ${email != null?'${json.encode(email)}':'null'},"icon": ${icon != null?'${json.encode(icon)}':'null'},"nickname": ${nickname != null?'${json.encode(nickname)}':'null'},"password": ${password != null?'${json.encode(password)}':'null'},"token": ${token != null?'${json.encode(token)}':'null'},"username": ${username != null?'${json.encode(username)}':'null'},"chapterTops": $chapterTops,"collectIds": $collectIds}';
  }
}

