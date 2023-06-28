import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class RecipePage extends StatefulWidget {
  String url;
  RecipePage(this.url);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late String finalUrl;
  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if(widget.url.toString().contains("http://"))
      {
        finalUrl = widget.url.toString().replaceAll("http://", "https://");
      }
    else
      {
        finalUrl = widget.url;
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('My Recipe App'),
        backgroundColor: Color(0xff071938),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(finalUrl)
            ),
            onWebViewCreated: (InAppWebViewController controller){
              webView = controller;
            },
            onProgressChanged: (InAppWebViewController controller, int progress){
              setState(() {
                _progress = progress/100;
              });
            },
          )
        ],
      )
    );
  }
}


