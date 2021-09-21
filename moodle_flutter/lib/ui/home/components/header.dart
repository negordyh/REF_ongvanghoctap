import 'package:flutter/material.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Header extends StatefulWidget {
  final int targetTime;
  const Header(
    this.targetTime, {
    Key key,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
}

class _HeaderState extends State<Header> {
  double _targetTimeValue = 40.0;
  double _targetTimeRecent = 0;
  bool _isFirstRender = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.targetTime != null && _isFirstRender) {
      setState(() {
        this._isFirstRender = false;
        this._targetTimeRecent = widget.targetTime.toDouble();
      });
    }
    return Container(
      height: size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
        image: DecorationImage(
          image: AssetImage("assets/images/background_home.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: size.height * 0.2,
                  width: size.width * 0.2,
                  decoration: BoxDecoration(
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
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        width: size.width * 0.65,
                        child: Text(
                          AppContext.user.username,
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: size.width * 0.65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('completion_progress'),
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            "${((getPercentTarget().isNaN ? 1 : getPercentTarget())*100).toStringAsFixed(0)} %",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    LinearPercentIndicator(
                      width: size.width * 0.65,
                      lineHeight: 10.0,
                      percent: getPercentTarget().isNaN ? 1 : getPercentTarget(),
                      backgroundColor: Color(0xFFFFD032),
                      progressColor: Colors.white,
                    ),
                    Container(
                      width: size.width * 0.65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_targetTimeRecent.toStringAsFixed(0)} phút",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.white,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => DialogEditTarget());
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('target_change'),
                              style: TextStyle(color: Color(0xFF111111)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getPercentTarget() {
    double percent = AppContext.getTodayTimeOnApp() / 60 / this._targetTimeRecent;
    return percent.isNaN ? 0 : percent > 1 ? 1 : percent;
  }

  Widget DialogEditTarget() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 100, bottom: 16, right: 16, left: 16),
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
                  AppLocalizations.of(context).translate('choose_target'),
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16),
                SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                          trackWidth: 5, progressBarWidth: 40, shadowWidth: 70),
                      customColors: CustomSliderColors(
                          dotColor: Color(0xFFFFB1B2),
                          trackColor: Color(0xFFE9585A),
                          progressBarColors: [
                            Color(0xFFFB9967),
                            Color(0xFFE9585A)
                          ],
                          shadowColor: Color(0xFFFFB1B2),
                          shadowMaxOpacity: 0.05),
                      infoProperties: InfoProperties(
                          bottomLabelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          bottomLabelText: 'time',
                          mainLabelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 50.0,
                              fontWeight: FontWeight.w600),
                          modifier: (double value) {
                            final time =
                                printDuration(Duration(seconds: value.toInt()));
                            return '$time';
                          }),
                      startAngle: 270,
                      angleRange: 360,
                      size: 300.0),
                  min: 0,
                  max: 7320, //7320 = 2h*60p*61s
                  initialValue: (_targetTimeRecent+1)*60,
                  onChange: (double value) {
                    setState(() {
                      _targetTimeValue = value;
                    });
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            this._targetTimeRecent =
                                (_targetTimeValue / (60) - 1);
                            AppContext.setTargetTimeOnApp(_targetTimeRecent.toInt());
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Confirm"))
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
              backgroundImage: AssetImage("assets/images/alert_bee.gif"),
            ),
          ),
        ],
      ),
    );
  }
}
