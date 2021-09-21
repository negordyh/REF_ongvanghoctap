import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/utils/app_context.dart';

final String _funcName = "enrol_manual_enrol_users";

class EnrolManualEnrolUsersRequest extends BaseRequest{
  final int _roleid = 5;
  final int _userid = AppContext.user.userId;
  final int _courseid;
  final int _timestart;
  final int _timeend;
  final int _suspend;

  EnrolManualEnrolUsersRequest(this._courseid, [this._timestart, this._timeend, this._suspend]) : super(_funcName) {
    super.requestData['enrolments[0][roleid]'] = _roleid;
    super.requestData['enrolments[0][userid]'] = _userid;
    super.requestData['enrolments[0][courseid]'] = _courseid;
    this._timestart != null ? super.requestData['enrolments[0][timestart]'] = _timestart : 0;
    this._timeend != null ? super.requestData['enrolments[0][timeend]'] = _timeend : 0;
    this._suspend != null ? super.requestData['enrolments[0][suspend]'] = _suspend : 0;
  }

  @override
  dynamic fromJson(data) {
    return data;
  }

// +------+--------+------------------+---------------+-------------+------------------+
// | "id" | "name" |   "shortname"    | "description" | "sortorder" |   "archetype"    |
// +------+--------+------------------+---------------+-------------+------------------+
// | "1"  | ""     | "manager"        | ""            | "1"         | "manager"        |
// | "2"  | ""     | "coursecreator"  | ""            | "2"         | "coursecreator"  |
// | "3"  | ""     | "editingteacher" | ""            | "3"         | "editingteacher" |
// | "4"  | ""     | "teacher"        | ""            | "4"         | "teacher"        |
// | "5"  | ""     | "student"        | ""            | "5"         | "student"        |
// | "6"  | ""     | "guest"          | ""            | "6"         | "guest"          |
// | "7"  | ""     | "user"           | ""            | "7"         | "user"           |
// | "8"  | ""     | "frontpage"      | ""            | "8"         | "frontpage"      |
// +------+--------+------------------+---------------+-------------+------------------+
}
