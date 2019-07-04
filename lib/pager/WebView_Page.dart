import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  String url = "";
  String title = "";

  WebViewPage({this.title, this.url});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: WebviewScaffold(
        url: widget.url,
        withZoom: false,
        withLocalStorage: true,
        hidden: true,
        withJavascript: true,
      ),
    );
  }
}
