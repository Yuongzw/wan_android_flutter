import 'package:flutter/material.dart';
import 'package:wan_android_flutter/pager/HomePage.dart';
import 'package:wan_android_flutter/pager/TreePage.dart';
import 'package:wan_android_flutter/pager/WeChatPage.dart';
import 'package:wan_android_flutter/pager/ProjectPage.dart';
import 'package:wan_android_flutter/utils/MyConstants.dart';
import 'package:wan_android_flutter/pager/LoginPage.dart';
import 'package:wan_android_flutter/pager/CollectPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:wan_android_flutter/pager/TodoPage.dart';

class BottomBarNavigator extends StatefulWidget {
  @override
  _BottomBarNavigatorState createState() => _BottomBarNavigatorState();
}

class _BottomBarNavigatorState extends State<BottomBarNavigator> {
  final PageController _pageController = new PageController(initialPage: 0);
  final default_color = Colors.grey;
  final selected_color = Colors.blueAccent;
  DateTime lastPopTime;

  int _current_page = 0;

  void _pageChange(int page) {
    if (_current_page != page) {
      setState(() {
        _current_page = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: new Scaffold(
        drawer: new Drawer(
          //侧滑菜单
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text("小薇识花"),
                accountEmail: Text("flutter@gmail.com"),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: new ExactAssetImage("images/avatar.jpeg"),
                  ),
                ),
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new ExactAssetImage("images/background.jpg"),
                  ),
                ),
              ),
              new ListTile(
                title: new Text("我的收藏"),
                trailing: new Icon(Icons.favorite_border,
                    color: Colors.lightBlueAccent),
                onTap: () {
                  Navigator.of(context).pop();
                  if (!MyConstants.isLogin) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LoginPage()),
                    );
                    return;
                  } else {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new CollectPage()),
                    );
                    return;
                  }
                },
              ),
              new ListTile(
                title: new Text("我的代办"),
                trailing: new Icon(
                  Icons.today,
                  color: Colors.lightBlueAccent,
                ),
                onTap: () {
                  Navigator.of(context).pop();
//                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new TodoPage()));
                },
              ),
              new Divider(),
              new ListTile(
                title: new Text("设置"),
                trailing: new Icon(
                  Icons.settings,
                  color: Colors.lightBlueAccent,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ), //New added
        ), //New add
        body: PageView(
          controller: _pageController,
          onPageChanged: _pageChange,
          children: <Widget>[
            HomePage(),
            TreePage(),
            WeChatPage(),
            ProjectPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current_page,
          type: BottomNavigationBarType.fixed, //将底部的文字都固定显示出来,
          onTap: (page) {
            _pageController.jumpToPage(page); //跳转页面
            setState(() {
              _current_page = page;
            });
          },
          items: [
            new BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: default_color,
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: selected_color,
                ),
                title: Text(
                  '首页',
                  style: TextStyle(
                    color: _current_page != 0 ? default_color : selected_color,
                  ),
                )),
            new BottomNavigationBarItem(
                icon: Icon(
                  IconData(0xe605, fontFamily: 'MyIcons'),
                  color: default_color,
                ),
                activeIcon: Icon(
                  IconData(0xe605, fontFamily: 'MyIcons'),
                  color: selected_color,
                ),
                title: Text(
                  '体系',
                  style: TextStyle(
                    color: _current_page != 1 ? default_color : selected_color,
                  ),
                )),
            new BottomNavigationBarItem(
                icon: Icon(
                  IconData(0xe64b, fontFamily: 'MyIcons'),
                  color: default_color,
                ),
                activeIcon: Icon(
                  IconData(0xe64b, fontFamily: 'MyIcons'),
                  color: selected_color,
                ),
                title: Text(
                  '公众号',
                  style: TextStyle(
                    color: _current_page != 2 ? default_color : selected_color,
                  ),
                )),
            new BottomNavigationBarItem(
                icon: Icon(
                  IconData(0xe64a, fontFamily: 'MyIcons'),
                  color: default_color,
                ),
                activeIcon: Icon(
                  IconData(0xe64a, fontFamily: 'MyIcons'),
                  color: selected_color,
                ),
                title: Text(
                  '项目',
                  style: TextStyle(
                    color: _current_page != 3 ? default_color : selected_color,
                  ),
                )),
          ],
        ),
      ),
      onWillPop: () async {
        print("onWillPop  " + ModalRoute.of(context).isCurrent.toString());
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          Fluttertoast.showToast(
              msg: '再按一次退出！',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white);
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
    );
  }
}
