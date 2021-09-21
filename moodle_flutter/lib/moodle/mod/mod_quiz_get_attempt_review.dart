import 'package:html/parser.dart';
import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/moodle/extends/mod_quiz_attempt_html_response.dart';

String _funcName = "mod_quiz_get_attempt_review".toLowerCase();

class QuizAttemptReviewResponse {
  final double grade;
  final List<QuestionReviewResponse> questionReviewList;
  final String state; // "finished"
  final DateTime timestart;
  final DateTime timefinish;
  final DateTime timemodified;

  QuizAttemptReviewResponse._fromJson(Map<String, dynamic> json)
      : grade = double.tryParse(json['grade'].toString()),
        state = json['attempt']['state'],
        timestart = DateTime.fromMillisecondsSinceEpoch(
            json['attempt']['timestart'.toLowerCase()]*1000),
        timefinish = DateTime.fromMillisecondsSinceEpoch(
            json['attempt']['timefinish'.toLowerCase()]*1000),
        timemodified = DateTime.fromMillisecondsSinceEpoch(
            json['attempt']['timemodified'.toLowerCase()]*1000),
        questionReviewList = (json['questions'] as List)
            .map((e) => QuestionReviewResponse._fromJson(e))
            .toList();
}

class QuestionReviewResponse extends QuestionAttemptHtmlResponse {
  final String status;
  final String mark;
  final double maxMark;
  final String state; // "gradedwrong","gradedright","gaveup"

  QuestionReviewResponse._fromJson(Map<String, dynamic> json)
      : status = json['status'],
        state = json['state'],
        mark = json['mark'].toString(),
        maxMark =
            double.tryParse(json['maxMark'.toLowerCase()].toString()) ?? 0,
        super.from(parse(json['html']));

  @override
  String toString() =>
      'QuestionReviewResponse:{status:$status, mark:$mark, maxMark:$maxMark, '
      'question:$question, answerList:$answerList}';
}

class QuizAttemptReviewRequest extends BaseRequest<QuizAttemptReviewResponse> {
  QuizAttemptReviewRequest(int attemptId) : super(_funcName) {
    super.requestData['attemptId'.toLowerCase()] = attemptId;
  }

  @override
  QuizAttemptReviewResponse fromJson(data) {
    return QuizAttemptReviewResponse._fromJson(data);
  }
}
