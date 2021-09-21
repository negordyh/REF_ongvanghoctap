import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/moodle/extends/mod_quiz_attempt_html_response.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_attempt_review.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_user_attempts.dart';
import 'package:moodle_flutter/ui/components/index.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuizReview extends StatefulWidget {
  final QuizAttemptReviewResponse quizAttemptReviewResponse;
  final int attempId;
  QuizReview({this.quizAttemptReviewResponse, this.attempId});

  @override
  _QuizReviewState createState() => _QuizReviewState();
}

class _QuizReviewState extends State<QuizReview> {
  QuizAttemptReviewResponse quizAttemptReviewResponse;

  @override
  void initState() {
    if (widget.quizAttemptReviewResponse == null) {
      QuizAttemptReviewRequest(widget.attempId).fetch().then((value) {
        setState(() => quizAttemptReviewResponse = value);
      });
    } else {
      setState(
          () => quizAttemptReviewResponse = widget.quizAttemptReviewResponse);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> listWidget = [];
    if (quizAttemptReviewResponse != null) {
      logger.d('${quizAttemptReviewResponse.questionReviewList}');
      List<QuestionReviewResponse> listQuestion =
          quizAttemptReviewResponse.questionReviewList;
      listWidget = [SumaryResult(size, quizAttemptReviewResponse)];
      listWidget.addAll(listQuestion
          .map((e) => QuestionReview(size, listQuestion.indexOf(e), e))
          .toList());
    }

    return Scaffold(
        backgroundColor: Color(0xFFE8ECF0),
        appBar: AppBarCustom(
          size: size,
          title: AppLocalizations.of(context).translate('quiz_review'),
          image: "assets/images/sinh-hoc.jpg",
        ),
        body: ListView(
          children: listWidget,
        ));
  }

  Widget SumaryResult(
          Size size, QuizAttemptReviewResponse quizAttemptReviewResponse) =>
      Container(
        padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
        child: Card(
          elevation: 3.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getItemInfo(
                  AppLocalizations.of(context).translate("start_time_at"),
                  quizAttemptReviewResponse.timestart
                      .toString()
                      .substring(0, 19),
                ),
                getItemInfo(
                  AppLocalizations.of(context).translate("end_time_at"),
                  quizAttemptReviewResponse.timefinish
                      .toString()
                      .substring(0, 19),
                ),
                getItemInfo(
                  AppLocalizations.of(context).translate("modify_time"),
                  quizAttemptReviewResponse.timemodified
                      .toString()
                      .substring(0, 19),
                ),
                getItemInfo(
                  AppLocalizations.of(context).translate("status"),
                  AppLocalizations.of(context)
                      .translate(quizAttemptReviewResponse.state.toLowerCase()),
                ),
                getItemInfo(
                  AppLocalizations.of(context).translate("grade"),
                  quizAttemptReviewResponse.grade.toStringAsFixed(1),
                ),
                LinearPercentIndicator(
                  width: size.width * 0.8,
                  lineHeight: 10.0,
                  percent: quizAttemptReviewResponse.grade / 10.0,
                  backgroundColor: Color(0xFF3932FF),
                  progressColor: Colors.lightBlue,
                ),
              ],
            ),
          ),
        ),
      );

  Widget getItemInfo(String title, String data) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Text(
                data,
                style: TextStyle(fontSize: 16),
              )),
          Divider(
            height: 30.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget QuestionReview(Size size, int index,
          QuestionReviewResponse questionReviewResponse) =>
      Container(
        padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "${AppLocalizations.of(context).translate("question")} ${index + 1}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 6, right: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(questionReviewResponse.status),
                          Text(
                              "${AppLocalizations.of(context).translate("grade")} ${questionReviewResponse.mark}/${questionReviewResponse.maxMark}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: Html(
                  data: questionReviewResponse.question,
                  style: {
                    "body": Style(
                      fontSize: FontSize(15.0),
                      fontWeight: FontWeight.bold,
                    ),
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: size.width * 0.45),
                alignment: Alignment.center,
                child: Html(
                  data: questionReviewResponse.questionImgHtml,
                  style: {
                    "body": Style(
                      fontSize: FontSize(20.0),
                      fontWeight: FontWeight.bold,
                    ),
                  },
                ),
              ),
              Column(children: getListAnswer(size, questionReviewResponse))
            ],
          ),
        ),
      );

  getListAnswer(Size size, QuestionReviewResponse questionReviewResponse) {
    List<Widget> res = questionReviewResponse.answerList.map<Widget>((e) {
      return Card(
        color: Colors.white70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: size.width * 0.75,
              child: Text(
                (e as QuizAnswer).text ?? '',
                style: TextStyle(fontSize: 20),
              ),
              // Html(
              //   data: ans.text,
              //   style: {
              //     "div": Style(
              //       fontSize: FontSize(15.0),
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black
              //     ),
              //   },
              // ),
            ),
            getResultCheckBox(e.review ?? ''),
          ],
        ),
      );
    }).toList();
    return res;
  }

  Widget getResultCheckBox(String value) {
    if ('Đúng'.toLowerCase().compareTo(value.toLowerCase()) == 0 ||
        'true'.compareTo(value.toLowerCase()) == 0) {
      return Checkbox(
          onChanged: (value) => {},
          tristate: false,
          value: true,
          activeColor: Color(0xFF3FB301));
    } else if ('Sai'.toLowerCase().compareTo(value.toLowerCase()) == 0 ||
        'false'.compareTo(value.toLowerCase()) == 0) {
      return Checkbox(
          onChanged: (value) => {},
          tristate: true,
          value: null,
          activeColor: Color(0xFFBF011E));
    } else {
      return Checkbox(onChanged: (value) => {}, value: false);
    }
  }
}
