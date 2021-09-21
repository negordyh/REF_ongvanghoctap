import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:logger/logger.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_contents.dart';
import 'package:moodle_flutter/moodle/extends/mod_quiz_attempt_html_response.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_attempt_summary.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_quizzes_by_courses.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_user_attempts.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_process_attempt.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_start_attempt.dart';
import 'package:moodle_flutter/ui/components/alert_error_dialog.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/ui/digit_recognizer/draw_screen.dart';
import 'package:moodle_flutter/ui/quiz/resultpage.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/ui_data.dart';

class QuizDetail extends StatefulWidget {
  final Module module;

  QuizDetail(this.module);

  @override
  _QuizDetailState createState() => _QuizDetailState();
}

class _QuizDetailState extends State<QuizDetail> {
  List<QuestionAttemptSummaryResponse> listQuestionAttemptSummaryResponse;
  int attemptId;

  @override
  void initState() {
    super.initState();
    getQuizzes();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> getQuizzes() async {
    List<QuizResponse> quizResponse = await QuizzesRequest(
            widget.module.courseId,
            courseModule: widget.module.id)
        .fetch();

    QuizStartAttemptResponse quizStartAttemptResponse =
        await QuizStartAttemptRequest(quizResponse.first.id).fetch();
    if (quizStartAttemptResponse.attemptId != null) {
      attemptId = quizStartAttemptResponse.attemptId;
    } else {
      List<QuizUserAttemptResponse> quizUserAttemptResponse =
          await QuizUserAttemptsRequest(quizResponse.first.id).fetch();
      attemptId = quizUserAttemptResponse.last.id;
    }

    QuizAttemptSummaryResponse quizAttemptSummaryResponse =
        await QuizAttemptSummaryRequest(attemptId).fetch();
    setState(() {
      this.listQuestionAttemptSummaryResponse =
          quizAttemptSummaryResponse.questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBarCustom(
          size: size,
          title: widget.module.name,
          image: "assets/images/sinh-hoc.jpg",
        ),
        body: this.listQuestionAttemptSummaryResponse == null
            ? Center(
                child: Text(
                  "Loading",
                ),
              )
            : Quiz(
                listQuestion: this.listQuestionAttemptSummaryResponse,
                attemptId: this.attemptId,
                name: widget.module.name));
  }
}

class Quiz extends StatefulWidget {
  final List<QuestionAttemptSummaryResponse> listQuestion;
  final int attemptId;
  final String name;

  Quiz(
      {Key key,
      @required this.listQuestion,
      @required this.attemptId,
      @required this.name})
      : super(key: key);

  @override
  _QuizState createState() => _QuizState(listQuestion, attemptId);
}

class _QuizState extends State<Quiz> {
  final List<QuestionAttemptSummaryResponse> listQuestionState;
  final int attemptId;
  static const DEFAULT_BTN_COLOR = Colors.white;

  _QuizState(this.listQuestionState, this.attemptId);

  QuestionAttemptSummaryResponse currentQuestion;
  QuizProcessAttemptRequest quizProcessAttemptRequest;

  Color colorToShow = Color(0xFF3788BA);
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;

  Map<String, dynamic> stateAnswer = {}; // {id: [state, color]}

  @override
  void initState() {
    super.initState();
    setState(() {
      this.currentQuestion = this.listQuestionState.first;
      this.quizProcessAttemptRequest = QuizProcessAttemptRequest(attemptId);
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => CustomErrorDialog(
              title: AppLocalizations.of(context).translate('go_back'),
              description:
              AppLocalizations.of(context).translate('go_back_dec'),
            ),
        );
      },
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background_result.jpeg"),
                fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.55),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                ),
                child: Column(children: [
                  Text(
                    'Câu ${(listQuestionState.indexOf(currentQuestion) + 1).toString()}:',
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Alike",
                      fontSize: 22.0,
                    ),
                  ),
                  Html(
                    data: currentQuestion.question,
                    style: {
                      "body": Style(
                        fontSize: FontSize(20.0),
                        fontWeight: FontWeight.bold,
                      ),
                    },
                  ),
                ])),
            Container(
              padding: EdgeInsets.only(left: size.width * 0.45),
              alignment: Alignment.center,
              child: Html(
                data: currentQuestion.questionImgHtml,
                style: {
                  "body": Style(
                    fontSize: FontSize(20.0),
                    fontWeight: FontWeight.bold,
                  ),
                },
              ),
            ),
            this.currentQuestion.typeQuestion ==
                    QuestionAttemptSummaryResponse.Q_WIRIS
                ? Container(
                    color: Colors.blue[100].withOpacity(0.35),
                    child: Expanded(
                      flex: 12,
                      child: DrawScreen(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (this.currentQuestion.answerList.first is String) {
                        return Html(
                          data: this.currentQuestion.answerList.first,
                          style: {
                            "body": Style(
                              fontSize: FontSize(26.0),
                              fontWeight: FontWeight.bold,
                            ),
                          },
                        );
                      } else if (this.currentQuestion.answerList.first
                          is QuizAnswer) {
                        return answerButton(this.currentQuestion.typeQuestion,
                            this.currentQuestion.answerList[index]);
                      } else {
                        return Center(
                          child: Text(
                            "Error",
                          ),
                        );
                      }
                    },
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: this.currentQuestion.answerList.length,
                  )),
            Container(
                alignment: Alignment.bottomRight,
                child: Center(
                  child: getUINextButton(),
                )),
          ],
        ),
      ),
    );
  }

  Widget answerButton(String type, QuizAnswer answer) {
    if (type == 'truefalse') {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: MaterialButton(
          onPressed: () {
            this
                .quizProcessAttemptRequest
                .build(currentQuestion, List.of([answer]));
            nextQuestion();
          },
          child: Text(
            answer.text,
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Alike",
              fontSize: 16.0,
            ),
            maxLines: 1,
          ),
          color: this.stateAnswer.containsKey(answer.value)
              ? this.stateAnswer[answer.value][1]
              : DEFAULT_BTN_COLOR,
          splashColor: Colors.indigo[700],
          highlightColor: Colors.indigo[700],
          minWidth: 200.0,
          height: 45.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      );
    } else if (type == 'multichoice') {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              this.stateAnswer.update(
                  answer.value,
                  (value) => value[0]
                      ? [false, Colors.white]
                      : [true, Colors.lightBlue],
                  ifAbsent: () => [true, Colors.lightBlue]);
            });
            this
                .quizProcessAttemptRequest
                .build(currentQuestion, List.of([answer]));
          },
          child: Text(
            answer.text,
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Alike",
              fontSize: 16.0,
            ),
            maxLines: 1,
          ),
          color: this.stateAnswer.containsKey(answer.value)
              ? this.stateAnswer[answer.value][1]
              : DEFAULT_BTN_COLOR,
          splashColor: Colors.indigo[700],
          highlightColor: Colors.indigo[700],
          minWidth: 200.0,
          height: 45.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text(
            "Loading",
          ),
        ),
      );
    }
  }

  Widget getUINextButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.0,
        bottom: 40.0,
      ),
      child: MaterialButton(
        onPressed: () => nextQuestion(),
        child: Text(
          'N E X T',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: Colors.blue,
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 100.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  void nextQuestion() async {
    int idxCurrent = this.listQuestionState.indexOf(this.currentQuestion) + 1;
    if (idxCurrent < this.listQuestionState.length) {
      setState(() {
        this.currentQuestion = this.listQuestionState[idxCurrent];
        this.stateAnswer = {};
      });
    } else {
      await this.quizProcessAttemptRequest.fetch();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResultQuiz(attempId: attemptId),
      ));
    }
  }
}
