import 'package:flutter/material.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_attempt_review.dart';
import 'package:moodle_flutter/ui/course_contents/list_lesson_of_courses.dart';
import 'package:moodle_flutter/ui/quiz/quiz_review/quiz_review.dart';
import 'package:moodle_flutter/utils/language.dart';

class ResultQuiz extends StatefulWidget {
  int attempId;
  ResultQuiz({Key key, @required this.attempId}) : super(key: key);
  @override
  ResultQuizState createState() => ResultQuizState();
}

class ResultQuizState extends State<ResultQuiz> {
  List<String> images = [
    "assets/images/dia-ly.png",
    "assets/images/dia-ly.png",
    "assets/images/dia-ly.png",
  ];

  String message = '';
  QuizAttemptReviewResponse quizAttemptReviewResponse;

  @override
  void initState() {
    QuizAttemptReviewRequest(widget.attempId).fetch().then((value) {
      setState(() {
        quizAttemptReviewResponse = value;
        message = quizAttemptReviewResponse.grade < 5
            ? AppLocalizations.of(context).translate('try_hard')
        // "You Should Try Hard..\n"
            : quizAttemptReviewResponse.grade < 8
                ? AppLocalizations.of(context).translate('do_better')
        // "You Can Do Better..\n"
                : AppLocalizations.of(context).translate('very_well');
        // "You Did Very Well..\n";
        message +=
            AppLocalizations.of(context).translate('you_scored')+ "${quizAttemptReviewResponse.grade.toStringAsFixed(2)}";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0x15000000),
        elevation: 0.0,
        title: Text("Result"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background_result.jpeg"),
                  fit: BoxFit.cover)),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      message,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Quando",
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      primary: Colors.purpleAccent,
                      onPrimary: Colors.white),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuizReview(
                          quizAttemptReviewResponse: quizAttemptReviewResponse),
                    ));
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('review_quiz'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      primary: Colors.purpleAccent,
                      onPrimary: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('back'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
