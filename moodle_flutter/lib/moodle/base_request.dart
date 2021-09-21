import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_flutter/ui/components/alert_error_dialog.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:moodle_flutter/utils/language.dart';

import 'authenticate/login_service.dart';

import 'package:moodle_flutter/utils/share_preferences.dart';

var logger = Logger();

abstract class BaseRequest<T> {
  final String _host = AppContext.ENVIRONMENT.HOST;
  final String _formatApiResponse = AppContext.ENVIRONMENT.FORMAT_API_RESPONSE;

  String _token = AppContext.user.token;

  final Map<String, dynamic> requestData = new Map();

  final String _funcName;

  BaseRequest(this._funcName, [Map<String, dynamic> requestData]) {
    if (requestData != null) this.requestData.addAll(requestData);
  }

  /// mapping moodle api response to app response
  T fromJson(data);

  Future<T> fetch() async {
    String url = '/webservice/rest/server.php';
    Map<String, dynamic> query = {
      'moodleWsRestFormat'.toLowerCase(): _formatApiResponse.toLowerCase(),
      'wsToken'.toLowerCase(): _token.toLowerCase(),
      'wsFunction'.toLowerCase(): _funcName.toLowerCase()};

    query.addAll(requestData.map((key, value) => MapEntry(key, value.toString())));

    final http.Response response =
    await http.post(Uri.http(_host, url, query), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    logger.i("Call func: " + _funcName);
    logger.i("Call API: " + response.request.url.toString());

    if (response.statusCode == 200) {
      logger.d(response .body);
      if(jsonDecode(response.body) is List) {}
      else if (jsonDecode(response.body) != null){
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body.containsKey("errorcode") &&
            body['errorcode'] == 'invalidtoken') {
          var value = await LoginRequest(
              AppContext.user.username, AppContext.user.password).fetch();
          if (value != null) {
            logger.d(value);
            if (value.token != null && value.token.isNotEmpty) {
              SharePrefs.setSessionToken(AppContext.user.username, value.token,
                  AppContext.user.password);
            }
          }
          return this.fetch();
        }
      }
      
      try {
        return fromJson(jsonDecode(response.body));
      } on Exception catch (e) {
        logger.e(e);
        return fromJson(new Map<String,dynamic>());
      }
    } else {
      logger.e(response.reasonPhrase);
      logger.i(response.statusCode);
      if (response.statusCode == 404) {
        showDialog(
          context: null,
          builder: (context) => CustomErrorDialog(
            title: AppLocalizations.of(context).translate('ong_vang'),
            description: AppLocalizations.of(context).translate('description_disconnect_internet'),
          ),
        );
      } else {
        logger.e("status code != 404, 200");
        showDialog(
          context: null,
          builder: (context) => CustomErrorDialog(
            title: AppLocalizations.of(context).translate('ong_vang'),
            description: AppLocalizations.of(context).translate('description_wrong'),
          ),
        );
      }
      throw Exception(response.reasonPhrase);
    }
  }

  Future<T> fetchUsingTokenAdmin() async {
      _token = AppContext.ENVIRONMENT.SERVICCE_AUTHENTICATE_TOKEN;
    return fetch();
  }
}
