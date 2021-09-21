import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/utils/app_context.dart';

final String _funcName = "gradereport_overview_get_course_grades";

class GraderReportCourseGrade {
  final int courseid;
  final double grade;
  final double rawgrade;
  final int rank;
  String courseName;

  GraderReportCourseGrade.fromJson(Map<String, dynamic> json)
      : courseid = json['courseid'],
        rawgrade = double.tryParse(json['rawgrade'].toString()) ?? 0,
        grade = double.tryParse(json['grade'].toString()) ?? 0,
        rank = json['rank'] ?? 0,
        courseName = '';

  @override
  String toString() {
    try {
      return "courseid = $courseid" +
          " rawgrade = $rawgrade" +
          " grade = $grade" +
          " rank = $rank" +
          "courseName = $courseName";
    } catch (e) {
      logger.e(e.toString());
      return "Parse GraderReportCourseGrade to string fail";
    }
  }
}

class GraderReportCourseGradeRequest
    extends BaseRequest<List<GraderReportCourseGrade>> {
  final int _userId = AppContext.user.userId;

  GraderReportCourseGradeRequest() : super(_funcName) {
    super.requestData['userId'.toLowerCase()] = _userId;
  }

  @override
  List<GraderReportCourseGrade> fromJson(data) {
    try {
      return data['grades']
          .map<GraderReportCourseGrade>((e) => GraderReportCourseGrade.fromJson(e))
          .toList();
    } catch (e) {
      logger.d(e.toString());
      return [];
    }
  }
}
