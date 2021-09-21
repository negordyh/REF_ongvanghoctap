import 'package:flutter/material.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'components/index.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";
  final CoursesByFieldResponse course;
  DetailsScreen(this.course);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Size deviceSize;
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height * 0.15),
        child: AppBar(
          centerTitle: true,
          title: Text(
            widget.course.fullName,
            maxLines: 2,
            style: TextStyle(
                backgroundColor: Colors.grey.withOpacity(0.3), fontSize: 22),
          ),
          leading: BackButton(
              color: Colors.black
          ),
          flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
              ),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: widget.course.imageUrl != null ? NetworkImage(widget.course.imageUrl + '?token=' + AppContext.user.token) : AssetImage("assets/images/sinh-hoc.jpg"),
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.darken),
                    ),
                ),
              ),
          ),
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Body(course: widget.course),
    );
  }
}
