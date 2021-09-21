import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moodle_flutter/init_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moodle_flutter/ui/main_screen/bottom_navigation_controller.dart';
import 'package:moodle_flutter/ui/main_screen/receive_notification.dart';
import 'package:moodle_flutter/ui/dashboard_courses/dashboard_course.dart';
import 'package:moodle_flutter/ui/home/load_more.dart';
import 'package:moodle_flutter/ui/login/login_screen.dart';
import 'package:moodle_flutter/ui/profile/locale_provider.dart';
import 'package:moodle_flutter/ui/profile/profile.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moodle_flutter/utils/l10n.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
String selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = MyHomeWidget.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = HomePage.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      logger.i('Notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  runApp(MyApp(notificationAppLaunchDetails));
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatelessWidget {
  MyApp(this.notificationAppLaunchDetails);
  final NotificationAppLaunchDetails notificationAppLaunchDetails;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);

        return MaterialApp(
            theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF98CEEF)),
            locale: provider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            routes: <String, WidgetBuilder>{
              MyHomeWidget.routeName: (BuildContext context) => MyHomeWidget(notificationAppLaunchDetails),
              HomePage.routeName: (BuildContext context) => HomePage(notificationAppLaunchDetails.payload),
              LoginPage.routeName: (BuildContext context) => LoginPage(),
              '/profile': (BuildContext context) => ProfilePage(),
              '/load_more': (BuildContext context) => LoadMoreScreen(),
            });
      });
}
