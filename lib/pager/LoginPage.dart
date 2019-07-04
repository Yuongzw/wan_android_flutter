import 'package:flutter/material.dart';
import 'package:wan_android_flutter/api/WanAndroidApi.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/model/LoginRegisterData.dart';
import 'package:wan_android_flutter/utils/MyConstants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wan_android_flutter/widget/LoadingDialog.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email,
      _password,
      _title = "Login",
      _haveAccount = '没有账号？',
      _Change = '去注册';
  bool _isObscure = true,
      _visible = true;
  Color _eyeColor;
  TextEditingController _userNameEditingController = new TextEditingController();
  TextEditingController _passWordEditingController = new TextEditingController();
  TextEditingController _rePassWordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 70.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                new Offstage(
                  offstage: _visible, //false是显示，true是隐藏
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      buildRePasswordTextField(context)
                    ],
                  ),
                ),
                buildRegisterText(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
//                buildOtherLoginText(),
//                buildOtherMethod(context),
              ],
            )));
  }


  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            _title,
            style: Theme
                .of(context)
                .primaryTextTheme
                .headline,
          ),
          color: Colors.black,
          onPressed: () {
//            if (_formKey.currentState.validate()) {
//              ///只有输入的内容符合要求通过才会到达此处
//              _formKey.currentState.save();
//              //TODO 执行登录方法
//              print('email:$_email , assword:$_password');
//            }
            if(_userNameEditingController.text == "") {
              Fluttertoast.showToast(
                  msg: '用户名不能为空！',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white);
              return;
            }
            if(_passWordEditingController.text == "") {
              Fluttertoast.showToast(
                  msg: '密码不能为空！',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white);
              return;
            }
            if (_title == "Login") {
              login(_userNameEditingController.text,
                  _passWordEditingController.text);
            } else {
              if(_rePassWordEditingController.text == "") {
                Fluttertoast.showToast(
                    msg: '确认密码不能为空！',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black45,
                    textColor: Colors.white);
                return;
              }
              if(_rePassWordEditingController.text != _passWordEditingController.text) {
                Fluttertoast.showToast(
                    msg: '两次输入的密码不一致！',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black45,
                    textColor: Colors.white);
                return;
              }
              register(_userNameEditingController.text,
                  _passWordEditingController.text,
                  _rePassWordEditingController.text);
            }
            showDialog<Null>(
                context: context, //BuildContext对象
                barrierDismissible: false,//是否点击外部隐藏
                builder: (BuildContext context) {
                  return new LoadingDialog( //调用对话框
                    text: '正在登录...',
                  );
                });
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(_haveAccount),
            GestureDetector(
              child: Text(
                _Change,
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                setState(() {
                  if (_haveAccount == '没有账号？') {
                    _haveAccount = "已有账号？";
                    _Change = "去登录";
                    _title = 'Register';
                  } else {
                    _haveAccount = "没有账号？";
                    _Change = "去注册";
                    _title = 'Login';
                  }
                  _visible = !_visible;
                });
//                print('去注册');
//                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: new Border.all(
            color: Colors.blueAccent, width: 0.5),
        // 边色与边宽度
        color: Colors.white70,
        // 底色,
        borderRadius: new BorderRadius.circular((5.0)), // 圆角度
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              obscureText: true, //是否是隐藏文本（密码形式）。
              controller: _passWordEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: '请输入密码',
                border: InputBorder.none,
              ),
              autofocus: false,
            ),
          ),
          Offstage(
            offstage: _passWordEditingController.text.length > 0 ? false : true,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey,
              ),
              onPressed: () {
                _passWordEditingController.clear();
              },
            ),
          ),
        ],
      ),
    );


//    return TextFormField(
//      onSaved: (String value) => _password = value,
//      obscureText: _isObscure,
//      validator: (String value) {
//        if (value.isEmpty) {
//          return '请输入密码';
//        }
//      },
//      decoration: InputDecoration(
//          labelText: 'Password',
//          suffixIcon: IconButton(
//              icon: Icon(
//                Icons.remove_red_eye,
//                color: _eyeColor,
//              ),
//              onPressed: () {
//                setState(() {
//                  _isObscure = !_isObscure;
//                  _eyeColor = _isObscure
//                      ? Colors.grey
//                      : Theme.of(context).iconTheme.color;
//                });
//              })),
//    );
  }

  Widget buildRePasswordTextField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: new Border.all(
            color: Colors.blueAccent, width: 0.5),
        // 边色与边宽度
        color: Colors.white70,
        // 底色,
        borderRadius: new BorderRadius.circular((5.0)), // 圆角度
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              obscureText: true, //是否是隐藏文本（密码形式）。
              controller: _rePassWordEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: '请输入确认密码',
                border: InputBorder.none,
              ),
              autofocus: false,
            ),
          ),
          Offstage(
            offstage: _rePassWordEditingController.text.length > 0 ? false : true,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey,
              ),
              onPressed: () {
                _rePassWordEditingController.clear();
              },
            ),
          ),
        ],
      ),
    );

//    return TextFormField(
//      onSaved: (String value) => _password = value,
//      obscureText: _isObscure,
//      validator: (String value) {
//        if (value.isEmpty) {
//          return '请输入确认密码';
//        }
//      },
//      decoration: InputDecoration(
//          labelText: 'RePassword',
//          suffixIcon: IconButton(
//              icon: Icon(
//                Icons.remove_red_eye,
//                color: _eyeColor,
//              ),
//              onPressed: () {
//                setState(() {
//                  _isObscure = !_isObscure;
//                  _eyeColor = _isObscure
//                      ? Colors.grey
//                      : Theme.of(context).iconTheme.color;
//                });
//              })),
//    );
  }

  Widget buildEmailTextField() {
    return Container(
      decoration: BoxDecoration(
        border: new Border.all(
            color: Colors.blueAccent, width: 0.5),
        // 边色与边宽度
        color: Colors.white70,
        // 底色,
        borderRadius: new BorderRadius.circular((5.0)), // 圆角度
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _userNameEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: '请输入用户名',
                border: InputBorder.none,
              ),
              autofocus: false,
            ),
          ),
          Offstage(
            offstage: _userNameEditingController.text.length > 0 ? false : true,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey,
              ),
              onPressed: () {
                _userNameEditingController.clear();
              },
            ),
          ),
        ],
      ),
    );
//      TextFormField(
//      decoration: InputDecoration(
//        labelText: 'User Name',
//      ),
//      validator: (String value) {
//        var emailReg = RegExp(
//            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
//        if (!emailReg.hasMatch(value)) {
//          return '请输入正确的邮箱地址';
//        }
////        if (value.isEmpty) {
////          return '请输入用户名';
////        }
//      },
//      onSaved: (String value) => _email = value,
//    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        _title,
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }

  void login(String username, String password) async {
    Response response = await WanAndroidApiManager().login(username, password);
    var loginRegister = LoginRegister.fromJson(response.data);
    if (loginRegister.errorCode == 0) {
      Fluttertoast.showToast(
          msg: '登录成功！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white);
      MyConstants.isLogin = true;
      MyConstants.myCollectId.addAll(loginRegister.data.collectIds);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg:loginRegister.errorMsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white);
    }

  }

  void register(String username, String password, String repassword) async {
    Response response = await WanAndroidApiManager().register(
        username, password, repassword);
    var loginRegister = LoginRegister.fromJson(response.data);
    if (loginRegister.errorCode == 0) {
      login(username, password);
    } else {
      Fluttertoast.showToast(
          msg: loginRegister.errorMsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white);
    }
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
}
