import 'package:logger/logger.dart';
import 'package:moodle_flutter/moodle/base_request.dart';

final String _funcName = "core_user_create_users";

class SignupResponse {
  final int id;
  final String username;

  SignupResponse._fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        username = json['username'];
}

var logger = Logger();

class SignUpRequest extends BaseRequest{
  final String _pwd;
  final String _userName;

  SignUpRequest(this._userName, this._pwd) : super(_funcName) {
    super.requestData['users[0][username]'] = _userName;
    super.requestData['users[0][password]'] = _pwd;
    super.requestData['users[0][firstname]'] = _userName;
    super.requestData['users[0][lastname]'] = _userName;
    super.requestData['users[0][email]'] = !_userName.contains("@") ? "phone." + _userName + "@gmail.com" : _userName;
  }

  @override
  SignupResponse fromJson(data) {
    return SignupResponse._fromJson((data as List).first);
  }

}
