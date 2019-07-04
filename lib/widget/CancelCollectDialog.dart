import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:wan_android_flutter/model/WanAndroidResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CancelCollectDialog extends Dialog {
  int id, originId;

  CancelCollectDialog({Key key, @required this.id, @required this.originId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 240.0,
          height: 160.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '取消收藏',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: new Text(
                    '确定要取消收藏该文章吗？',
                    style: new TextStyle(fontSize: 14.0),
                  ),
                ),
                new Padding(padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child:   Row(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      width: 100.0,
                      child: RaisedButton(
                        child: Text(
                          "确定",
                          style: Theme
                              .of(context)
                              .primaryTextTheme
                              .button,
                        ),
                        color: Colors.blueGrey,
                        onPressed: () {
                          cancelCollect(id, originId, context);
                        },
                        shape: StadiumBorder(side: BorderSide()),
                      ),
                    ),
                    Container(
                      width: 15,
                    ),
                    SizedBox(
                      height: 40.0,
                      width: 100.0,
                      child: RaisedButton(
                        child: Text(
                          "取消",
                          style: Theme
                              .of(context)
                              .primaryTextTheme
                              .button,
                        ),
                        color: Colors.blueGrey,
                        onPressed: () {
                          Navigator.pop(context, '取消');
                        },
                        shape: StadiumBorder(side: BorderSide()),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cancelCollect(int id, int originId, BuildContext context) async {
      Response response = await WanAndroidApiManager().cancelCollected1(id, originId);
      var wanAndroidResponse = WanAndroidResponse.fromJson(response.data);
      if(wanAndroidResponse.errorCode == 0) {
        Fluttertoast.showToast(
            msg: '取消收藏成功！',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white);
        Navigator.pop(context, '成功');
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
