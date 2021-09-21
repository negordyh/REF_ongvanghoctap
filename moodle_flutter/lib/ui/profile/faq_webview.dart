import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_contents.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FAQWebview extends StatefulWidget {
  final String _url;
  FAQWebview(this._url);

  @override
  createState() => _FAQWebviewState();
}

class _FAQWebviewState extends State<FAQWebview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    Map<String, String> header = {'Cookie': '${AppContext.user.moodleSession}'};

    _controller.future.then((controller) {
      _webViewController = controller;
      _webViewController.loadUrl(widget._url, headers: header);
    });
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFFE8ECF0),
        appBar: AppBarCustom(
          size: size,
          title: "FAQ",
          image: "assets/images/sinh-hoc.jpg",
        ),
        body: WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: ((String url) => {
                  logger.i("Start URL: + $url"),
                }),
            onPageFinished: ((String url) => {
                  logger.i("finish URL: + $url"),
                })));
  }
}
