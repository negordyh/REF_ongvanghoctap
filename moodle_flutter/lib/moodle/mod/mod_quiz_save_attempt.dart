/*
* UNDONE
* use api mod_quiz_process_attempt
* */

import 'package:moodle_flutter/moodle/base_request.dart';

String _funcName = "mod_quiz_save_attempt";

class QuizSaveAttemptResponse {
  final String status;

  QuizSaveAttemptResponse._fromJson(Map<String, dynamic> json)
      : status = json['status'];
}

class QuizSaveAttemptRequest extends BaseRequest<QuizSaveAttemptResponse> {
  QuizSaveAttemptRequest(int attemptId, Object sequenceCheck, Object answer)
      : super(_funcName) {
    super.requestData['attemptId'.toLowerCase()] = attemptId;
  }

  @override
  QuizSaveAttemptResponse fromJson(data) {
    return QuizSaveAttemptResponse._fromJson(data);
  }
}
