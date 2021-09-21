import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moodle_flutter/main.dart';
import 'package:moodle_flutter/moodle/core/core_user_get_users_by_field.dart';
import 'package:moodle_flutter/ui/components/alert_dialog.dart';
import 'package:moodle_flutter/ui/components/index.dart';
import 'package:moodle_flutter/ui/profile/faq_webview.dart';
import 'package:moodle_flutter/ui/stats/dashboard_overview_grades.dart';
import 'package:moodle_flutter/ui/stats/dashboarf_overview_time.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:moodle_flutter/utils/l10n.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/service/authenticate_service.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';
import 'package:provider/provider.dart';

import 'edit_profile.dart';
import 'locale_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool turnOnNotification = false;
  bool turnOnLocation = false;
  CoreUserGetUserByFieldResponse userInfo;

  @override
  void initState() {
    super.initState();
    EditProfileDialog.reloadUserInfoSubject.listen((value) {
      logger.i('Is reload data $value');
      if (value)
        SharePrefs.getUserInfo()
            .then((value) => setState(() => userInfo = value));
    });
    SharePrefs.getUserInfo().then((value) => setState(() => userInfo = value));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFFE8ECF0),
        appBar: null,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: size.height * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
              image: DecorationImage(
                image: AssetImage("assets/images/background_home.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 24.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: size.height * 0.18,
                      width: size.height * 0.18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75.0),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3.0,
                              offset: Offset(0, 4.0),
                              color: Colors.black38),
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/avt.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Flexible(
                          child: Container(
                            width: size.width * 0.45,
                            child: Text(
                              userInfo == null
                                  ? AppContext.user.username
                                  : userInfo.fullName,
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        (userInfo != null &&
                                userInfo.phone1 != null &&
                                userInfo.phone1.isNotEmpty)
                            ? Text(
                                "SĐT: ${userInfo.phone1}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('account'),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          elevation: 3.0,
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                            child: Column(
                              children: <Widget>[
                                CustomListTile(
                                    icon: Icons.account_circle_outlined,
                                    text: AppLocalizations.of(context)
                                        .translate('edit_profile'),
                                    press: () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            EditProfileDialog())),
                                Divider(
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                                CustomListTile(
                                    icon: Icons.timeline_outlined,
                                    text: AppLocalizations.of(context)
                                        .translate('quiz_review'),
                                    press: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              DashboardCourse(),
                                        ))),
                                Divider(
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                                CustomListTile(
                                  icon: Icons.timer,
                                  text: AppLocalizations.of(context)
                                      .translate('time_on_app'),
                                  press: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LineChartStat())),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('about_us'),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          elevation: 3.0,
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                            child: Column(
                              children: <Widget>[
                                CustomListTile(
                                    icon: Icons.question_answer_outlined,
                                    text: "FAQ",
                                    press: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => FAQWebview(
                                              "http://ongvanghoctap.edu.vn/mod/forum/discuss.php?d=1#p1")));
                                    }),
                                Divider(
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                                CustomListTile(
                                  icon: Icons.share_outlined,
                                  text: AppLocalizations.of(context)
                                      .translate('share_app'),
                                ),
                                Divider(
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                                CustomListTile(
                                  icon: Icons.how_to_vote_outlined,
                                  text: AppLocalizations.of(context)
                                      .translate('rate_app'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('setting'),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Card(
                      elevation: 3.0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('noti_app'),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Switch(
                                  value: turnOnNotification,
                                  onChanged: (bool value) async {
                                    setState(() {
                                      turnOnNotification = value;
                                      _showNotification();
                                    });
                                  },
                                ),
                              ],
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    AppLocalizations.of(context)
                                        .translate('language'),
                                    style: TextStyle(fontSize: 16.0)),
                                LanguagePickerWidget(),
                              ],
                            ),
                            // SizedBox(height: 10.0,),
                            Divider(
                              height: 30.0,
                              color: Colors.grey,
                            ),
                            CustomListTile(
                              icon: Icons.power_settings_new,
                              press: () => showDialog(
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    title: AppLocalizations.of(context).translate('logout'),
                                    description:
                                    AppLocalizations.of(context).translate('description_logout'),
                                    isLogOut: true,
                                  ),
                              ),
                              // (() async {
                              //   await AuthenticateService.logout();
                              //   Navigator.canPop(context)
                              //       ? Navigator.pop(context)
                              //       : Navigator.pushReplacementNamed(
                              //           context, "/login");
                              // }),
                              text: AppLocalizations.of(context)
                                  .translate('logout'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ]));
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('receive notifi', 'receive notification',
            'show notify when user change status receive notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Ong vàng học tập',
        'Bạn đã ${turnOnNotification ? 'bật' : 'tắt'} thông báo từ Ong vàng',
        platformChannelSpecifics,
        payload: 'item x');
  }
}

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      value: locale,
      items: L10n.all.map((locale) {
        final flag = L10n.getFlag(locale.languageCode);
        return DropdownMenuItem(
          child: Center(
            child: Text(
              flag,
            ),
          ),
          value: locale,
          onTap: () {
            final provider =
                Provider.of<LocaleProvider>(context, listen: false);
            provider.setLocate(locale);
          },
        );
      }).toList(),
      onChanged: (_) {},
    ));
  }
}
