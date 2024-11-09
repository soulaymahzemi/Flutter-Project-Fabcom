import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

class IndicateurPage extends StatelessWidget {
      final double percentage ; 
  IndicateurPage({required this.percentage});
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, 
        crossAxisAlignment:
            CrossAxisAlignment.start, 
        children: <Widget>[
          Row(
            children: [
              Container(
                width: 250,
                child: LinearPercentIndicator(
                  lineHeight: 10.0,
                  percent: percentage,
                  backgroundColor: Color(0xFFD5EDBC),
                  progressColor: Colors.green,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "${(percentage * 100).toStringAsFixed(0)}%", 
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
          SizedBox(
              height:
                  10), 
          Text(
            'Progression de la réalisation',
            textAlign: TextAlign.start, 
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
