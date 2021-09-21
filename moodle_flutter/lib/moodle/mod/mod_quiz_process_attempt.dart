import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/moodle/extends/mod_quiz_attempt_html_response.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_attempt_summary.dart';

String _funcName = "mod_quiz_process_attempt";

class QuizProcessAttemptResponse {
  final String state;

  QuizProcessAttemptResponse._fromJson(Map<String, dynamic> json)
      : state = json['state'];
}

class _QuestionRequest {
  String sequenceCheckName;
  int sequenceCheckValue;
  List<QuizAnswer> quizAnswerList;

  _QuestionRequest(QuestionAttemptSummaryResponse questionResponse,
      List<QuizAnswer> quizAnswerList) {
    this.sequenceCheckName = questionResponse.sequenceCheckName;
    this.sequenceCheckValue = questionResponse.sequenceCheckValue;
    this.quizAnswerList = quizAnswerList;
  }
}

class QuizProcessAttemptRequest
    extends BaseRequest<QuizProcessAttemptResponse> {
  final Map<int, _QuestionRequest> _questionRequestMap = Map();

  QuizProcessAttemptRequest(int attemptId) : super(_funcName) {
    super.requestData['attemptId'.toLowerCase()] = attemptId;
  }

  QuizProcessAttemptRequest build(
      QuestionAttemptSummaryResponse questionResponse,
      List<QuizAnswer> quizAnswerList) {
    _questionRequestMap[questionResponse.slot] =
        new _QuestionRequest(questionResponse, quizAnswerList);
    return this;
  }

  @override
  Future<QuizProcessAttemptResponse> fetch([bool finishAttempt = true]) async {
    super.requestData['finishAttempt'.toLowerCase()] = finishAttempt ? 1 : 0;

    int dataCount = 0;

    _questionRequestMap.forEach((slot, questionRequest) {
      super.requestData['data[$dataCount][name]'] =
          questionRequest.sequenceCheckName;
      super.requestData['data[${dataCount++}][value]'] =
          questionRequest.sequenceCheckValue;

      questionRequest.quizAnswerList.forEach((quizAnswer) {
        super.requestData['data[$dataCount][name]'] = quizAnswer.key;
        super.requestData['data[${dataCount++}][value]'] = quizAnswer.value;
      });
    });

    return super.fetch();
  }

  @override
  QuizProcessAttemptResponse fromJson(data) {
    return QuizProcessAttemptResponse._fromJson(data);
  }
}
