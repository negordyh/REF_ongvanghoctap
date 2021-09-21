import 'dart:convert';

import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_enrolled_courses_by_timeline_classification.dart';
import 'package:moodle_flutter/moodle/core/core_user_get_users_by_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_context.dart';

class SharePrefs {
  static Future<SharedPreferences> getSharedPreferencesInstance() async =>
      await SharedPreferences.getInstance();

  static setSessionToken(String username, String token, String pwd) async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    prefs.setString("token", token);
    prefs.setString("username", username);
    prefs.setString("pwd", pwd);
  }

  static clearSessionToken() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    prefs.setString("token", "");
    prefs.setString("username", "");
    prefs.setString("pwd", "");
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    return prefs.getString("token");
  }

  static Future<String> getUsername() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    return prefs.getString("username");
  }

  static Future<String> getPassword() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    return prefs.getString("pwd");
  }

  static Future<bool> isSessionTokenValid() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    String username = prefs.getString("username");
    String token = prefs.getString("token");
    String pwd = prefs.getString("pwd");
    if (token == null ||
        token.isEmpty ||
        username == null ||
        username.isEmpty ||
        pwd == null ||
        pwd.isEmpty) {
      return false;
    } else {
      AppContext.setUserContext(username, pwd, token);
      return true;
    }
  }

  static saveUserInfo(CoreUserGetUserByFieldResponse data) async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    Map<String, dynamic> dataMap = CoreUserGetUserByFieldResponse.toMap(data);
    String dataString = jsonEncode(dataMap);
    prefs.setString('CoreUserGetUserByFieldResponse', dataString);
  }

  static Future<CoreUserGetUserByFieldResponse> getUserInfo() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    String dataString = prefs.getString("CoreUserGetUserByFieldResponse");
    if (dataString == null) {
      return null;
    }
    Map<String, dynamic> dataMap = jsonDecode(dataString);
    CoreUserGetUserByFieldResponse data =
        CoreUserGetUserByFieldResponse.fromJson(dataMap);
    return data;
  }

  static saveListCoursesByFieldResponse(
      List<CoursesByFieldResponse> listData) async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    List<Map<String, dynamic>> listDataMap = listData
        .map<Map<String, dynamic>>((item) => CoursesByFieldResponse.toMap(item))
        .toList();
    String listDataString = jsonEncode(listDataMap);
    prefs.setString('listCoursesByFieldResponse', listDataString);
  }

  static Future<List<CoursesByFieldResponse>>
      getListCoursesByFieldResponse() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    String listDataString = prefs.getString("listCoursesByFieldResponse");
    if (listDataString == null) {
      return [];
    }
    List listDataMap = jsonDecode(listDataString) as List;
    List<CoursesByFieldResponse> listData = listDataMap
        .map<CoursesByFieldResponse>(
            (item) => CoursesByFieldResponse.fromJson(item))
        .toList();
    return listData;
  }

  static saveListCoursesEnrolledOfUser(
      List<CoursesEnrolledOfUser> listData) async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    List<Map<String, dynamic>> listDataMap = listData
        .map<Map<String, dynamic>>((item) => CoursesEnrolledOfUser.toMap(item))
        .toList();
    String listDataString = jsonEncode(listDataMap);
    prefs.setString('listCoursesEnrolledOfUser', listDataString);
  }

  static Future<List<CoursesEnrolledOfUser>>
      getListCoursesEnrolledOfUser() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    String listDataString = prefs.getString("listCoursesEnrolledOfUser");
    if (listDataString == null) {
      return [];
    }
    List listDataMap = jsonDecode(listDataString) as List;
    List<CoursesEnrolledOfUser> listData = listDataMap
        .map<CoursesEnrolledOfUser>(
            (item) => CoursesEnrolledOfUser.fromJson(item))
        .toList();
    return listData;
  }

  static Future<bool> clearDataLogOut() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    return await prefs.clear();
  }
}
