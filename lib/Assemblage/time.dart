import 'package:arames_project/colors/colors.dart';
import 'package:flutter/material.dart';

class TimePage extends StatefulWidget {
  final int tpsArt;
  final int tpsMrc;

  TimePage({required this.tpsArt, required this.tpsMrc});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Affichage du temps d'arrêt
          Expanded(
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(5)),
                Flexible(
                  child: Text(
                    'Temps d\'arrêt I Poste: ',
                    style: TextStyle(fontSize: 10),
                    overflow: TextOverflow.visible,
                  ),
                ),
                // Container rectangulaire pour temps d'arrêt avec hauteur réduite
                Container(
                  width: 80,
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: red1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: red1,
                  ),
                  child: Center(
                    child: Text(
                      formatDuration(widget.tpsArt),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: green1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: green1,
                  ),
                  child: Center(
                    child: Text(
                      formatDuration(widget.tpsMrc),
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Temps de marche I Poste: ',
                    style: TextStyle(fontSize: 10),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatDuration(int milliseconds) {
  int seconds = milliseconds ~/ 1000; // Convert milliseconds to seconds
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int secs = seconds % 60;
  
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}
