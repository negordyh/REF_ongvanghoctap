import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

var logger = Logger();

class MoodleSession {
  static Future<void> getMoodleSession(
      String _username, String _password) async {
    String _host = AppContext.ENVIRONMENT.HOST;
    String url = '$_host/login/index.php';
    String cookie = "";
    var isRedirect = true;

    while (isRedirect) {
      final client = http.Client();
      var request = http.Request('GET', Uri.parse(url))
        ..followRedirects = false
        ..headers['Cookie'] = cookie;
      logger.i("Call API: " + request.toString());
      var response = await client.send(request);
      isRedirect = response.isRedirect;
      logger.d(response.headers);
      logger.i(response.statusCode);

      if (response.statusCode == HttpStatus.movedTemporarily ||
          response.statusCode == HttpStatus.seeOther) {
        url = response.headers[HttpHeaders.locationHeader];
        cookie = response.headers[HttpHeaders.setCookieHeader];
      } else if (response.statusCode == HttpStatus.ok) {
        String pattern_auth = '<input type="hidden" name="logintoken" value="';
        String bodyResponse = await response.stream.bytesToString();
        if (bodyResponse.contains(pattern_auth)) {
          int startIndex =
              bodyResponse.indexOf(pattern_auth) + pattern_auth.length;
          String loginToken =
              bodyResponse.substring(startIndex, startIndex + 32);
          logger.i(loginToken);

          cookie = response.headers[HttpHeaders.setCookieHeader];
          logger.i(Cookie.fromSetCookieValue(cookie));
          // http.Response response1 = await http.post(url,
          //     body: data,
          //     encoding: Encoding.getByName("utf-8"),
          //     headers: {
          //   HttpHeaders.cookieHeader: '${Cookie.fromSetCookieValue(cookie0)}',
          //   HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded; charset=UTF-8',
          //   HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br'
          // });
          //
          // logger.d(response1.request.headers);
          // logger.d(response1.body);
          // logger.d(response1.headers);
          // response1.headers.forEach((key, value) => {
          //       if (key.toLowerCase().contains(HttpHeaders.setCookieHeader)) cookie = value
          //     });

          var request = http.Request('POST', Uri.parse(url))
            ..bodyFields = {
              'anchor': '',
              'logintoken': loginToken,
              'username': AppContext.user.username,
              'password': AppContext.user.password,
              'rememberusername': '1'
            }
            ..encoding = Encoding.getByName("utf-8")
            ..headers.addAll({
              'Cache-Control': 'max-age=0',
              'Upgrade-Insecure-Requests': '1',
              'Origin': _host,
              'Content-Type': 'application/x-www-form-urlencoded',
              'Cookie': cookie
            });
          response = await request.send();
          logger.d(response.headers);
          logger.d(request.body);
          cookie = response.headers[HttpHeaders.setCookieHeader];

          if (response.statusCode == 200) {
            logger.d(await response.stream.bytesToString());
          } else {
            logger.d(response.reasonPhrase);
          }
        } else if (response.headers.containsKey(HttpHeaders.setCookieHeader)) {
          cookie = response.headers[HttpHeaders.setCookieHeader];
        } else {
          logger.d(bodyResponse);
          throw Exception('Can\'t get Moodle Cookie');
        }

        logger.i(cookie);
        AppContext.setMoodleUserSession(cookie);
      } else {
        logger.d(await response.stream.bytesToString());
        throw Exception('Failed to fetch api');
      }
    }
  }

  static Future<String> getMoodleSessionInWebView(
      String _username, String _password, String loginToken, String cookie) async {
    String _host = AppContext.ENVIRONMENT.HOST;
    String url = '$_host/login/index.php';

    var request = http.Request('POST', Uri.parse(url))
      ..bodyFields = {
        'anchor': '',
        'logintoken': loginToken,
        'username': AppContext.user.username,
        'password': AppContext.user.password,
        'rememberusername': '1'
      }
      ..headers.addAll({'Cookie': cookie});
    var response = await request.send();
    logger.d(request.body);
    logger.d(response.headers);
    cookie = response.headers[HttpHeaders.setCookieHeader];

    if (response.statusCode == 200) {
      // logger.d(await response.stream.bytesToString());
    } else {
      logger.d(response.reasonPhrase);
    }
    AppContext.setMoodleUserSession(cookie);
    return cookie;
  }
}
