import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moodle_flutter/ui/main_screen/bottom_navigation_controller.dart';
import 'package:moodle_flutter/ui/main_screen/receive_notification.dart';

import 'package:moodle_flutter/ui/login/login_screen.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';
import 'package:moodle_flutter/utils/dynamic_link_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'main.dart';

class MyHomeWidget extends StatefulWidget {
  static const String routeName = "/";

  MyHomeWidget(this.notificationAppLaunchDetails);
  final NotificationAppLaunchDetails notificationAppLaunchDetails;
  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  MyHomeWidgetState createState() => MyHomeWidgetState();
}

class MyHomeWidgetState extends State<MyHomeWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    this.checkSession();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        HomePage(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.pushNamed(context, HomePage.routeName);
    });
  }

  Future<void> _repeatNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            '0', 'Test Repeat Notify Name', 'Test Repeat Notify Body');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Ong vàng học tập',
        'Test Notifycation',
        RepeatInterval.everyMinute,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  Future<void> _scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Ong vàng học tập',
        'Cùng nhau ôn lại kiến thức mới nhé',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'schedule10AM', '10AM Every day', 'Remind learning'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 6, 42);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.i('App state = $state');
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        DynamicLinkService.retrieveDynamicLink(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _repeatNotification();
    _scheduleDailyTenAMNotification();
    return Scaffold();
  }

  void checkSession() async {
    bool isvalid = await SharePrefs.isSessionTokenValid();
    if (mounted) {
      setState(() {
        if (isvalid) {
          logger.d("To Home");
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          logger.d("To Login");
          Navigator.pushReplacementNamed(context, "/login");
        }
      });
    }
  }
}
