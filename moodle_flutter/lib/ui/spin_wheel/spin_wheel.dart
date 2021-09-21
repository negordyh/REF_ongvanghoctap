import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_contents.dart';
import 'package:moodle_flutter/moodle/mod/mod_quiz_get_quizzes_by_courses.dart';
import 'package:moodle_flutter/ui/components/alert_dialog.dart';
import 'package:moodle_flutter/ui/quiz/quiz_detail.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:moodle_flutter/utils/language.dart';

class Roulette extends StatelessWidget {
  final StreamController _dividerController = StreamController<int>();
  Size deviceSize;

  final _wheelNotifier = StreamController<double>();

  dispose() {
    _dividerController.close();
    _wheelNotifier.close();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0x15000000),
          elevation: 0.0,
          title: Text(AppLocalizations.of(context).translate('spin_wheel')),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Color(0xFF98CEEF),
        body: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background game.jpeg"),
                    fit: BoxFit.cover)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  StreamBuilder(
                    stream: _dividerController.stream,
                    builder: (context, snapshot) => snapshot.hasData
                        ? RouletteScore(snapshot.data)
                        : Container(),
                  ),
                  SizedBox(height: 10),
                  SpinningWheel(
                    Image.asset('assets/images/roulette-8-300.png'),
                    width: deviceSize.width * 0.85,
                    height: deviceSize.width * 0.85,
                    initialSpinAngle: _generateRandomAngle(),
                    spinResistance: 0.6,
                    canInteractWhileSpinning: false,
                    dividers: 8,
                    onUpdate: _dividerController.add,
                    onEnd: (e) {
                      _dividerController.add(e);
                      showDialogConfirm(context, e);
                    },
                    secondaryImage:
                        Image.asset('assets/images/roulette-center-300.png'),
                    secondaryImageHeight: 110,
                    secondaryImageWidth: 110,
                    shouldStartOrStop: _wheelNotifier.stream,
                  ),
                  SizedBox(height: 20),
                  new RaisedButton(
                    child: new Text("S P I N"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () =>
                        _wheelNotifier.sink.add(_generateRandomVelocity()),
                    color: Color(0xffffafbd),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 3000) + 6000;

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;

  void showDialogConfirm(BuildContext context, int lableQ) async {
    QuizzesRequest(2,
            courseIds: AppContext.logUser.coursesRecently.sublist(1) ?? [])
        .fetch()
        .then((value) async {
      final _random = new Random();
      QuizResponse quiz = value[_random.nextInt(value.length)];

      Future.delayed(const Duration(milliseconds: 100), () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: 100, bottom: 16, right: 16, left: 16),
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(17),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(0.0, 10.0),
                              )
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Game',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Bạn quay vào câu hỏi số $lableQ',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => QuizDetail(
                                        Module.init(quiz.courseModule, quiz.courseId)),
                                  ));
                                },
                                child: Text('Trả lời'))
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 16,
                        right: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/images/alert_gif.gif"),
                        ),
                      ),
                    ],
                  ),
                ));
      });
    });
  }
}

class RouletteScore extends StatelessWidget {
  final int selected;

  final Map<int, String> labels = {
    1: 'Câu 1',
    2: 'Câu 2',
    3: 'Câu 3',
    4: 'Câu 4',
    5: 'Câu 5',
    6: 'Câu 6',
    7: 'Câu 7',
    8: 'Câu 8',
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    return Text('${labels[selected]}',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 24.0,
          color: Colors.white,
        ));
  }
}
