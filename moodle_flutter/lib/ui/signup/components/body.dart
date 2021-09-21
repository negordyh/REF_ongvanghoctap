import 'package:flutter/material.dart';
import 'package:moodle_flutter/ui/Login/login_screen.dart';
import 'package:moodle_flutter/ui/components/social_login.dart';
import 'package:moodle_flutter/ui/login/background.dart';
import 'package:moodle_flutter/ui/signup/components/or_divider.dart';
import 'package:moodle_flutter/ui/login/components/already_have_account.dart';
import 'package:moodle_flutter/ui/login/components/rounded_button.dart';
import 'package:moodle_flutter/ui/login/components/username_field.dart';
import 'package:moodle_flutter/ui/login/components/password_field.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.45),
            RoundedInputField(
              hintText: "Username",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.pop(context);
              },
            ),
            OrDivider(),
            SocialLogin(),
          ],
        ),
      ),
    );
  }
}
