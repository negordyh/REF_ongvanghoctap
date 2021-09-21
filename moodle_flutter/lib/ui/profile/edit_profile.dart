import 'package:flutter/material.dart';
import 'package:moodle_flutter/moodle/core/core_user_get_users_by_field.dart';
import 'package:moodle_flutter/moodle/core/core_user_update_user.dart';
import 'package:moodle_flutter/ui/components/alert_dialog.dart';
import 'package:moodle_flutter/ui/components/text_field.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';
import 'package:moodle_flutter/utils/ui_data.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileDialog extends StatefulWidget {
  static final reloadUserInfoSubject = PublishSubject<bool>();

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  int _value = 1;
  CoreUserGetUserByFieldResponse user;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(top: 100, bottom: 16, right: 16, left: 16),
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
                    AppLocalizations.of(context).translate('edit_profile'),
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppLocalizations.of(context).translate('name'),
                    ),
                  ),
                  TextFieldContainer(
                      child: TextField(
                    controller: nameController,
                  )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Email"),
                  ),
                  TextFieldContainer(
                      child: TextField(
                    controller: emailController,
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('phone_number'),
                            ),
                          ),
                          TextFieldContainer(
                              width: 0.4,
                              child: TextField(
                                controller: phoneController,
                              )),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              AppLocalizations.of(context).translate('gender'),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: DropdownButton(
                              dropdownColor: UIData.kPrimaryColor,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              value: _value,
                              items: <DropdownMenuItem<int>>[
                                new DropdownMenuItem(
                                  child: new Text('Nam'),
                                  value: 1,
                                ),
                                new DropdownMenuItem(
                                  child: new Text('Nữ'),
                                  value: 0,
                                ),
                              ],
                              onChanged: (int value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
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
                          onPressed: () {
                            updateInfoUser();
                          },
                          child: Text('Lưu'),
                        ),
                      ),
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
                backgroundImage: AssetImage("assets/images/alert_gif.gif"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getUser() async {
    this.user = await CoreUserGetUserByFieldRequest().fetchUsingTokenAdmin();
    setState(() {
      this.nameController.text = user.fullName;
      this.emailController.text = user.email;
      this.phoneController.text = user.phone1;
    });
  }

  void updateInfoUser() async {
    CoreUserGetUserByFieldResponse userInfo = CoreUserGetUserByFieldResponse(
        id: user.id,
        username: user.username,
        fullName: nameController.text,
        email: emailController.text,
        phone1: phoneController.text);
    var request =
        await CoreUserUpdateUserRequest(userInfo).fetchUsingTokenAdmin();
    if (request == null || request == "" || request == "null") {
      SharePrefs.saveUserInfo(userInfo);
      EditProfileDialog.reloadUserInfoSubject.add(true);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: AppLocalizations.of(context).translate('update_info'),
          description: AppLocalizations.of(context)
              .translate('update_info_successfully'),
          isLogOut: false,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: AppLocalizations.of(context).translate('update_info'),
          description: 'Cập nhật thất bại.',
          isLogOut: false,
        ),
      );
    }
  }
}
