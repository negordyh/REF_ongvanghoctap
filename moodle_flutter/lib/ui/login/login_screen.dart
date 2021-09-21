import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:moodle_flutter/moodle/authenticate/login_service.dart';
import 'package:moodle_flutter/moodle/authenticate/signup_service.dart';
import 'package:moodle_flutter/ui/components/alert_error_dialog.dart';
import 'package:moodle_flutter/ui/components/social_login.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/service/authenticate_service.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';
import 'package:moodle_flutter/utils/ui_data.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:moodle_flutter/ui/components/alert_dialog.dart';
import 'package:moodle_flutter/ui/components/input_dialog.dart';
import 'package:moodle_flutter/ui/login/components/already_have_account.dart';
import 'package:moodle_flutter/ui/login/background.dart';
import 'package:moodle_flutter/ui/components/text_field.dart';
import 'package:moodle_flutter/ui/signup/signup_screen.dart';
import 'package:moodle_flutter/ui/signup/components/or_divider.dart';
import 'package:moodle_flutter/ui/signup/components/social_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger();
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
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

  TextEditingController myController = TextEditingController();

  String buttonConfirmText = CONFIRM_STRING;
  static const String CONFIRM_STRING = "Confirm";
  static const String LOGIN_STRING = "Login";
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFF98CEEF),
        resizeToAvoidBottomInset: false,
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _wellComeText("Chào mừng đến với ${UIData.appName}",
                    _textWellComeStyle, 0.17),
                SizedBox(height: deviceSize.height * 0.4),
                _textField("Tài khoản", _textStyle, false),
                _textField("Mật khẩu", _textStyle, true),
                _buttonLogin("Đăng nhập"),
                SizedBox(height: deviceSize.height * 0.03),
                // AlreadyHaveAnAccountCheck(
                //   press: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return SignUpScreen();
                //         },
                //       ),
                //     );
                //   },
                // ),
                OrDivider(),
                Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SocalIcon(
                      //   iconSrc: "assets/icons/icon-facebook.png",
                      //   press: () {},
                      // ),
                      SocalIcon(
                        iconSrc: "assets/icons/icon-google.png",
                        press: () => _signInWithGoogle(),
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/icon-phone-number.png",
                        press: () {
                          showUIInputPhone();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showUIInputPhone() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 100, bottom: 16, right: 16, left: 16),
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
                          'Nhập số điện thoại',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFieldContainer(
                            child: TextField(
                          controller: myController,
                        )),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    buttonConfirmText = CONFIRM_STRING;
                                    myController.text = "";
                                  });
                                }
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                                onPressed: () {
                                  buttonConfirmText == CONFIRM_STRING
                                      ? _sendOTP()
                                      : _sentCodeReceive();
                                },
                                child: Text(buttonConfirmText))
                          ],
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
                      backgroundImage:
                          AssetImage("assets/images/alert_gif.gif"),
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget _transformImage(double dyPercent, String assetImage) =>
      Transform.translate(
        offset: Offset(0, deviceSize.height * dyPercent),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(assetImage),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      );

  Widget _wellComeText(
          String text, TextStyle textStyle, double paddingTopPercent) =>
      Container(
          // padding: EdgeInsets.only(top: deviceSize.height * paddingTopPercent),
          width: double.infinity,
          child: Text(text, style: _textStyle, textAlign: TextAlign.center));

  Widget _textField(String hintText, TextStyle style, bool isPassword) =>
      Container(
        padding: EdgeInsets.only(
          left: deviceSize.width * 0.15,
          right: deviceSize.width * 0.15,
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
                  contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                  hintText: hintText,
                  icon: Icon(isPassword ? Icons.lock : Icons.person

                      // color: Colors.black,
                      ),
                  border: InputBorder.none)),
        ),
      );

  Widget _buttonLogin(String title) => RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 50.0),
        shape: StadiumBorder(),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        color: const Color(0xFF425DAE),
        onPressed: () {
          _loginByUserNameAndPass(_username, _password, false);
        },
      );

  /// ----------------------------------------------------------
  /// ----------------LOGIN BY USERNAME PASSWORD ---------------
  /// ----------------------------------------------------------

  void _loginByUserNameAndPass(
      String username, String password, bool isUseFirebase) {
    LoginRequest(username, password).fetch().then((value) async {
      logger.d(value);
      if (value.token != null && value.token.isNotEmpty) {
        SharePrefs.setSessionToken(username, value.token, password);
        Navigator.pushNamed(context, '/home');
        _showCustomDialog(context);
      } else {
        if (!isUseFirebase) {
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              title: 'Đăng nhập không thành công',
              description: 'Vui lòng kiểm tra lại tài khoản và mật khẩu',
            ),
          );
        } else {
          SignUpRequest(username, password)
              .fetchUsingTokenAdmin()
              .then((value) => {
                    if (value.id != null)
                      {
                        LoginRequest(username, password)
                            .fetch()
                            .then((value) async {
                          if (value.token != null && value.token.isNotEmpty) {
                            SharePrefs.setSessionToken(
                                username, value.token, password);
                            Navigator.pushNamed(context, '/home');
                          } else {
                            logger.e("Login again error");
                            _showCustomErrorDialog(context);
                          }
                        })
                      }
                    else {
                      logger.e("Sign up error"),
                      _showCustomErrorDialog(context)}
                  });
        }
      }
    }, onError: (error){
      logger.e("Login error");
      _showCustomErrorDialog(context);
      logger.e('$error');
    });
  }

  void _showCustomDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Đăng nhập thành công',
        description: 'Chào mừng bạn đến tới Ong vang hoc tap',
      ),
    );
  }

  void _showCustomErrorDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => CustomErrorDialog(
        title: AppLocalizations.of(context).translate('ong_vang'),
        description: AppLocalizations.of(context).translate('description_wrong'),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// ----------------LOGIN BY PHONE NUMBER --------------------
  /// ----------------------------------------------------------

  void _loginByPhoneNo() async {
    if (_auth.currentUser != null) {
      User user = _auth.currentUser;
      logger.i(user.toString());
      _loginByUserNameAndPass(user.phoneNumber.replaceFirst("+84", "0"),
          user.uid + "0-" + user.phoneNumber.replaceFirst("+84", "0"), true);
    }
  }

  String _verificationId = "";
  UserCredential userCredential;

  void _sendOTP() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: myController.text.contains("+84")
          ? myController.text
          : myController.text.replaceFirst("0", "+84"),
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        logger.i("verifyPhoneNumber");
        logger.d(credential.smsCode);
        logger.d(credential.token);
        logger.d(credential.verificationId);
        logger.d(credential.providerId);
        logger.d(credential.signInMethod);
        myController.text = credential.smsCode;
        userCredential = await _auth.signInWithCredential(credential);
        if (mounted) {
          setState(() {
            buttonConfirmText = CONFIRM_STRING;
            myController.text = "";
          });
        }
        Navigator.pop(context);
        _loginByPhoneNo();
      },
      verificationFailed: (FirebaseAuthException e) {
        logger.i("verificationFailed");
        logger.e(e);
        if (mounted) {
          setState(() {
            buttonConfirmText = CONFIRM_STRING;
          });
        }
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        logger.i("codeSent");
        if (mounted) {
          setState(() {
            buttonConfirmText = LOGIN_STRING;
            myController.text = "";
          });
        }
        logger.d(verificationId);
        _verificationId = verificationId;
        logger.d(resendToken);
        Navigator.pop(context);
        showUIInputPhone();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        logger.i("codeAutoRetrievalTimeout");
        logger.d(verificationId);
      },
    );
    if (mounted) {
      setState(() {
        buttonConfirmText = CONFIRM_STRING;
      });
    }
  }

  void _sentCodeReceive() async {
    String smsCode = myController.text;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    userCredential = await _auth.signInWithCredential(phoneAuthCredential);
    Navigator.pop(context);
    setState(() {
      buttonConfirmText = CONFIRM_STRING;
      myController.text = "";
    });
    _loginByPhoneNo();
  }

  /// ----------------------------------------------------------
  /// ----------------LOGIN BY GOOGLE ACCOUNT ------------------
  /// ----------------------------------------------------------

  void _signInWithGoogle() async {
    try {
      await AuthenticateService.logout();
      UserCredential userCredential;

      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      final user = userCredential.user;
      if (user != null) {
        _loginByUserNameAndPass(user.email, user.uid + user.email, true);
      }
    } catch (e) {
      logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: ${e}"),
      ));
    }
  }

  /// ----------------------------------------------------------
  /// ----------------LOGIN BY GOOGLE ACCOUNT ------------------
  /// ----------------------------------------------------------

  void _signInWithFacebook() async {
    try {
      // AccessToken accessToken = await FacebookAuth.instance.accessToken;
      final AccessToken result = await FacebookAuth.instance.accessToken;
      final AuthCredential credential = FacebookAuthProvider.credential(
        result.token,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign In ${user.uid} with Facebook"),
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Facebook: ${e}"),
      ));
    }
  }
}
