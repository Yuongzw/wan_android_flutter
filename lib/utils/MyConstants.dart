
class MyConstants {

  static MyConstants _instance;

  static MyConstants get instance => _getInstance();

  factory MyConstants() => _getInstance();

  static MyConstants _getInstance() {
    if (_instance == null) {
      _instance = new MyConstants();
    }
    return _instance;
  }

  static bool isLogin = false;

  static List<int> myCollectId = List();
}