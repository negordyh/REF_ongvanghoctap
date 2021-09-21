import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:moodle_flutter/ui/profile/profile.dart';
import 'package:moodle_flutter/ui/home/home_screen.dart';
import 'package:moodle_flutter/ui/courses/courses.dart';
import 'package:moodle_flutter/ui/spin_wheel/spin_wheel.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
class HomePage extends StatefulWidget {
  static const String routeName = "/home";

  HomePage(this.notificationAppLaunchDetails);
  final String notificationAppLaunchDetails;

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Size deviceSize;
  final List<Widget> pages = [CoursesScreen(), Roulette(), HomeScreen(), ProfilePage()];
  int _currentIndex = 2;
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xE8ECF0),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          // _pageController.jumpToPage(index);
        }, // new
        selectedIndex: _currentIndex, // new
        items: <BottomNavyBarItem>[
          new BottomNavyBarItem(
              icon: Container(
                height: 34.0,
                  width: 34.0,
                  child: Image.asset("assets/icons/icon-book-shelf-false.png")
              ),
              title: Text('Courses')
          ),
          new BottomNavyBarItem(
              icon: Container(
                  height: 34.0,
                  width: 34.0,
                  child: Image.asset("assets/icons/icon-game.png")
              ),
              title: Text('Game')
          ),
          new BottomNavyBarItem(
              icon: Container(
                  height: 34.0,
                  width: 34.0,
                  child: Image.asset("assets/icons/icon-home-page-false.png")
              ),
              title: Text('Home')
          ),
          new BottomNavyBarItem(
              icon: Container(
                  height: 34.0,
                  width: 34.0,
                  child: Image.asset("assets/icons/icon-id-false.png")
              ),
              title: Text('Profile')
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),

    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      // print(_currentIndex);
    });
  }
}
