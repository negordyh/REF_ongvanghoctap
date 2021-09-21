import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodle_flutter/bee_service/course_price.dart';
import 'package:moodle_flutter/bee_service/log_user.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_enrolled_courses_by_timeline_classification.dart';
import 'package:moodle_flutter/moodle/core/core_user_get_users_by_field.dart';
import 'package:moodle_flutter/ui/components/alert_error_dialog.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'components/index.dart';
import 'package:moodle_flutter/ui/home/load_more.dart';
import 'package:moodle_flutter/ui/components/alert_dialog.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/ui_data.dart';
import 'package:moodle_flutter/utils/dynamic_link_service.dart';
import 'package:connectivity/connectivity.dart';

class HomeScreen extends StatefulWidget {
  static final reloadDataSubject = PublishSubject<bool>();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Future<List<CoursesByFieldResponse>> allCoursesFuture = new Future.value();
  List<CoursesByFieldResponse> allCourses;
  Future<List<CoursesEnrolledOfUser>> coursesEnrolledFuture =
      new Future.value();
  List<CoursesEnrolledOfUser> coursesEnrolled;

  List<CoursePrice> listCoursesPrice;
  int targetTime;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getLogUser();
    getAllDataFromPrefs();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      logger.e('$e');
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        logger.i('Connectivity status wifi');
        break;
      case ConnectivityResult.mobile:
        logger.i('Connectivity status mobile');
        break;
      case ConnectivityResult.none:
        logger.i('Connectivity status none');
        if (this.coursesEnrolled == null)
          setState(() => this.coursesEnrolled = []);
        if (this.allCourses == null) setState(() => this.allCourses = []);
        showDialog(
          context: context,
          builder: (context) => CustomErrorDialog(
            title: AppLocalizations.of(context).translate('ong_vang'),
            description: AppLocalizations.of(context)
                .translate('description_disconnect_internet'),
          ),
        );
        break;
      default:
        logger.i('Connectivity status error');
        showDialog(
          context: context,
          builder: (context) => CustomErrorDialog(
            title: AppLocalizations.of(context).translate('ong_vang'),
            description: AppLocalizations.of(context)
                .translate('description_disconnect_internet'),
          ),
        );
        break;
    }
  }

  void getLogUser() async {
    CoreUserGetUserByFieldResponse userInfo = await SharePrefs.getUserInfo();
    if (userInfo == null || userInfo.id == null) {
      logger.i('GetUserInfoFromAPI');
      userInfo = await CoreUserGetUserByFieldRequest().fetchUsingTokenAdmin();
      if (userInfo == null || userInfo.id == null) {
        logger.e("Get user info from  Ong vang fail");
        showDialog(
          context: context,
          builder: (context) => CustomErrorDialog(
            title: AppLocalizations.of(context).translate('ong_vang'),
            description:
                AppLocalizations.of(context).translate('description_wrong'),
          ),
        );
        return;
      } else {
        logger.d('$userInfo');
        SharePrefs.saveUserInfo(userInfo);
      }
    }
    AppContext.user.userId = userInfo.id;
    LogUserRequest.getLogUsersToday().then((value) {
      if (value != null) {
        AppContext.setLogUser(value);
      } else {
        LogUserRequest.getLogUsersToday()
            .then((value) => AppContext.setLogUser(value));
      }
      setState(() => this.targetTime = AppContext.getTargetTimeOnApp());
    });
  }

  void getAllDataFromPrefs() {
    logger.i('GetAllDataFromPrefs');
    this.coursesEnrolledFuture = SharePrefs.getListCoursesEnrolledOfUser();
    this.coursesEnrolledFuture.then((value) {
      if (value.isEmpty) {
        getCourseEnrolledFromAPI();
      } else {
        logger.d('$value');
        setState(() => coursesEnrolled = value);
      }
    });

    this.allCoursesFuture = SharePrefs.getListCoursesByFieldResponse();
    this.allCoursesFuture.then((value) {
      if (value.isEmpty) {
        getAllCourseFromAPI();
      } else {
        setState(() => allCourses = value);
      }
    });
  }

  void getAllCourseFromAPI() {
    logger.i('GetAllCourseFromAPI');
    setState(() {
      this.allCourses = null;
      this.listCoursesPrice = null;
    });
    this.allCoursesFuture = CoursesByFieldRequest().fetch();
    this.allCoursesFuture.then((value) async {
      setState(() => allCourses = value);
      logger.d('$value');
      if (listCoursesPrice != null) {
        mapCoursePrice();
      }
    });
    logger.i('GetCoursePriceFromAPI');
    CoursesPriceRequest.getAllCoursePrices().then((value) {
      listCoursesPrice = value;
      logger.d('$value');
      if (allCourses != null) {
        mapCoursePrice();
      }
    });
  }

  void mapCoursePrice() async {
    for (CoursesByFieldResponse course in allCourses) {
      for (CoursePrice coursesPrice in listCoursesPrice) {
        if (coursesPrice.moodleCourseId == course.id) {
          course.price = coursesPrice.price;
          course.discount = coursesPrice.discount;
        }
      }
    }
    allCourses.removeWhere((element) => element.id == 1);
    if (coursesEnrolled == null || coursesEnrolled.isEmpty) {
      setState(() {
        this.coursesEnrolled = this.allCourses
            .where((element) => element.enrollmentmethods.contains("guest"))
            .map((e) => CoursesEnrolledOfUser.fromJson(CoursesByFieldResponse.toMap(e)))
            .toList();
      });
      await SharePrefs.saveListCoursesEnrolledOfUser(coursesEnrolled);

    }
    if (coursesEnrolled != null && allCourses != null) {
      allCourses.removeWhere((element) {
        for (CoursesEnrolledOfUser courseEnrolled in coursesEnrolled) {
          if (courseEnrolled.id == element.id) {
            return true;
          }
        }
        return false;
      });
    }
    await SharePrefs.saveListCoursesByFieldResponse(allCourses);
    HomeScreen.reloadDataSubject.add(true);
  }

  void getCourseEnrolledFromAPI() {
    logger.i('GetCourseEnrolledFromAPI');
    this.coursesEnrolledFuture =
        CoursesEnrolledOfUserRequest().getCoursesEnrolledOfUser();
    this.coursesEnrolledFuture.then((value) {
      if (value.isNotEmpty) {
        setState(() => coursesEnrolled = value);
      }
      logger.d('$value');
      SharePrefs.saveListCoursesEnrolledOfUser(value);
    });
  }

  Future<Null> getAllData() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    WidgetsBinding.instance.addObserver(this);
    logger.i('GetAllDataFromAPI');
    getCourseEnrolledFromAPI();
    getAllCourseFromAPI();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.i('App state = $state');
    if (state == AppLifecycleState.paused) {
      LogUserRequest.updateLogUsersToday(AppContext.getLogUser());
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        DynamicLinkService.retrieveDynamicLink(context);
      });
      getLogUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: AppLocalizations.of(context).translate('logout'),
            description:
                AppLocalizations.of(context).translate('description_logout'),
            isLogOut: true,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xFFE8ECF0),
        // appBar: buildAppBar(),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background game.jpeg"),
                  fit: BoxFit.cover)),
          child: RefreshIndicator(
            onRefresh: getAllData,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Header(targetTime),
                        // TitleWitc
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: UIData.kDefaultPadding * 0.8),
                          child: Row(
                            children: <Widget>[
                              TitleWithCustomUnderline(
                                text: AppLocalizations.of(context)
                                    .translate('recommended_courses'),
                              ),
                              Spacer(),
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/load_more');
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('more'),
                                  style: TextStyle(color: Color(0xFFEA7A13)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        this.coursesEnrolled != null
                            ? RecentlyCourses(this.coursesEnrolled)
                            : CircularProgressIndicator(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: UIData.kDefaultPadding * 0.8),
                          child: Row(
                            children: <Widget>[
                              TitleWithCustomUnderline(
                                text: AppLocalizations.of(context)
                                    .translate('free_courses'),
                              ),
                              Spacer(),
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/load_more');
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('more'),
                                  style: TextStyle(color: Color(0xFFEA7A13)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        this.coursesEnrolled != null
                            ? CourseEnrolled(this.coursesEnrolled)
                            : CircularProgressIndicator(),
                        SizedBox(height: UIData.kDefaultPadding),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Image.asset("assets/icons/icon-id-true.png"),
        onPressed: () {},
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: UIData.kDefaultPadding / 4),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: UIData.kDefaultPadding / 4),
              height: 5,
              color: Colors.amberAccent.withOpacity(0.4),
            ),
          )
        ],
      ),
    );
  }
}
