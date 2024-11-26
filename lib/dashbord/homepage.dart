import 'package:arames_project/Assemblage/List2.dart';
import 'package:arames_project/Assemblage/classe%20.dart';
import 'package:arames_project/dashbord/men.dart';
import 'package:flutter/material.dart';
import 'package:arames_project/dashbord/appbar.dart';
import 'package:arames_project/Assemblage/Assemblagepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/colors.dart';

class Homepage extends StatefulWidget {
final String nofValue;
final String nofSovema1;
final String nofSovema2;
final double QPTotal;
final double trsTotal;
final double tpTotal;
final double tdTotal;
final double tqTotal;
final double trTotal;

  const Homepage({super.key, required this.nofValue, required this.nofSovema1, required this.nofSovema2, required this.QPTotal, required this.trsTotal, required this.tpTotal, required this.tdTotal, required this.tqTotal, required this.trTotal,  });

  @override
  State<Homepage> createState() => _HomepageState();


}

class _HomepageState extends State<Homepage> {
  late SharedPreferences prefs;
  // Déclarez les variables que vous souhaitez stocker
  late String nofValue;
  late String nofSovema1;
  late String nofSovema2;
  late double QPTotal;
  late double trsTotal;
  late double tpTotal;
  late double tdTotal;
  late double tqTotal;
  late double trTotal;
   // Charger les données de SharedPreferences
  _loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      nofValue = prefs.getString('nofValue') ?? '0';
      nofSovema1 = prefs.getString('nofSovema1') ?? '0';
      nofSovema2 = prefs.getString('nofSovema2') ?? '0';
      QPTotal = prefs.getDouble('QPTotal') ?? 0.0;
      trsTotal = prefs.getDouble('trsTotal') ?? 0.0;
      tpTotal = prefs.getDouble('tpTotal') ?? 0.0;
      tdTotal = prefs.getDouble('tdTotal') ?? 0.0;
      tqTotal = prefs.getDouble('tqTotal') ?? 0.0;
      trTotal = prefs.getDouble('trTotal') ?? 0.0;
    });
  }
  // Sauvegarder les données dans SharedPreferences
  _saveData() async {
    await prefs.setString('nofValue', nofValue);
    await prefs.setString('nofSovema1', nofSovema1);
    await prefs.setString('nofSovema2', nofSovema2);
    await prefs.setDouble('QPTotal', QPTotal);
    await prefs.setDouble('trsTotal', trsTotal);
    await prefs.setDouble('tpTotal', tpTotal);
    await prefs.setDouble('tdTotal', tdTotal);
    await prefs.setDouble('tqTotal', tqTotal);
    await prefs.setDouble('trTotal', trTotal);
  }
    @override
  void initState() {
    super.initState();
    _loadData(); // Chargez les données lors de l'initialisation de la page

  }
  
  List<bool> _isListVisible = [false, false, false];

  void _toggleListVisibility(int index) {
    setState(() {
      _isListVisible[index] = !_isListVisible[index];
    });
  }
Color getShadowColor(String kpi, double value) {
  if (value == 0.0) {
    return shadowcolor; // Couleur par défaut si aucune valeur ou valeur égale à 0
  }

  switch (kpi) {
    case "TRS":
      if (value > 90) return green1;
      if (value > 55 && value < 65) return Colors.yellow;
      return red1;
    case "TP":
    case "TQ":
    case "TR":
      if (value > 90) return green1;
      if (value > 80 && value < 90) return Colors.yellow;
      return red1;
    case "TD":
      if (value > 75) return green1;
      if (value > 55 && value < 75) return Colors.yellow;
      return red1;
    default:
      return shadowcolor; // Par défaut si KPI inconnu
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(),
      drawer:CustomDrawer(),
      body: 
      SingleChildScrollView(
        child: Center(

          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Assemblage Card
              
              _buildCard(
                title: 'Assemblage',
                subtitle: 'UAP',
                imagePath: 'assets/images/mach.png',
                 imagePath2:  'assets/images/alert.png',
                isListVisible: _isListVisible[0],
                onToggleVisibility: () => _toggleListVisibility(0),
                 destinationPage: Ligne(),
                 isActive: true,
                 content1: Assemblage(),
              ),

              // Maintenance Card
              _buildCard(
                title: 'Palque',
                subtitle: 'UAP',
                imagePath: 'assets/images/plaque.png',
                imagePath2:  'assets/images/alert.png',
                isListVisible: _isListVisible[1],
                onToggleVisibility: () => _toggleListVisibility(1),
                 destinationPage: Ligne(),
                 isActive: false,
                 content1:widget,
              ),

              _buildCard(
                title: 'Finition-Charge',
                subtitle: 'UAP',
                imagePath: 'assets/images/p2.png',
                imagePath2:'assets/images/alert.png',
                isListVisible: _isListVisible[2],
                onToggleVisibility: () => _toggleListVisibility(2),
                 destinationPage:Ligne() ,
                 isActive: false,
                 content1: widget,
                 ),
            ],
          ),
        ),
      ),
    );
  }
Widget Assemblage() {
  return Column(
    children: [
      fun1("KPI | Performance de l'UAP", 'assets/images/iconKpi.webp'),
      Container(
        constraints: BoxConstraints(maxHeight: 450),
        child: Listof(
          items: [
            ListItem(
              title: "TRS",
              subtitle: "Taux de rendement synthétique",
              value: "${widget.trsTotal.toStringAsFixed(0)}%",
              shadowColor: getShadowColor("TRS", widget.trsTotal),
            ),
            ListItem(
              title: "TP",
              subtitle: "Taux de performance",
              value: "${widget.tpTotal.toStringAsFixed(0)}%",
              shadowColor: getShadowColor("TP", widget.tpTotal) ,
            ),
            ListItem(
              title: "TD",
              subtitle: "Taux de disponibilité",
              value: "${widget.tdTotal.toStringAsFixed(0)}%",
              shadowColor:  getShadowColor("TD", widget.tdTotal),
            ),
            ListItem(
              title: "TQ",
              subtitle: "Taux de qualité",
              value: "${widget.tqTotal.toStringAsFixed(0)}%",
              shadowColor:  getShadowColor("TQ", widget.tqTotal),
            ),
            ListItem(
              title: "TR",
              subtitle: "Taux retouch",
              value: "${widget.trTotal.toStringAsFixed(0)}%",
              shadowColor:  getShadowColor("TR", widget.trTotal),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      fun1('OF | Running OFs', 'assets/images/of.png'),
      Container(
        constraints: BoxConstraints(maxHeight: 400),
        child: Listof(
          items: [
            ListItem(
              title: "TBS",
              subtitle: "ligne d'Assemblage TBS",
              value: "${widget.nofValue}",
              shadowColor: shadowcolor,
            ),
            ListItem(
              title: "SOVEMA1",
              subtitle: "ligne d'Assemblage SOVEMA1",
              value: "${widget.nofSovema1}",
              shadowColor: shadowcolor,
            ),
            ListItem(
              title: "SOVEMA2",
              subtitle: "ligne d'Assemblage SOVEMA2",
              value: "${widget.nofSovema2}",
              shadowColor: shadowcolor,
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      fun1('Qté | Détail des quantités produites', 'assets/images/quantity.png'),
      Container(
        constraints: BoxConstraints(maxHeight: 400),
        child: Listof(
          items: [
            ListItem(
              title: "Qté Conf [batterie]",
              subtitle: "Quantité totale produites conformes",
              value: "${widget.QPTotal.toStringAsFixed(0)}%",
              shadowColor: shadowcolor,
            ),
            ListItem(
              title: "Qté NC [batterie]",
              subtitle: "Quantité totale non conformes",
              value: "0",
              shadowColor: shadowcolor,
            ),
            ListItem(
              title: "Qté Ret [batterie]",
              subtitle: "Quantité totale retouchée",
              value: "0",
              shadowColor: shadowcolor,
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      fun1('Eng | Performance énergétique', 'assets/images/eng.png'),
      Container(
        constraints: BoxConstraints(maxHeight: 450),
        child: Listof(
          items: [
            ListItem(
              title: "Energie [KWh]",
              subtitle: "Total consommation d'énergie active",
              value: "0",
              shadowColor: shadowcolor,
            ),
            ListItem(
              title: "P [KW]",
              subtitle: "Total puissance active",
              value: "0",
              shadowColor: shadowcolor,
            ),
            ListItem(
              title: "Q [KVAR]",
              subtitle: "Total puissance réactive",
              value: "0",
              shadowColor: shadowcolor,
            ),
            ListItem(
              title: "cos ϕ [ ]",
              subtitle: "Facteur de puissance",
              value: "0",
              shadowColor: shadowcolor,
            ),
            ListItem(
              title: "CO2 [Kg]",
              subtitle: "Total Empreinte carbone",
              value: "0",
              shadowColor: shadowcolor,
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
    ],
  );
}

  Widget fun1(String title, String pathimage) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(230, 219, 219, 1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18, color: textcolor, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Image.asset(pathimage, width: 30,),
        ],
      ),
    );
  }
 // Modify _buildCard to include isActive
Widget _buildCard({
  required String title,
  required String subtitle,
  required String imagePath,
  required String imagePath2,
  required Widget destinationPage,
  required bool isListVisible,
  required VoidCallback onToggleVisibility,
  required bool isActive, // New parameter for active/inactive status
  required Widget content1,
}) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[300], // Change color when inactive
        borderRadius: BorderRadius.only(
 topLeft: Radius.circular(30),  // Adjust the radius as needed
    topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowcolor,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: isActive ? navbar : Colors.grey[400], // Inactive color for navbar
              boxShadow: [
                BoxShadow(
                  color: shadowcolor,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: textcolor,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: textcolor,
                ),
              ),
              onTap: isActive
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => destinationPage),
                      );
                    }
                  : null, // Disable navigation when inactive
            ),
          ),
          Image.asset(imagePath),
          SizedBox(height: 20),
          Row(
            
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Image.asset(imagePath2,width: 65,),

                IconButton(
              iconSize: 35,
              onPressed: onToggleVisibility,
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,  // Forme circulaire de l'icône
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 168, 166, 166).withOpacity(0.2),  // Couleur de l'ombre avec opacité
                      offset: Offset(1, 1),  // Décalage de l'ombre
                      blurRadius: 2,  // Flou de l'ombre
                    ),
                  ],
                ),
                child: Icon(
                  isListVisible
                      ? Icons.arrow_circle_up
                      : Icons.arrow_circle_down_rounded,
                  color: const Color.fromARGB(255, 80, 78, 78),  // Couleur de l'icône
                ),
              ),
            ),
            ],
          ),
          SizedBox(height: 10,),
         if (isListVisible)content1,
            
        ],
      ),
    ),
  );
}

}
