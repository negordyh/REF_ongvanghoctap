import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/ui/details/details_screen.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'dart:math';

import 'package:moodle_flutter/utils/language.dart';

class Body extends StatefulWidget {
  final List<CoursesByFieldResponse> courses;
  Body(this.courses);
  @override
  _BodyState createState() => new _BodyState();
}

var cardAspectRatio = 12.0 / 18.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _BodyState extends State<Body> {
  var currentPage = 0.0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PageController controller =
        PageController(initialPage: this.widget.courses.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return
      SingleChildScrollView(
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              CardScrollWidget(
                  currentPage: currentPage, courses: this.widget.courses),
              Positioned.fill(
                child: PageView.builder(
                  itemCount: this.widget.courses.length ?? 0,
                  controller: controller,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return Container();
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Html(
                data: this.widget.courses[currentPage.toInt()].summary,
                style: {
                  "body": Style(
                    fontSize: FontSize(20.0),
                    fontWeight: FontWeight.bold,
                  ),
                  "strong": Style(
                    fontSize: FontSize(20.0),
                    fontWeight: FontWeight.bold,
                  ),
                  "span": Style(
                    fontSize: FontSize(20.0),
                    fontWeight: FontWeight.bold,
                  ),
                  "b": Style(
                    fontSize: FontSize(20.0),
                    fontWeight: FontWeight.bold,
                  ),
                },
              )),
          TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                          this.widget.courses[currentPage.toInt()]))),
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Text(
                    'Ghi danh',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))),
        ]),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;
  final List<CoursesByFieldResponse> courses;
  CardScrollWidget({Key key, this.currentPage, this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 45;
        var safeHeight = height - 40;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < this.courses.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: this.courses[i].imageUrl == ''
                                      ? AssetImage("assets/images/dia-ly.png")
                                      : NetworkImage(this.courses[i].imageUrl +
                                          '?token=' +
                                          AppContext.user.token),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText(
                                  this.courses[i].shortName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            if (this.courses[i].categoryname != '')
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: AutoSizeText(
                                    this.courses[i].categoryname,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                    maxLines: 8,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText(
                                  this.courses[i].fullName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
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
                                    AppLocalizations.of(context).translate('price')+': ${this.courses[i].price}đ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
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
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text(
                                  'Discount: ${this.courses[i].discount}',
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
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
