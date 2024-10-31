import 'package:arames_project/colors/colors.dart';
import 'package:flutter/material.dart';


class TimePage  extends StatefulWidget {
  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  @override
  Widget build(BuildContext context) {
    return 
         Center(
          child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Affichage du temps d'arrêt
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text('Temps d\'arrêt I Poste: ', style: TextStyle(fontSize: 10),overflow: TextOverflow.visible,
                      ),
                    ),

                    Container(
                       padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 5, color: red1),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: red1,
                        ), 
                      child: Text('00:00:00',style: TextStyle(color: Colors.white),)
                      ),
                  ],
                ),
              ),
              SizedBox(width: 20), // Espacement horizontal entre les deux ensembles
              // Affichage du temps de marche
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 5, color: green1),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color:green1 ,
                        ), 
                      child: Text('00:00:00', )
                      ),
                     SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Temps de marche I Poste: ',  style: TextStyle(fontSize: 10), overflow: TextOverflow.visible,
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
