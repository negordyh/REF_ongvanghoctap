import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_enrolled_courses_by_timeline_classification.dart';
import 'package:moodle_flutter/ui/course_contents/list_lesson_of_courses.dart';
import 'package:moodle_flutter/ui/details/details_screen.dart';
import 'package:moodle_flutter/utils/app_context.dart';

import 'package:moodle_flutter/utils/ui_data.dart';
import 'dart:typed_data';
import 'dart:convert';

class RecentlyCourses extends StatefulWidget {
  final List<CoursesEnrolledOfUser> courses;

  RecentlyCourses(this.courses);

  @override
  _RecentlyCoursesState createState() => _RecentlyCoursesState();
}

class _RecentlyCoursesState extends State<RecentlyCourses> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.26,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.courses.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () => {
                      AppContext.updateCourseRecentlyUser(
                          this.widget.courses[index].id),
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ListLessonWidget(
                              this.widget.courses[index].id,
                              this.widget.courses[index].fullName)))
                    },
                child: RecommendedCourseCard(
                  image: this.widget.courses[index].imageUrl,
                  title: this.widget.courses[index].shortName,
                ));
          }),
    );
  }
}

class RecommendedCourseCard extends StatelessWidget {
  const RecommendedCourseCard({
    Key key,
    this.image,
    this.title,
  }) : super(key: key);

  final String image, title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    Uint8List bytes = null;
    var base64 = Base64Codec();
    const typeBase64String = 'base64,';
    String imageType = image.split(typeBase64String)[0];
    if (image.contains(typeBase64String)) {
      bytes = base64Decode(image.split(typeBase64String)[1].trim());
    }
    return Container(
      margin: EdgeInsets.only(
        left: UIData.kDefaultPadding / 2,
        top: UIData.kDefaultPadding / 5,
        bottom: UIData.kDefaultPadding / 5,
      ),
      height: size.height * 0.18,
      width: size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: size.height * 0.18,
              width: size.width * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image == ''
                      ? AssetImage("assets/images/dia-ly.png")
                      : bytes == null
                        ? NetworkImage(image + '?token=' + AppContext.user.token)
                        : imageType.toLowerCase().contains('svg')
                          ? AssetImage("assets/images/dia-ly.png")
                          : MemoryImage(bytes),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(
                top: UIData.kDefaultPadding / 2,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: size.width * 0.4,
                    child: Text(
                      "$title\n".toUpperCase(),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
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
