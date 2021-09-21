import 'package:flutter/material.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_enrolled_courses_by_timeline_classification.dart';
import 'package:moodle_flutter/ui/course_contents/list_lesson_of_courses.dart';
import 'package:moodle_flutter/utils/app_context.dart';


class CourseEnrolled extends StatelessWidget {
  final List<CoursesEnrolledOfUser> courses;
  CourseEnrolled(this.courses);

  @override
  Widget build(BuildContext context) {
    if (this.courses == null) {
      return Text('Đang tải ...');
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: getListFeaturePlantCard(this.courses, context)),
    );
  }

  List<Widget> getListFeaturePlantCard(
      List<CoursesEnrolledOfUser> listCoursesEnrolledOfUser,
      BuildContext context) {
    List<Widget> listCourse = new List();
    for (var i = 0; i < listCoursesEnrolledOfUser.length; i++) {
      listCourse.add(Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => {
              AppContext.updateCourseRecentlyUser(this.courses[i].id),
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListLessonWidget(
                      this.courses[i].id, this.courses[i].fullName)))
            },
            child: FeaturePlantCard(
              title: listCoursesEnrolledOfUser[i].shortName,
              image: "assets/icons/icon-book-shelf-false.png",
              des: listCoursesEnrolledOfUser[i].fullName,
              date: listCoursesEnrolledOfUser[i].startdate ?? DateTime.now().millisecondsSinceEpoch ~/ 1000
            ),
          ),
        ],
      ));
    }
    ;
    return listCourse;
  }
}

class FeaturePlantCard extends StatelessWidget {
  const FeaturePlantCard({
    Key key,
    this.title,
    this.image,
    this.des,
    this.date,
  }) : super(key: key);
  final String title;
  final String image;
  final String des;
  final int date;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      child: Material(
        color: Color(0xFFFFFFFF),
        elevation: 10.0,
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          // height: 100.0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Container(
                  // changing from 200 to 150 as to look better
                  height: size.width * 0.25,
                  width: size.width * 0.25,
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
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      width: size.width * 0.63,
                      child: Text(
                        "$title".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: "Quando",
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 0, bottom: 0),
                      child: Text(
                        DateTime.fromMillisecondsSinceEpoch(date * 1000).toIso8601String().substring(0,10),
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            fontFamily: "Alike"),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Flexible(
                      child: Container(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    width: size.width * 0.63,
                    child: Text(des),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
