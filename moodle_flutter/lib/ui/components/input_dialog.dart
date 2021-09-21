import 'package:flutter/material.dart';
import 'package:moodle_flutter/ui/components/index.dart';
class InputDialog extends StatelessWidget {
  final String title, description, buttonText, image;
  final TextEditingController myController;
  final Function press;
  InputDialog({this.title, this.description, this.buttonText, this.image, this.press, this.myController});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
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
                TextFieldContainer(
                    child: TextField(
                      controller: myController,
                    )
                ),
                SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    onPressed: press,
                    child: Text('Confirm'),
                  ),
                )
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
      ),
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
              TextFieldContainer(
                child: TextField(
                  controller: myController,
                )
              ),
              SizedBox(
                height: 24,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  onPressed: press,
                  child: Text('Confirm'),
                ),
              )
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
