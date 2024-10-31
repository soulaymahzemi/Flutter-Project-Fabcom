import 'package:arames_project/colors/colors.dart';
import 'package:flutter/material.dart';

class Energielist extends StatelessWidget {
  const Energielist({super.key});

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
          ]),
      child: ListView(
        shrinkWrap: true, // Permet au ListView de s'adapter à son contenu
        physics: NeverScrollableScrollPhysics(), // Empêche le défilement
        children: [
          _Energielist(
              "Energie [KWh]", "Total consommation d'énergie active", "0"),
          _Energielist("P [KW]", "Total puissance active", "0"),
          _Energielist("Q [KVAR]", "Total puissance réactive", "0"),
          _Energielist("cos ϕ [ ]", "Facteur de puissance", "0"),
          _Energielist("CO2 [Kg]", "Total Empreinte carbone", "0"),
        ],
      ),
    );
  }

  Widget _Energielist(String title, String subtitle, dynamic value) {
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
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 99, 99, 99))),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
