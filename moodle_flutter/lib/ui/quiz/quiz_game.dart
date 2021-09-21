import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_contents.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/ui/h5p/h5p_screen.dart';
import 'package:moodle_flutter/ui/quiz/quiz_review/quiz_review.dart';
import 'package:moodle_flutter/ui/quiz/quiz_review/quiz_review_period.dart';
import 'package:moodle_flutter/utils/static_type.dart';
import 'dart:math';
import 'package:moodle_flutter/utils/ui_data.dart';
import 'package:moodle_flutter/ui/quiz/quiz_detail.dart';

class QuizGames extends StatefulWidget {
  final List<Module> _modules;
  final String _courseContentName;

  QuizGames(this._modules, this._courseContentName);

  @override
  _QuizGamesState createState() => _QuizGamesState();
}

class _QuizGamesState extends State<QuizGames> {
  Size deviceSize;
  var count = 3;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    bool leftFlag = false;
    List<Widget> moduleWidgetList = widget._modules.map((e) {
      leftFlag = !leftFlag;
      return Column(
        children: <Widget>[
          // SizedBox(height: 40),
          Divider(
            color: Color(0xFF3B3B3B),
            height: 25,
            indent: 30,
            endIndent: 30,
          ),
          leftFlag
              ? leftQuiz(e, Colors.orange[50])
              : rightQuiz(e, Colors.orange[50]),
        ],
      );
    }).toList();

    return Scaffold(
      backgroundColor: UIData.background,
      appBar: AppBarCustom(
        size: deviceSize,
        title: widget._courseContentName,
        image: "assets/images/sinh-hoc.jpg",
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: moduleWidgetList,
      ),
    );
  }

  Widget _switchModule(Module module) {
    logger.d(module);
    switch (module.modName.toLowerCase()) {
      case ModType.QUIZ:
        return QuizDetail(module);
      case ModType.HVP:
        return H5PScreen(module);
      case ModType.H5PACTIVITY:
        return H5PScreen(module);
      default:
        return H5PScreen(module);
    }
  }

  Widget leftQuiz(Module module, Color color) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => _switchModule(module),
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.yellow),
                          value: Random().nextDouble(),
                          strokeWidth: 60,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                        ),
                        CircleAvatar(
                          child: Image.asset("assets/icons/icon-flower.png"),
                          radius: 38,
                          backgroundColor: color,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: deviceSize.width * 0.6,
                      child: Text(
                        module.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  RotationTransition(
                    turns: AlwaysStoppedAnimation(270 / 360),
                    child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset("assets/images/bee-135.png")),
                  ),
                  SizedBox(width: deviceSize.width * 0.15),
                  (module.modName.toLowerCase() == ModType.QUIZ) ?
                  Container(
                    padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                    width: deviceSize.width * 0.1,
                    child: SizedBox(
                      width: 60,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 0.0),
                        shape: StadiumBorder(),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                        color: const Color(0xFF232133),
                        onPressed: () {},
                      ),
                    ),
                  ) :
                  Container(
                    padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                    width: deviceSize.width * 0.1,
                    child: SizedBox(
                      width: 60,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 0.0),
                        shape: StadiumBorder(),
                        child: Image.asset("assets/icons/icon-h5p.png"),
                        color: const Color(0xFF232133),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        module.modName.toLowerCase() == ModType.QUIZ
            ? IconSlideAction(
                caption: 'Review',
                color: Colors.black45,
                icon: Icons.rate_review,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizReviewPeriod(module),
                    ),
                  );
                },
              )
            : Container(),
      ],
    );
  }

  Widget rightQuiz(Module module, Color color) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: deviceSize.width * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RotationTransition(
                turns: AlwaysStoppedAnimation(0),
                child: Container(
                  width: 40,
                  height: 40,
                  child: Image.asset("assets/images/bee-135.png"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => _switchModule(module),
                  ));
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.yellow),
                              value: Random().nextDouble(),
                              strokeWidth: 60,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 40,
                            ),
                            CircleAvatar(
                              child:
                                  Image.asset("assets/icons/icon-flower.png"),
                              radius: 38,
                              backgroundColor: color,
                            ),
                          ],
                        ),

                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: deviceSize.width * 0.6,
                      child: Text(
                        module.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(width: deviceSize.width * 0.1),
              (module.modName.toLowerCase() == ModType.QUIZ) ?
              Container(
                padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                width: deviceSize.width * 0.1,
                child: SizedBox(
                  width: 60,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 0.0),
                    shape: StadiumBorder(),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                    color: const Color(0xFF232133),
                    onPressed: () {},
                  ),
                ),
              ) :
              Container(
                padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                width: deviceSize.width * 0.1,
                child: SizedBox(
                  width: 60,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 0.0),
                    shape: StadiumBorder(),
                    child: Image.asset("assets/icons/icon-h5p.png"),
                    color: const Color(0xFF232133),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        module.modName.toLowerCase() == ModType.QUIZ
            ? IconSlideAction(
                caption: 'Review',
                color: Colors.black45,
                icon: Icons.rate_review,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizReviewPeriod(module),
                    ),
                  );
                },
              )
            : Container(),
      ],
    );
  }
}
