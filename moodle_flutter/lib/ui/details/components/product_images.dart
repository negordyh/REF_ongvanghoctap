import 'package:flutter/material.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/utils/app_context.dart';
class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.course,
  }) : super(key: key);

  final CoursesByFieldResponse course;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  Size deviceSize;
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: deviceSize.height*0.20,
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.course.id.toString(),
              child: Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.course.imageUrl + '?token=' + AppContext.user.token),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            ),
          ),
        ),
      ],
    );
  }

}
