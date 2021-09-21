import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_flutter/moodle/authenticate/moodle_session_service.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/ui/dashboard_courses/dashboard_course.dart';
import 'package:moodle_flutter/utils/ui_data.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_contents.dart';
import 'package:moodle_flutter/ui/quiz/quiz_game.dart';
import 'package:moodle_flutter/ui/quiz/quiz_detail.dart';
import 'package:provider/provider.dart';
import 'package:moodle_flutter/moodle/gradereport/gradereport_user_get_grade_items.dart';

class ListLessonWidget extends StatefulWidget {
  final int _courseId;
  final String _fullname;

  ListLessonWidget(this._courseId, this._fullname);

  @override
  _ListLessonWidgetState createState() => _ListLessonWidgetState();
}

class _ListLessonWidgetState extends State<ListLessonWidget> {
  Size deviceSize;
  List<GraderReportUserGetGradeItems> gradeReportUserGetGradeItems;
  String images = "assets/icons/icon-book.png";
  Future<List<CourseContentsResponse>> courseContentFuture = new Future.value();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      GraderReportUserGetGradeItemsRequest(widget._courseId)
          .fetchUsingTokenAdmin()
          .then((value) {
        setState(() => this.gradeReportUserGetGradeItems = value);
      });
      courseContentFuture = CourseContentsRequest(widget._courseId).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: UIData.background,
      appBar: AppBarCustom(
        size: deviceSize,
        title: widget._fullname,
        image: "assets/images/sinh-hoc.jpg",
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: FutureBuilder<List<CourseContentsResponse>>(
          future: courseContentFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // FIXME I always get topic 1 here -> show all to user select
              // ignore: unnecessary_statements
              List<Widget> listCustomCard = snapshot.data
                  .where((element) => element.section != 0)
                  .map((e) => _customCard(
                      context, deviceSize, images, widget._courseId, e))
                  .toList();
              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: listCustomCard)));
            } else if (snapshot.hasError) {
              return Text("error");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _customCard(BuildContext context, Size deviceSize, String image,
      int courseId, CourseContentsResponse courseContents) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QuizGames(courseContents.modules, courseContents.name),
          ));
        },
        child: Material(
          color: Color(0xFFFFFFFF),
          elevation: 10.0,
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Container(
                    // changing from 200 to 150 as to look better
                    height: 75.0,
                    width: 75.0,
                    child: ClipOval(
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          image,
                        ),
                      ),
                    ),
                  ),
                ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            width: deviceSize.width * 0.52,
                            child: Text(
                              courseContents.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: "Quando",
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Container(
                            padding:
                                EdgeInsets.only(left: 16, top: 0, bottom: 0),
                            child: SizedBox(
                              width: 60,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 0.0),
                                shape: StadiumBorder(),
                                child: Icon(
                                  Icons.stacked_bar_chart,
                                  color: Colors.white,
                                ),
                                color: const Color(0xFF232133),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DashboardCourse(
                                        getGradeReportUserGetGradeItems(
                                            courseContents.modules),
                                        courseContents.name),
                                  ));
                                },
                              ),
                            )),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 0, bottom: 0),
                      // width: deviceSize.width*0.7,
                      child: Center(
                        child: Text(
                          '06/03/2020',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontFamily: "Alike"),
                          textAlign: TextAlign.justify,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                        width: deviceSize.width * 0.72,
                        child: Html(data: courseContents.summary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<GraderReportUserGetGradeItems> getGradeReportUserGetGradeItems(
      List<Module> modules) {
    List<GraderReportUserGetGradeItems> res = [];
    for (GraderReportUserGetGradeItems i in gradeReportUserGetGradeItems) {
      for (Module module in modules) {
        if (module.id == i.moduleid) {
          res.add(i);
          break;
        }
      }
    }
    return res.toList();
  }
}
