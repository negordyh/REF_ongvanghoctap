import 'package:flutter/material.dart';
import 'package:moodle_flutter/utils/service/authenticate_service.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, image;
  final bool isLogOut;
  CustomDialog({this.title, this.description, this.buttonText, this.image, this.isLogOut});
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
                )
              ]),
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
              Text(description, style: TextStyle(fontSize: 16.0)),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        if (isLogOut == true) {
                          await AuthenticateService.logout();
                          Navigator.canPop(context) ? Navigator.pop(context) : Navigator.pushReplacementNamed(context, "/login");
                        }
                      },
                      child: Text('Confirm'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 50,
            backgroundImage: AssetImage("assets/images/alert_gif.gif"),
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
