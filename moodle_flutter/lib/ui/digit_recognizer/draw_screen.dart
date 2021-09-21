import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:moodle_flutter/ui/components/default_button.dart';
import 'package:moodle_flutter/ui/digit_recognizer/prediction_widget.dart';
import 'package:moodle_flutter/ui/digit_recognizer/services/recognizer.dart';
import 'package:moodle_flutter/ui/digit_recognizer/utils/constants.dart';
import 'drawing_painter.dart';
import 'models/prediction.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _points = List<Offset>();
  final _recognizer = Recognizer();
  List<Prediction> _prediction;
  bool initialize = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        _drawCanvasWidget(),
        SizedBox(
          height: 10,
        ),
        PredictionWidget(
          predictions: _prediction,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  primary: Colors.lightGreen,
                  onPrimary: Colors.white
              ),
              onPressed: () {
                //TODO
              },
              icon: Icon(Icons.check),
              label: Text(
                'OK',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  primary: Colors.red,
                  onPrimary: Colors.white),
              onPressed: () {
                setState(() {
                  _points.clear();
                  _prediction.clear();
                });
              },
              icon: Icon(Icons.delete_forever_rounded), //Image.asset("assets/icons/icon-erase.png"),
              label:  Text(
                'Xóa',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: Constants.canvasSize + Constants.borderSize * 2,
      height: Constants.canvasSize + Constants.borderSize * 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: Constants.borderSize,
        ),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _localPosition = details.localPosition;
          if (_localPosition.dx >= 0 &&
              _localPosition.dx <= Constants.canvasSize &&
              _localPosition.dy >= 0 &&
              _localPosition.dy <= Constants.canvasSize) {
            setState(() {
              _points.add(_localPosition);
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _recognize();
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    });
  }
}
