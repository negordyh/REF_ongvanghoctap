import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_contents.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:webview_flutter/webview_flutter.dart';

var logger = Logger();
class H5PScreen extends StatefulWidget {
  final Module _module;
  H5PScreen(this._module);

  @override
  createState() => _H5PScreenState();
}

class _H5PScreenState extends State<H5PScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    Map<String, String> header = {'Cookie': '${AppContext.user.moodleSession}'};

    _controller.future.then((controller) {
      _webViewController = controller;
      _webViewController.loadUrl(widget._module.url, headers: header);
    });
    return WebView(
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: ((String url) => {
        logger.i("Start URL: + $url"),
      }),
      onPageFinished: ((String url) => {
        logger.i("finish URL: + $url"),
        if (url.contains("login/index")){
          setSession(_webViewController)
        }
        // _webViewController.scrollTo(x, y)
      })
      // initialUrl: "http://192.168.137.1/moodle/webservice/pluginfile.php/1/core_h5p/export/interactive-video-1-1.h5p?token=ae5354f8a47778ff1d9c3144126b4470"
    );
  }

  void setSession(WebViewController webViewController) async {
    // ------------------------------SET COOKIE -------------------------------
    // String loginToken = await webViewController.evaluateJavascript("window.document.getElementsByTagName('input').logintoken.value");
    // String cookie = await webViewController.evaluateJavascript("window.document.cookie");
    // loginToken = loginToken.replaceAll('"', '');
    // logger.i(loginToken);
    // logger.i(cookie);
    // cookie = await MoodleSession.getMoodleSessionInWebView(AppContext.user.username, AppContext.user.password, loginToken, cookie);
    // if (Platform.isIOS) {
    //   await webViewController.evaluateJavascript("document.cookie = '$cookie'");
    // } else {
    //   AppContext.user.moodleSession.toLowerCase().contains("path")
    //       ? await webViewController.evaluateJavascript('document.cookie = "$cookie"')
    //       : await webViewController.evaluateJavascript('document.cookie = "$cookie; path=/"');
    // }
    // ------------------------------------------------------------------------
    // -------------------------------AUTO LOGIN ------------------------------
    var paternPassWord = await webViewController.evaluateJavascript("window.document.getElementsByTagName('input').password");
    if (paternPassWord != null && paternPassWord.isNotEmpty && paternPassWord != "null") {
      await webViewController.evaluateJavascript(
          "window.document.getElementsByTagName('input').password.value = '${AppContext
              .user.password}'");
      await webViewController.evaluateJavascript(
          "window.document.getElementsByTagName('input').username.value = '${AppContext
              .user.username}'");
      await webViewController.evaluateJavascript(
          "window.document.getElementsByTagName('form').login.submit()");
    }
    // ------------------------------------------------------------------------
  }
}
