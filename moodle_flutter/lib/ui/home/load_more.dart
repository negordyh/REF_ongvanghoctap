import 'package:flutter/material.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_enrolled_courses_by_timeline_classification.dart';
import 'package:moodle_flutter/ui/components/index.dart';
import 'package:moodle_flutter/ui/home/components/featurred_plants.dart';
import 'package:moodle_flutter/utils/language.dart';

import 'package:moodle_flutter/utils/ui_data.dart';

class LoadMoreScreen extends StatefulWidget {
  @override
  _LoadMoreScreenState createState() => _LoadMoreScreenState();
}

class _LoadMoreScreenState extends State<LoadMoreScreen> {
  Future<List<CoursesEnrolledOfUser>> coursesFuture = new Future.value();
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
      this.coursesFuture = CoursesEnrolledOfUserRequest().getCoursesEnrolledOfUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFE8ECF0),
      appBar: AppBarCustom(
          size: size,
          title: AppLocalizations.of(context).translate('recommended_courses'),
          image: "assets/images/sinh-hoc.jpg",
        ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<List<CoursesEnrolledOfUser>>(
                        future: this.coursesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CourseEnrolled(snapshot.data.toList());
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return CircularProgressIndicator();
                        }),
                    SizedBox(height: UIData.kDefaultPadding),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Image.asset("assets/icons/icon-id-true.png"),
        onPressed: () {},
      ),
    );
  }
}
