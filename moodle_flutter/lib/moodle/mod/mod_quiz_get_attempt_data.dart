import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_attempt_summary.dart';

String _funcName = "mod_quiz_get_attempt_data".toLowerCase();

class QuizAttemptDataResponse {
  final int id;
  final int quizId;
  final List<QuestionAttemptSummaryResponse> questions;

  QuizAttemptDataResponse._fromJson(Map<String, dynamic> json)
      : id = json['id'],
        quizId = json['quiz'],
        questions = (json['questions'] as List)
            .map((e) => QuestionAttemptSummaryResponse.fromJson(e))
            .toList();
}

class QuizAttemptDataRequest extends BaseRequest<QuizAttemptDataResponse> {
  QuizAttemptDataRequest(int attemptId, int page) : super(_funcName) {
    super.requestData['attemptId'.toLowerCase()] = attemptId;
    super.requestData['page'] = page;
  }

  @override
  QuizAttemptDataResponse fromJson(data) {
    return QuizAttemptDataResponse._fromJson(data);
  }
}
