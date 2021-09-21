import 'dart:math';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/bee_service/log_user.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/ui_data.dart';

class LineChartStat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartStatState();
}

class LineChartStatState extends State<LineChartStat> {
  List<Color> gradientColorsTimeInApp = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColorsTimeTarget = [
    const Color(0xffe62323),
    const Color(0xadc502d3),
  ];

  int stateDataView = TODAY;
  LogUser logUser;
  int totalTime = 0;
  int totalCourse = 0;
  static const int LAST_MONTH = 0;
  static const int TODAY = 1;
  static const int THIS_MONTH = 2;

  @override
  void initState() {
    super.initState();
    getDataLog();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
        backgroundColor: UIData.background,
        appBar: AppBarCustom(
          size: deviceSize,
          title: AppLocalizations.of(context).translate('profile'),
          image: "assets/images/sinh-hoc.jpg",
        ),
        body: AspectRatio(
          aspectRatio: deviceSize.width / (deviceSize.height * 0.85),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              gradient: LinearGradient(
                colors: [
                  Color(0xff2c274c),
                  Color(0xff46426c),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 60,
                    ),
                    DefaultTabController(
                      length: 3,
                      initialIndex: TODAY,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: TabBar(
                          indicator: BubbleTabIndicator(
                            tabBarIndicatorSize: TabBarIndicatorSize.tab,
                            indicatorHeight: 40.0,
                            indicatorColor: Colors.white,
                          ),
                          labelStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.white,
                          tabs: <Widget>[
                            Text('Tháng trước'),
                            Text('Hôm nay'),
                            Text('Tháng này'),
                          ],
                          onTap: (index) {
                            setState(() {
                              this.stateDataView = index;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        _buildStatCard('Khoá học đã tham gia',
                            this.totalCourse.toString(), Colors.orange),
                        _buildStatCard(
                            'Tổng thời gian trên app',
                            (this.totalTime ~/ 60).toString() + ' Phút',
                            Colors.red),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    this.stateDataView == TODAY
                        ? Container()
                        : Container(
                            height: deviceSize.height * 0.5,
                            width: deviceSize.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 16.0, left: 20.0),
                              child: LineChart(
                                mainData(this.stateDataView),
                                swapAnimationDuration:
                                    const Duration(milliseconds: 250),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white.withOpacity(1.0),
                  ),
                  onPressed: () {
                    getDataLog();
                  },
                )
              ],
            ),
          ),
        ));
  }

  LineChartData mainData(int stateChart) {
    /// Filter data
    logUser.userTimeOnAppList
        .sort((a, b) => a.localDate.compareTo(b.localDate));
    List<UserTimeOnApp> listDataInMonth = stateChart == LAST_MONTH
        ? logUser.userTimeOnAppList
            .where((element) =>
                element.localDate.month == DateTime.now().month - 1)
            .toList()
        : logUser.userTimeOnAppList
            .where((element) => element.localDate.month == DateTime.now().month)
            .toList();

    /// Get min x max x
    List<double> minMaxX = [0, 10];
    minMaxX = getMinMaxX(listDataInMonth);

    /// Get min Y maxY
    List<double> minMaxY = [0, 10];
    bool isMin = true;
    int maxTime = 0;
    int minTime = 60 * 60 * 24;
    listDataInMonth.forEach((element) {
      maxTime = max(element.timeCount, maxTime);
      minTime = min(element.timeCount, minTime);
    });
    if (maxTime < 3600) {
      minTime = max(minTime - 300, 0);
      isMin = true;
      minMaxY = [minTime / 60, maxTime / 60];
    } else {
      minTime = max(minTime - 300, 0);
      maxTime = min(maxTime + 300, 60 * 60 * 24);
      isMin = false;
      minMaxY = [minTime / 1800, maxTime / 1800];
    }

    /// Return linechart
    return LineChartData(
      axisTitleData: FlAxisTitleData(
          bottomTitle: AxisTitle(
              titleText: "Ngày",
              showTitle: true,
              textStyle: TextStyle(
                  color: Color(0xff68737d),
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          leftTitle: AxisTitle(
              titleText: isMin ? "Phút" : "Giờ",
              showTitle: true,
              textStyle: TextStyle(
                  color: Color(0xff68737d),
                  fontWeight: FontWeight.bold,
                  fontSize: 16))),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) =>
              getSideTitles(value.toInt(), minMaxX, listDataInMonth),
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) => getLeftTitles(value.toInt(), minMaxY, isMin),
          reservedSize: 28,
          margin: 17,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: minMaxX.first,
      maxX: minMaxX.last,
      minY: minMaxY.first,
      maxY: minMaxY.last,
      lineBarsData: [
        LineChartBarData(
          spots: getBarDataTimeInApp(listDataInMonth, isMin),
          isCurved: true,
          colors: gradientColorsTimeInApp,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColorsTimeInApp
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
        LineChartBarData(
          spots: getBarDataTimeTarget(listDataInMonth, isMin),
          isCurved: true,
          colors: gradientColorsTimeTarget,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColorsTimeTarget
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getDataLog() {
    LogUserRequest.getAllLogUsers().then((value) => setState(() {
          this.logUser = value;
          this.totalTime = 0;
          value.userTimeOnAppList.forEach((value) {
            this.totalTime += value.timeCount;
          });
          this.totalTime +=
              DateTimeRange(start: AppContext.timerStart, end: DateTime.now())
                  .duration
                  .inMinutes;
          this.totalCourse = value.coursesRecently.length;
        }));
  }

  String getSideTitles(
      int value, List<double> minMaxX, List<UserTimeOnApp> userTimeOnAppList) {
    if (minMaxX.last - minMaxX.first <= 5)
      return value.toString();
    else if (userTimeOnAppList.length < 5) {
      bool isHaveDataOnDay = false;
      for (var i in userTimeOnAppList) {
        if (value == i.localDate.day) {
          isHaveDataOnDay = true;
        }
      }
      return isHaveDataOnDay ? value.toString() : "";
    } else {
      if (value % 2 == 0)
        return value.toString();
      else
        return '';
    }
  }

  String getLeftTitles(int value, List<double> minMaxY, bool isMin) {
    if (isMin) {
      if (value % 5 == 0)
        return value.toString();
      else
        return "";
    } else {
      return (value / 2).toString();
    }
  }

  List<double> getMinMaxX(List<UserTimeOnApp> userTimeOnAppList) {
    DateTime startTime = userTimeOnAppList.first?.localDate;
    DateTime endTime = userTimeOnAppList.last?.localDate;
    int dayOfMonth =
        DateUtils.getDaysInMonth(DateTime.now().year, DateTime.now().month - 1);
    return [
      max(startTime.day - 2, 0).toDouble(),
      min(endTime.day + 2, dayOfMonth).toDouble()
    ];
  }

  List<FlSpot> getBarDataTimeInApp(
      List<UserTimeOnApp> userTimeOnAppList, bool isMin) {
    return isMin
        ? userTimeOnAppList
            .map((e) => FlSpot(e.localDate.day.toDouble(),
                double.tryParse((e.timeCount / 60).toStringAsFixed(1))))
            .toList()
        : userTimeOnAppList
            .map((e) => FlSpot(e.localDate.day.toDouble(),
                double.tryParse((e.timeCount / 1800).toStringAsFixed(1))))
            .toList();
  }

  List<FlSpot> getBarDataTimeTarget(
      List<UserTimeOnApp> userTimeOnAppList, bool isMin) {
    return isMin
        ? userTimeOnAppList
            .map((e) => FlSpot(e.localDate.day.toDouble(),
                (e.targetTimeOnApp ?? 0).toDouble()))
            .toList()
        : userTimeOnAppList
            .map((e) => FlSpot(
                e.localDate.day.toDouble(),
                double.tryParse(
                    ((e.targetTimeOnApp ?? 0) / 30).toStringAsFixed(1))))
            .toList();
  }
}
