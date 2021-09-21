import 'package:moodle_flutter/moodle/base_request.dart';

String _funcName = "mod_quiz_start_attempt";

class QuizStartAttemptResponse {
  final int attemptId;

  QuizStartAttemptResponse._fromJson(Map<String, dynamic> json)
      : attemptId = json['attemptId'.toLowerCase()];
}

class QuizStartAttemptRequest extends BaseRequest<QuizStartAttemptResponse> {
  QuizStartAttemptRequest(int quizId) : super(_funcName) {
    super.requestData['quizId'.toLowerCase()] = quizId;
  }

  @override
  QuizStartAttemptResponse fromJson(data) {
    return data['attempt'] != null
        ? QuizStartAttemptResponse._fromJson(data['attempt'])
        : QuizStartAttemptResponse._fromJson(data);
  }
}
