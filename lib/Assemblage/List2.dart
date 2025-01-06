import 'package:arames_project/Assemblage/classe%20.dart';
import 'package:flutter/material.dart';

import '../colors/colors.dart';

class Listof extends StatelessWidget {
  final List<ListItem> items;
  final Map<String, dynamic>? data; // Ajout des données dynamiques

  const Listof({super.key, required this.items, this.data});

  Widget _UAPLIST(String title, String subtitle, dynamic value,Color shadowColor) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 14),
            ),
          ),
   Flexible(
  child: Container(
    padding: EdgeInsets.all(10),
    constraints: BoxConstraints(
      minWidth: 100, // Largeur minimale souhaitée
      maxWidth: 600, // Largeur maximale souhaitée (facultatif)
      minHeight: 30, // Hauteur minimale souhaitée
      maxHeight: 70, // Hauteur maximale souhaitée
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color.fromARGB(255, 99, 99, 99)),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          spreadRadius: 0,
          blurRadius: 5,
          offset: Offset(0, 0),
        ),
      ],
    ),
    child: Text(
      value,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      textAlign: TextAlign.center, // Centrer le texte (facultatif)
    ),
  ),
),

        ],
        
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: items.map((item) {
          return _UAPLIST(item.title, item.subtitle, item.value,item.shadowColor);
        }).toList(),
      ),
    );
  }
}
