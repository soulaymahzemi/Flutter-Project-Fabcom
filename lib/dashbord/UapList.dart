import 'package:flutter/material.dart';

import '../colors/colors.dart';

class Uaplist extends StatelessWidget {
  const Uaplist({super.key});


 Widget _UAPLIST(String title, String subtitle, dynamic value) {
    return ListTile(
      title: 
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
             padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 99, 99, 99))
              ),
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return 
       Container(
         margin: EdgeInsets.all(2),
         decoration: BoxDecoration(
          color: Colors.white,
           borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),

          boxShadow: [
            BoxShadow(
              color: shadowcolor,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 5),
            )
          ]
        ),
        child: ListView(
             shrinkWrap: true, // Permet au ListView de s'adapter à son contenu
             physics: NeverScrollableScrollPhysics(), // Empêche le défilement
                children: [
                _UAPLIST("TRS", "Taux de rendement synthétique", "0%"),
                _UAPLIST("TP", "Taux de performance", "0%"),
                _UAPLIST("TD", "Taux de disponibilité", "0%"),
                _UAPLIST("TQ", "Taux de qualité", "0%"),
                _UAPLIST("Tde", "Taux déchet", "0%"),
               ],
           ),
      );
  
  }
}