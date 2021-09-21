import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/utils/app_context.dart';

class LogUser {
  final int id;
  final int userId;
  List<int> coursesRecently;
  List<UserTimeOnApp> userTimeOnAppList;

  LogUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        coursesRecently = json['coursesRecently'].toString().isEmpty
            ? []
            : json['coursesRecently']
                .toString()
                .split("-")
                .map((e) => int.parse(e))
                .toList(),
        userTimeOnAppList = (json['userTimeOnAppList'] as List)
            .map((e) => UserTimeOnApp.fromJson(e)).toList();

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "coursesRecently": coursesRecently.join("-"),
        "userTimeOnAppList": userTimeOnAppList.map((e) => e.toJson()).toList()
      };
}

class UserTimeOnApp {
  final int id;
  final DateTime localDate;
  int timeCount;
  int targetTimeOnApp;

  UserTimeOnApp.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        localDate = DateTime.parse(json['localDate'].toString()),
        timeCount = json['timeCount'],
        targetTimeOnApp = json['targetTimeOnApp'] == "null" ? 0 : json['targetTimeOnApp'] ?? 0;

  Map<String, dynamic> toJson() => {
        "id": id,
        "localDate": localDate.toString().substring(0, 10),
        "timeCount": timeCount,
        "targetTimeOnApp": targetTimeOnApp
      };
}

class LogUserRequest {
  static Future<LogUser> getAllLogUsers() async {
    var data = await BaseServiceRequest.fetch(HttpMethod.GET,
        AppContext.ENVIRONMENT.LOG_USER + "/${AppContext.user.userId}");
    return data == null ? null : LogUser.fromJson(data);
  }

  static Future<LogUser> getLogUsersToday() async {
    var data = await BaseServiceRequest.fetch(HttpMethod.GET,
        AppContext.ENVIRONMENT.LOG_USER + "/now/${AppContext.user.userId}");
    return data == null ? null : LogUser.fromJson(data);
  }

  static Future<LogUser> updateLogUsersToday(LogUser logUser) async {
    var data = await BaseServiceRequest.fetch(
        HttpMethod.PUT, AppContext.ENVIRONMENT.LOG_USER,
        requestData: logUser.toJson());
    return data == null ? null : LogUser.fromJson(data);
  }
}
