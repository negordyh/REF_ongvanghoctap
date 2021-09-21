import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/ui/details/details_screen.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:moodle_flutter/utils/language.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
    this.courses,
  }) : super(key: key);

  final List<CoursesByFieldResponse> courses;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 480.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastLinearToSlowEaseIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 3000),
            viewportFraction: 0.98,
          ),
          items: courses.map((course) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.symmetric(horizontal: 6.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                            course))),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: size.height * 0.35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.2),
                                        BlendMode.darken),
                                    image: course.imageUrl == ''
                                        ? AssetImage("assets/images/dia-ly.png")
                                        : NetworkImage(course.imageUrl +
                                            '?token=' +
                                            AppContext.user.token),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 6.0, 16.0, 16.0),
                                child: Text(
                                  course.shortName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              if (course.categoryname != '')
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 0, 15.0, 15.0),
                                  child: Text(
                                    course.categoryname,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                                child: Text(
                                  course.fullName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, bottom: 12.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 22.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius:
                                      BorderRadius.circular(20.0)),
                                  child: Text(
                                    AppLocalizations.of(context).translate('price')+': ${course.price}đ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 12.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius:
                                    BorderRadius.circular(20.0)),
                                child: Text(
                                  'Discount: ${course.discount}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
