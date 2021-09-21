import 'package:flutter/material.dart';
import 'package:moodle_flutter/utils/ui_data.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double width ;
  const TextFieldContainer({
    Key key,
    this.child,
    this.width = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * width,
      decoration: BoxDecoration(
        color: UIData.kPrimaryColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}