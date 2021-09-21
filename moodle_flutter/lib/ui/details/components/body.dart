import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/ui/components/index.dart';
import 'package:moodle_flutter/ui/payment/payment_method.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'index.dart';

class Body extends StatelessWidget {
  final CoursesByFieldResponse course;

  const Body({Key key, @required this.course}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // ProductImages(course: course),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: Text(
                          course.categoryname,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Text(
                              AppLocalizations.of(context).translate('summary'),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 34,
                          ),
                          child: Html(data: course.summary),
                        ),
                      ],
                    ),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context).translate('contacts'),
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      child: Text(
                                        course.contacts.join(", "),
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          TopRoundedContainer(
                            color: Color(0xFFF6F7F9),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.only(left: 20, ),
                                          child: Text(
                                            AppLocalizations.of(context).translate('price'),
                                            style: Theme.of(context).textTheme.headline6,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsets.only(top: 10.0, left: 20 , bottom: 20),
                                          child: Text(
                                            course.price.toString(),
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10,)
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 30.0,
                                      left: 60.0,
                                      right: 60.0),
                                  child: DefaultButton(
                                    text: AppLocalizations.of(context).translate('checkout'),
                                    press: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentMethod(
                                                    course: course,
                                                  )));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
