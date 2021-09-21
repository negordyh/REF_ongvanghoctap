import 'package:flutter/material.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';

class CustomErrorDialog extends StatelessWidget {
  final String title, description, buttonText;
  CustomErrorDialog({
    this.title,
    this.description,
    this.buttonText,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 100, bottom: 16, right: 16, left: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                  shape: StadiumBorder(),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  color: Color(0xFFFF7D80),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.redAccent,
            radius: 50,
            backgroundImage: AssetImage("assets/images/error_gif.gif"),
          ),
          // child: ClipOval(
          //   child: CircleAvatar(
          //     backgroundColor: Colors.blueAccent,
          //     radius: 60,
          //     backgroundImage: AssetImage(image),
          //   ),
          // ),
        ),
      ],
    );
  }
}
