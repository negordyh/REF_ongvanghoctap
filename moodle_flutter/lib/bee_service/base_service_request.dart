import 'package:http/http.dart' as http;
import 'package:moodle_flutter/utils/app_context.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

var logger = Logger();

class HttpMethod {
  static const String GET = "GET";
  static const String POST = "POST";
  static const String PUT = "PUT";
  static const String DELETE = "DELETE";
}

class BaseServiceRequest {
  static String _host = AppContext.ENVIRONMENT.BEE_SERVICE_URL;

  static Future<dynamic> fetch(String _method, String _serviceUrl,
  {Map<String, dynamic> requestData, Function func}) async {
    String url = _host + _serviceUrl;
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    http.Response response;
    logger.i("Call API: $_method: $url");
    if (requestData != null) logger.d("Request data: ${requestData}");

    if (_method == HttpMethod.GET) {
      response = await http.get(Uri.parse(url), headers: header);
    } else if (_method == HttpMethod.POST) {
      if (requestData == null || requestData.isEmpty) {
        response = await http.post(Uri.parse(url), headers: header);
      } else {
        response = await http.post(Uri.parse(url),
            body: jsonEncode(TranferData(appData: requestData).toJson()), headers: header);
      }
    } else if (_method == HttpMethod.PUT) {
      if (requestData == null || requestData.isEmpty) {
        response = await http.put(Uri.parse(url), headers: header);
      } else {
        response = await http.put(Uri.parse(url),
            body: jsonEncode(TranferData(appData: requestData).toJson()), headers: header);
      }
    } else if (_method == HttpMethod.DELETE) {
      response = await http.post(Uri.parse(url), headers: header);
    } else {
      throw Exception("Method invalid");
    }

    if (response.statusCode == 200) {
      logger.d("Response Body: ${response.body}");
      TranferData resData = TranferData.fromJson(jsonDecode(response.body));
      if (resData.hasError) {
        logger.e("Error msg: ${resData.message}");
        return null;
      } else {
        if (func != null) func(resData.appData);
        return resData.appData;
      }
    } else {
      logger.e("Error msg: ${response.reasonPhrase}; Status code: ${response.statusCode}");
      throw Exception(response.reasonPhrase);
    }
  }
}

class TranferData {
  final dynamic appData;
  final String message;
  final bool hasError;

  TranferData({this.message, this.hasError, this.appData});
  TranferData.fromJson(Map<String, dynamic> json)
      : appData = json['appData'],
        message = json['message'],
        hasError = json['hasError'];

  Map<String, dynamic> toJson() {
    return {"appData": appData};
  }
}
