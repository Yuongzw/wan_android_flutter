import 'dart:convert' show json;

class WanAndroidResponse {

  Object data;
  int errorCode;
  String errorMsg;

  WanAndroidResponse.fromParams({this.data, this.errorCode, this.errorMsg});

  factory WanAndroidResponse(jsonStr) => jsonStr == null ? null : jsonStr is String ? new WanAndroidResponse.fromJson(json.decode(jsonStr)) : new WanAndroidResponse.fromJson(jsonStr);

  WanAndroidResponse.fromJson(jsonRes) {
    data = jsonRes['data'];
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
  }

  @override
  String toString() {
    return '{"data": $data,"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'}}';
  }
}

