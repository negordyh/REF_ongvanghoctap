import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/utils/app_context.dart';

final String _funcName = "gradereport_user_get_grade_items";

class GraderReportUserGetGradeItems {
  final int id;
  final String itemname;
  final String itemtype;
  final String itemmodule;
  final int moduleid;
  final double graderaw;
  final int gradedatesubmitted;
  final String gradeformatted;
  final double grademin;
  final double grademax;
  final String rangeformatted;
  final String percentageformatted;
  final String averageformatted;
  GraderReportUserGetGradeItems.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        itemname = json['itemname'] ?? "",
        itemtype = json['itemtype'] ?? "",
        itemmodule = json['itemmodule'] ?? "",
        moduleid = json['cmid'] ?? 0,
        graderaw = double.tryParse(json['graderaw'].toString()) ?? 0,
        gradedatesubmitted = json['gradedatesubmitted'] ?? 0,
        gradeformatted = json['gradeformatted'] ?? "",
        grademin = double.tryParse(json['grademin'].toString()) ?? 0,
        grademax = double.tryParse(json['grademax'].toString()) ?? 0,
        rangeformatted = json['rangeformatted'] ?? "",
        percentageformatted = json['percentageformatted'] ?? "",
        averageformatted = json['averageformatted'] ?? "";

  @override
  String toString() {
    try {
      return "id = ${id.toString()}" +
          " itemname = $itemname" +
          " itemtype = $itemtype" +
          " itemmodule = $itemmodule" +
          " moduleid = ${moduleid.toString()}" +
          " graderaw = ${graderaw.toString()}" +
          " gradedatesubmitted = ${gradedatesubmitted.toString()}" +
          " gradeformatted = $gradeformatted" +
          " grademin = ${grademin.toString()}" +
          " grademax = ${grademax.toString()}" +
          " rangeformatted = $rangeformatted" +
          " percentageformatted = $percentageformatted" +
          " averageformatted = $averageformatted";
    } catch (e) {
      logger.e(e.toString());
      return "parse to string fail";
    }
  }
}

class GraderReportUserGetGradeItemsRequest
    extends BaseRequest<List<GraderReportUserGetGradeItems>> {
  final int _courseId;
  final int _userId = AppContext.user.userId;

  GraderReportUserGetGradeItemsRequest(this._courseId) : super(_funcName) {
    super.requestData['courseId'.toLowerCase()] = _courseId;
    super.requestData['userId'.toLowerCase()] = _userId;
  }

  @override
  List<GraderReportUserGetGradeItems> fromJson(data) {
    try {
      if (data['usergrades'] == null || (data['usergrades'] as List).isEmpty)
        return [];
      List<dynamic> dataRes = data['usergrades'][0]['gradeitems'];
      dataRes.removeLast();
      return dataRes
          .map((e) => GraderReportUserGetGradeItems.fromJson(e))
          .toList();
    } catch (e) {
      logger.d(e.toString());
      return [];
    }
  }
}
