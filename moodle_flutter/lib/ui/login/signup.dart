import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:moodle_flutter/ui/login/components/already_have_account.dart';
import 'package:moodle_flutter/ui/login/background.dart';
import 'package:moodle_flutter/ui/components/text_field.dart';
var logger = Logger();
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle _textWellComeStyle = TextStyle(
      fontFamily: 'Quicksand',
      fontWeight: FontWeight.w900,
      color: Colors.black87,
      fontSize: 25);
  TextStyle _textStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Size deviceSize;

  // String _username = "admin";
  // String _password = "Moodle-2020";
  String _username = "phantue2002";
  String _password = "PhanTue@BK2020";

  String _error = "";

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: const Color(0xFF98CEEF),
        resizeToAvoidBottomInset: false,
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: deviceSize.height * 0.4),
                _textField("Username", _textStyle, false),
                _textField("Password", _textStyle, true),
                // _buttonLogin(0, "Login"),
                SizedBox(height: deviceSize.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // return SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
  Widget _textField(String hintText, TextStyle style, bool isPassword) =>
      Container(
        padding: EdgeInsets.only(
            left: deviceSize.width*0.15,
            right: deviceSize.width*0.15,
            top: 4.0,
            bottom: 4.0
        ),
        child: TextFieldContainer(
          child: TextField(
              controller: new TextEditingController(
                  text: isPassword ? '' : ''.toLowerCase()),
              obscureText: isPassword,
              style: style,
              onChanged: (stringChange) => {
                isPassword
                    ? _password = stringChange
                    : _username = stringChange
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                  hintText: hintText,
                  icon: Icon(
                      isPassword
                          ? Icons.lock
                          : Icons.person

                    // color: Colors.black,
                  ),
                  border: InputBorder.none)),
        ),
      );
}