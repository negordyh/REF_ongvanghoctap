import 'package:html/parser.dart';
import 'package:moodle_flutter/moodle/base_request.dart';
import 'package:moodle_flutter/moodle/extends/mod_quiz_attempt_html_response.dart';

String _funcName = "mod_quiz_get_attempt_summary".toLowerCase();

class QuizAttemptSummaryResponse {
  final int id;
  final int quizId;
  final List<QuestionAttemptSummaryResponse> questions;

  QuizAttemptSummaryResponse._fromJson(Map<String, dynamic> json)
      : id = json['id'],
        quizId = json['quiz'],
        questions = (json['questions'] as List)
            .map((e) => QuestionAttemptSummaryResponse.fromJson(e))
            .toList();
}

class QuestionAttemptSummaryResponse extends QuestionAttemptHtmlResponse {
  final int slot;
  final String typeQuestion;
  final int page;
  final int sequenceCheckValue;

  static String Q_WIRIS = "shortanswerwiris";
  QuestionAttemptSummaryResponse.fromJson(Map<String, dynamic> json)
      : slot = json['slot'],
        typeQuestion = json['type'],
        page = json['page'],
        sequenceCheckValue = json['sequenceCheck'.toLowerCase()],
        super.from(parse(json['html']));
}


class QuizAttemptSummaryRequest
    extends BaseRequest<QuizAttemptSummaryResponse> {
  QuizAttemptSummaryRequest(int attemptId) : super(_funcName) {
    super.requestData['attemptId'.toLowerCase()] = attemptId;
  }

  @override
  QuizAttemptSummaryResponse fromJson(data) {
    return QuizAttemptSummaryResponse._fromJson(data);
  }
}
