import 'package:arames_project/colors/colors.dart';
import 'package:flutter/material.dart';

class Quantiteslist extends StatelessWidget {
  const Quantiteslist({super.key});


 
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
              offset: Offset(0, 0),
            )
          ]
        ),
        child: ListView(
             shrinkWrap: true, // Permet au ListView de s'adapter à son contenu
             physics: NeverScrollableScrollPhysics(), // Empêche le défilement
                children: [
                _Quantiteslist("Qté Conf [batterie]", "Quantité totale produites conformes", "0"),
                _Quantiteslist("Qté NC [batterie]", "Quantité totale non conformes", "0"),
                _Quantiteslist("Qté Ret [batterie]", "Quantité totale retouchée", "0"),
                _Quantiteslist("Qté déchet [Kg]", "Quantité déchet déclarée vers recyclage", "0"),
              
               ],
           ),
      );
  
  }
  Widget _Quantiteslist(String title, String subtitle, dynamic value) {
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
}