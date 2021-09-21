import 'package:moodle_flutter/moodle/base_request.dart';

String _funcName = "mod_quiz_get_quizzes_by_courses".toLowerCase();

class QuizResponse {
  final int id;
  final int courseId;
  final int courseModule;
  final String name;
  final int timelimit;
  final String grademethod;
  final double sumgrades;

  static final grademethodString = ["highest_grade", "average_grade", "first_grade", "last_grade"];

  QuizResponse._fromJson(Map<String, dynamic> json)
      : id = json['id'],
        courseId = json['course'],
        name = json['name'],
        courseModule = json['coursemodule'],
        timelimit = json['timelimit'],
        grademethod = grademethodString[(json['grademethod'] ?? 1) - 1],
        sumgrades = double.tryParse(json['sumgrades'].toString()) ?? 0;
}

class QuizzesRequest extends BaseRequest<List<QuizResponse>> {
  int courseModule;
  List<int> courseIds;

  QuizzesRequest(int courseId, {this.courseIds, this.courseModule}) : super(_funcName) {
    super.requestData['courseIds[0]'.toLowerCase()] = courseId;
    if (this.courseIds != null) {
      this.courseIds.forEach((element) {
        var key = ('courseIds[' + this.courseIds.indexOf(element).toString() +
            ']').toLowerCase();
        super.requestData[key] = element;
      });
    }
  }

  @override
  List<QuizResponse> fromJson(data) {
    return (data['quizzes'] as List)
        .map((e) => QuizResponse._fromJson(e))
        .where((element) => courseModule != null ? element.courseModule == courseModule : true)
        .toList();
  }
}
