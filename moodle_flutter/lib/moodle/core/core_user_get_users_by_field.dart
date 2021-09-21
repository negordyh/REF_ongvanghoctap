import 'package:logger/logger.dart';
import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/utils/app_context.dart';

final String _funcName = "core_user_get_users_by_field";

var logger = Logger();

class CoreUserGetUserByFieldResponse {
  final int id;
  final String username ;
  final String fullName;
  final String email;
  final String phone1;

  CoreUserGetUserByFieldResponse({this.id,this.phone1,this.email,this.fullName,this.username});

  CoreUserGetUserByFieldResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'.toLowerCase()] ?? "",
        username = json['username'] ?? "",
        email = json['email'] ?? '',
        phone1 = json['phone1'] ?? '';

  static Map<String, dynamic> toMap(CoreUserGetUserByFieldResponse instance) => {
    'id': instance.id,
    'fullName'.toLowerCase(): instance.fullName,
    'username': instance.username,
    'email': instance.email,
    'phone1': instance.phone1
  };
}

class CoreUserGetUserByFieldRequest extends BaseRequest<CoreUserGetUserByFieldResponse> {

  CoreUserGetUserByFieldRequest() : super(_funcName) {
    super.requestData['field'] = "username";
    super.requestData['values[0]'] = AppContext.user.username;
  }

  @override
  CoreUserGetUserByFieldResponse fromJson(data) {
    return CoreUserGetUserByFieldResponse.fromJson((data as List).first);
  }
}