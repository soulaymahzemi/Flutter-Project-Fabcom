import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

class IndicateurPage extends StatelessWidget {
  final double percentage;
  IndicateurPage({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Container(
                width: 300,  // Modifiez la largeur ici
                child: Stack(
                  children: [
                    LinearPercentIndicator(
                      lineHeight: 15.0, // Hauteur de la barre
                      percent: percentage,
                      backgroundColor: Color(0xFFD5EDBC),
                      progressColor: Colors.green,
                    ),
                    Center(
                      child: Text(
                        "${(percentage * 100).toStringAsFixed(0)}%", 
                        style: TextStyle(
                          fontSize: 13.0, // Taille de la police ajustée
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            'Progression de la réalisation',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
