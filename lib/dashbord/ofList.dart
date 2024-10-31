import 'package:arames_project/colors/colors.dart';
import 'package:flutter/material.dart';

class OfSList extends StatelessWidget {
  const OfSList ({super.key});


 
  @override
  Widget build(BuildContext context) {
    return 
       Container(
         margin: EdgeInsets.all(2),
         decoration: BoxDecoration(
          color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10),),
 
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
                _OfSList("TBS", "ligne d'Assemblage TBS", "0"),
                
               ],
           ),
      );
  
  }
  Widget _OfSList(String title, String subtitle, String value) {
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
}