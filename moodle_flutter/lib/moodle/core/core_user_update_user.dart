import 'package:logger/logger.dart';
import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/moodle/core/core_user_get_users_by_field.dart';
import 'package:moodle_flutter/utils/app_context.dart';

final String _funcName = "core_user_update_users";

var logger = Logger();

class CoreUserUpdateUser {
  final int id;
  final String username ;
  final String fullName;
  final String email;
  final String phone1;

  CoreUserUpdateUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'.toLowerCase()] == null ? json['fullName'.toLowerCase()] : "",
        username = json['username'.toLowerCase()] == null ? json['username'.toLowerCase()] : "",
        email = json['email'] == null ? json['email'] : '',
        phone1 = json['phone1'] == null ? json['phone1'] : '';
}

class CoreUserUpdateUserRequest extends BaseRequest {
  final CoreUserGetUserByFieldResponse user;
  CoreUserUpdateUserRequest(this.user) : super(_funcName) {
    super.requestData['users[0][id]'] = user.id;
    super.requestData['users[0][username]'] = user.username;
    super.requestData['users[0][email]'] = user.email;
    super.requestData['users[0][phone1]'] = user.phone1;
    super.requestData['users[0][firstname]'] = user.fullName.split(" ")[0];
    super.requestData['users[0][lastname]'] = user.fullName.split(" ").length == 2 ? user.fullName.split(" ")[1] : user.fullName.split(" ")[0];
  }

  @override
  dynamic fromJson(data) {
    return data;
  }
}