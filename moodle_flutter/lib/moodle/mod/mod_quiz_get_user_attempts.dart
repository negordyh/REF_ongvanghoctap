import 'package:moodle_flutter/moodle/base_request.dart';

String _funcName = "mod_quiz_get_user_attempts".toLowerCase();

class QuizUserAttemptResponse {
  final int id;
  final int attemptCount;
  final int currentPage;
  final String state;
  final DateTime timeStart;
  final DateTime timeFinish;
  final DateTime timeModified;
  final int sumGrades;

  static const STATE_FINISHED = "finished";
  static const STATE_INPROGRESS = "inprogress";

  QuizUserAttemptResponse._fromJson(Map<String, dynamic> json)
      : id = json['id'],
        attemptCount = json['attemptCount'.toLowerCase()],
        currentPage = json['currentPage'.toLowerCase()],
        state = json['state'],
        timeStart = DateTime.fromMillisecondsSinceEpoch(
            json['timeStart'.toLowerCase()]*1000),
        timeFinish = DateTime.fromMillisecondsSinceEpoch(
            json['timeFinish'.toLowerCase()]*1000),
        timeModified = DateTime.fromMillisecondsSinceEpoch(
            json['timeModified'.toLowerCase()]*1000),
        sumGrades = json['sumGrades'.toLowerCase()];
}

class QuizUserAttemptsRequest
    extends BaseRequest<List<QuizUserAttemptResponse>> {
  QuizUserAttemptsRequest(int quizId) : super(_funcName) {
    super.requestData['quizId'.toLowerCase()] = quizId;
    super.requestData['status'] = 'all';
    super.requestData['includePreviews'.toLowerCase()] = '1';
  }

  @override
  List<QuizUserAttemptResponse> fromJson(data) {
    return (data['attempts'] as List)
        .map((element) => QuizUserAttemptResponse._fromJson(element))
        .toList();
  }
}
