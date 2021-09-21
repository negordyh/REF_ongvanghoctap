import 'package:flutter/material.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_enrolled_courses_by_timeline_classification.dart';
import 'package:moodle_flutter/moodle/gradereport/gradereport_overview_get_course_grades.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';

class DashboardCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DashboardCourseState();
}

class DashboardCourseState extends State<DashboardCourse> {
  List<GraderReportCourseGrade> gradeReportItems;
  List<CoursesEnrolledOfUser> courseEnrolledUsers;

  @override
  void initState() {
    super.initState();
    getDatacourseEnrolledUsers();
  }

  void getDatacourseEnrolledUsers() async {
    courseEnrolledUsers = await SharePrefs.getListCoursesEnrolledOfUser();
    GraderReportCourseGradeRequest().fetch().then((value) {
      setState(() {
        gradeReportItems = value.map((item) {
          List<CoursesEnrolledOfUser> courseFilter = courseEnrolledUsers
              .where((course) => course.id == item.courseid)
              .toList();
          item.courseName =
              courseFilter.isNotEmpty ? courseFilter.first.fullName : '';
          return item;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d(gradeReportItems.toString());
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarCustom(
        size: deviceSize,
        title: AppLocalizations.of(context).translate('quiz_review'),
        image: "assets/images/sinh-hoc.jpg",
      ),
      backgroundColor: Color(0xFF232133),
      body: gradeReportItems == null
          ? Center(
              child: Text(
                "Loading",
              ),
            )
          : SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      getCourseStats(context),
                                      SizedBox(height: 16.0),
                                      // getChartStat(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget getChartStat() {
  //   return Container(
  //     padding: EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white60,
  //       borderRadius: const BorderRadius.all(Radius.circular(10)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Chart",
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         SizedBox(height: 16.0),
  //         Chart(),
  //       ],
  //     ),
  //   );
  // }

  Widget getCourseStats(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 16.0),
        gradeReportItems.length == 0
            ? Container()
            : GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: gradeReportItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) =>
                    statsCard(context, gradeReportItems[index]),
              )
      ],
    );
  }

  Widget statsCard(BuildContext context, GraderReportCourseGrade info) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0x81138981),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: _size.width * 0.55,
                  child: Text(
                    info.courseName,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Text(
                            "${info.rawgrade.toStringAsFixed(2)}",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "điểm",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.cyan, fontSize: 15),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
          // progressLine(
          //   Color(0xFF007EE5),
          //   info.graderaw / info.grademax,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "${info.grademin}",
          //       style: Theme.of(context)
          //           .textTheme
          //           .caption
          //           .copyWith(color: Colors.white70),
          //     ),
          //     Text(
          //       "${info.grademax} điểm",
          //       style: Theme.of(context)
          //           .textTheme
          //           .caption
          //           .copyWith(color: Colors.white),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget progressLine(Color color, double percentage) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * percentage,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
