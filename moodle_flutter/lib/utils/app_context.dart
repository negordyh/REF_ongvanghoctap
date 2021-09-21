import 'package:flutter/material.dart';
import 'package:moodle_flutter/bee_service/log_user.dart';
import 'package:moodle_flutter/utils/environment.dart';
import 'package:moodle_flutter/utils/user_context.dart';

class AppContext {
  static const Environment ENVIRONMENT = const OngVang();

  static const String vnp_TmnCode = "IYJQMMIY";
  static const String vnp_HashSecret = "MORCWUPMHUAGKKSBZSFFDPWKXSPMNDPQ";

  /// USER INFO ---------------
  static UserContext user;

  static setUserContext(String _username, String _password, String _token) {
    user = new UserContext(_username, _password, _token);
    // user = new ServerLocalHieuEnvironment();
  }

  static setMoodleUserSession(String _session) {
    user.moodleSession = _session;
  }

  static setUserId(int _userId) {
    user.userId = _userId;
  }

  /// LOG USER ---------------
  static LogUser logUser;
  static DateTime timerStart;
  static setLogUser(LogUser newlogUser) {
    logUser = newlogUser;
    timerStart = DateTime.now();
  }

  static LogUser getLogUser() {
    if (timerStart != null && logUser.userTimeOnAppList.isNotEmpty) {
      logUser.userTimeOnAppList[0].timeCount += DateTimeRange(start: timerStart, end: DateTime.now()).duration.inSeconds;
    }
    return logUser;
  }

  static updateCourseRecentlyUser(int courseId) {
    var listCourseRecently = logUser.coursesRecently.reversed.toList();
    if (listCourseRecently.contains(courseId)) listCourseRecently.remove(courseId);
    listCourseRecently.add(courseId);
    logUser.coursesRecently = listCourseRecently.reversed.toList();
  }

  static int getTargetTimeOnApp() => logUser == null ? 0 : logUser.userTimeOnAppList[0].targetTimeOnApp;
  static setTargetTimeOnApp(int target) => logUser.userTimeOnAppList[0].targetTimeOnApp = target;

  static int getTodayTimeOnApp() => logUser == null ? 0 : logUser.userTimeOnAppList[0].timeCount;

}
