import 'package:flutter/material.dart';

import 'models/prediction.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;

  const PredictionWidget({Key key, this.predictions}) : super(key: key);

  Widget _numberWidget(int num, Prediction prediction) {
    return Column(
      children: <Widget>[
        Text(
          '$num',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
        // Text(
        //   '${prediction == null ? '' : prediction.confidence.toStringAsFixed(3)}',
        //   style: TextStyle(
        //     fontSize: 12,
        //     color: Colors.black
        //   ),
        // )

      ],
    );
  }

  List<dynamic> getPredictionStyles(List<Prediction> predictions) {
    List<dynamic> data = [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];
    predictions?.forEach((prediction) {
      data[prediction.index] = prediction;
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    var styles = getPredictionStyles(this.predictions);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 0; i < 5; i++) _numberWidget(i, styles[i])
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 5; i < 10; i++) _numberWidget(i, styles[i])
          ],
        )
      ],
    );
  }
}
