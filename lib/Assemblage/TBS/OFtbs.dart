import 'package:flutter/material.dart';

import '../../colors/colors.dart';

class Uaplist extends StatelessWidget {
  const Uaplist({super.key});


 Widget _UAPLIST(String title, String subtitle, String value) {
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
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
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
                _UAPLIST("N°OF", "Numéro de l’ordre de fabrication", ""),
                _UAPLIST("Réf Art", "Référence de l’article à réaliser", ""),
                _UAPLIST("Qté Obj", "Quantité objectif à réaliser", "0%"),
                _UAPLIST("Production", "Quantité réalisée jusqu’à l’instant", "0%"),
               ],
           ),
      );
  
  }
}