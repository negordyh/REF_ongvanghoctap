import 'package:flutter/material.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_contents.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_attempt_review.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_quizzes_by_courses.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_user_attempts.dart';
import 'package:moodle_flutter/ui/components/index.dart';
import 'package:moodle_flutter/ui/quiz/quiz_detail.dart';
import 'package:moodle_flutter/ui/quiz/quiz_review/quiz_review.dart';
import 'package:moodle_flutter/utils/language.dart';

class QuizReviewPeriod extends StatefulWidget {
  final Module module;
  QuizReviewPeriod(this.module);

  @override
  _QuizReviewPeriodState createState() => _QuizReviewPeriodState();
}

class _QuizReviewPeriodState extends State<QuizReviewPeriod> {
  List<QuizResponse> quizResponse;
  List<QuizUserAttemptResponse> quizAttempUsers;

  @override
  void initState() {
    QuizzesRequest(widget.module.courseId, courseModule: widget.module.id)
        .fetch()
        .then((value) => setState(() => quizResponse = value));

    QuizUserAttemptsRequest(widget.module.instance)
        .fetch()
        .then((value) => setState(() => quizAttempUsers = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFE8ECF0),
      appBar: AppBarCustom(
        size: size,
        title: widget.module.name,
        image: "assets/images/sinh-hoc.jpg",
      ),
      body: SingleChildScrollView(
        child: quizResponse == null ||
                quizResponse.isEmpty ||
                quizAttempUsers == null ||
                quizAttempUsers.isEmpty
            ? Container()
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 16, 10, 8),
                    child: Card(
                      elevation: 3.0,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${AppLocalizations.of(context).translate("time_limit")}: "
                                  "${(quizResponse.first.timelimit / 60).toStringAsFixed(0)} "
                                  "${AppLocalizations.of(context).translate("minutes")}",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                            Divider(
                              height: 30.0,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("grade_method"),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      AppLocalizations.of(context).translate(quizResponse.first.grademethod),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       "Số lần làm bài cho phép",
                                //       style: TextStyle(fontSize: 18),
                                //     ),
                                //     Text(
                                //       "2",
                                //       style: TextStyle(
                                //           fontSize: 16, color: Colors.black54),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
                    child: Card(
                      elevation: 3.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              AppLocalizations.of(context).translate("review_attempt"),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          Divider(
                            height: 20.0,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.15,
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "#",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: size.width * 0.55,
                                child: Text(
                                  AppLocalizations.of(context).translate("status"),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: size.width * 0.2,
                                child: Text(
                                  AppLocalizations.of(context).translate("grade"),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 20.0,
                            color: Colors.grey,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: quizAttempUsers.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                  onTap: () {
                                    if (quizAttempUsers[i].state ==
                                        QuizUserAttemptResponse
                                            .STATE_INPROGRESS) {
                                      Navigator.pop(context);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            QuizDetail(widget.module),
                                      ));
                                    } else {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => QuizReview(
                                            attempId: quizAttempUsers[i].id),
                                      ));
                                    }
                                  },
                                  child: _question(quizAttempUsers[i], size));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //   child: Card(
                  //     elevation: 3.0,
                  //     child: Padding(
                  //       padding: EdgeInsets.all(16.0),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: <Widget>[
                  //           Text(
                  //             "Lần cao nhất: 5/10",
                  //             style: TextStyle(fontSize: 18),
                  //           ),
                  //           Divider(
                  //             height: 0.0,
                  //             color: Colors.white,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 80.0),
                      shape: StadiumBorder(),
                      child: Text(
                        AppLocalizations.of(context).translate("retest"),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: const Color(0xFF34B400),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => QuizDetail(widget.module),
                        ));
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _question(QuizUserAttemptResponse quiz, size) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            child: Card(
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.14,
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "${quizAttempUsers.indexOf(quiz) + 1}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    width: size.width * 0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate(quiz.state),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${AppLocalizations.of(context).translate("submitted")}: \n \t ${quiz.timeModified.toString().substring(0, 19)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.2,
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      quiz.state != QuizUserAttemptResponse.STATE_FINISHED
                          ? '--'
                          : '${(quiz.sumGrades / quizResponse.first.sumgrades * 10).toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
