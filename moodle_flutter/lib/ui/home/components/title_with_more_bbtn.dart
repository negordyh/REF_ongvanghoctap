import 'package:flutter/material.dart';
import 'package:moodle_flutter/utils/language.dart';

import 'package:moodle_flutter/utils/ui_data.dart';
class TitleWithMoreBtn extends StatefulWidget {
  TitleWithMoreBtn({
    Key key,
    this.title,
    this.press,
  }) : super(key: key);
  final String title;
  final Function press;
  @override
  _TitleWithMoreBtnState createState() => _TitleWithMoreBtnState(title, press);
}

class _TitleWithMoreBtnState extends State<TitleWithMoreBtn> {
  final String title;
  final Function press;
  _TitleWithMoreBtnState(this.title, this.press);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIData.kDefaultPadding*0.8),
      child: Row(
        children: <Widget>[
          TitleWithCustomUnderline(text: title),
          Spacer(),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            onPressed: press,
            child: Text(
              AppLocalizations.of(context).translate('more'),
              style: TextStyle(color: Color(0xFFEA7A13)),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: UIData.kDefaultPadding / 4),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: UIData.kDefaultPadding / 4),
              height: 5,
              color: Colors.amberAccent.withOpacity(0.4),
            ),
          )
        ],
      ),
    );
  }
}
