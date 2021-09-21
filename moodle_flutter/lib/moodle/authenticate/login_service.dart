import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'dart:convert';

class LoginResponse {
  final String token;
  final String privateToken;

  LoginResponse._fromJson(Map<String, dynamic> json)
      : token = json['token'],
        privateToken = json['privateToken'];
}

var logger = Logger();

class LoginRequest {
  final String _host = AppContext.ENVIRONMENT.HOST;
  final String _hostService = AppContext.ENVIRONMENT.HOST_SERVICE;

  final String _username;
  final String _password;

  LoginRequest(this._username, this._password);

  Future<LoginResponse> fetch() async {
    String url = '/login/token.php';
    var query = {'username': _username,
      'password': _password,
      'service' : _hostService};

    final http.Response response = await http.post(Uri.http(_host, url, query));

    logger.i("Call API: " + response.request.toString());

    if (response.statusCode == 200) {
      logger.d(response.body);
      try {
        logger.d(jsonDecode(response.body));
        return fromJson(jsonDecode(response.body));
      } on Exception catch (e) {
        logger.e(e);
        return fromJson(new Map<String,dynamic>());
      }
    } else {
      logger.e(response.reasonPhrase);
      throw Exception('Failed to fetch api');
    }
  }

  LoginResponse fromJson(data) {
    var loginResponse = LoginResponse._fromJson(data);
    logger.d(loginResponse);
    AppContext.setUserContext(_username, _password, loginResponse.token);
    // MoodleSession.getMoodleSession(_username, _password);
    return loginResponse;
  }
}
