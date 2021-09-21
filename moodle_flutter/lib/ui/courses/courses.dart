import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/moodle/core/core_user_get_users_by_field.dart';
import 'package:moodle_flutter/ui/components/alert_error_dialog.dart';
import 'package:moodle_flutter/ui/home/home_screen.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';

// import 'package:moodle_flutter/ui/components/my_bottom_nav_bar.dart';

import './components/carousel_slider.dart';

class CoursesScreen extends StatefulWidget {
  @override
  CoursesScreenState createState() {
    return new CoursesScreenState();
  }
}

class CoursesScreenState extends State<CoursesScreen>
    with WidgetsBindingObserver {
  Future<List<CoursesByFieldResponse>> allCoursesFuture = new Future.value();
  List<CoursesByFieldResponse> allCourses;
  List<Item> _data;

  @override
  void initState() {
    super.initState();
    getAllDataFromPrefs();
    HomeScreen.reloadDataSubject.listen((value) {
      logger.i('Is reload data $value');
      if (value) getAllDataFromPrefs();
    });
  }

  void getAllDataFromPrefs() {
    logger.i('GetAllDataFromPrefs');
    this.allCoursesFuture = SharePrefs.getListCoursesByFieldResponse();
    this.allCoursesFuture.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          allCourses = value;
          _data = generateItems();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFE8ECF0),
      appBar: AppBarCustom(
        size: size,
        title: AppLocalizations.of(context).translate('buy_course'),
        image: "assets/images/payment.jpeg",
      ),
      body: SingleChildScrollView(
        child: _data == null
            ? Container()
            : Container(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: _buildListPanel(),
              ),
      ),
    );
  }

  Widget _buildListPanel() {
    return Container(
      padding: EdgeInsets.all(6),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data = _data.map((e) {
              e.isExpanded = _data.indexOf(e) != index ? false : !isExpanded;
              return e;
            }).toList();
          });
        },
        children: _data.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                child: ListTile(
                  leading: Image.asset("assets/icons/icon-book-shelf-false.png"),
                  title: Text(item.coursecategory),
                ),
              );
            },
            body: Body(courses: item.courses),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }

  List<Item> generateItems() {
    List<Item> itemRes = [];
    Map<String, List<CoursesByFieldResponse>> itemCourseMap = {};

    allCourses.forEach((element) {
      if (itemCourseMap.containsKey(element.categoryname)) {
        List<CoursesByFieldResponse> valueOfcategory =
            itemCourseMap[element.categoryname];
        valueOfcategory.add(element);
        itemCourseMap[element.categoryname] = valueOfcategory;
      } else {
        itemCourseMap[element.categoryname] = [element];
      }
    });
    itemCourseMap.forEach((key, value) {
      itemRes.add(Item(coursecategory: key, courses: value));
    });
    return itemRes;
  }
}

class Item {
  String coursecategory;
  bool isExpanded;
  List<CoursesByFieldResponse> courses;
  Item({this.coursecategory, this.isExpanded = false, this.courses});
}
