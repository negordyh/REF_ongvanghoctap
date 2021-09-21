import 'package:flutter/material.dart';
import 'package:moodle_flutter/ui/signup/components/social_icon.dart';
import 'package:moodle_flutter/ui/components/input_dialog.dart';

class SocialLogin extends StatelessWidget {
  final Function loginPhone;
  SocialLogin({this.loginPhone});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SocalIcon(
            iconSrc: "assets/icons/icon-facebook.png",
            press: (){},
          ),
          SocalIcon(
            iconSrc: "assets/icons/icon-google.png",
            press: (){},
          ),
          SocalIcon(
            iconSrc: "assets/icons/icon-phone-number.png",
            press: () {
              return showDialog(
                context: context,
                builder: (context)=> InputDialog(
                  title: 'Nhập số điện thoại',
                  description: 'You will be returned to the login screen.',
                  press: loginPhone,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
