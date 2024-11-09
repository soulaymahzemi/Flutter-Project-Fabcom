import 'package:arames_project/dashbord/UapList.dart';
import 'package:arames_project/dashbord/list1.dart';
import 'package:arames_project/dashbord/ofList.dart';
import 'package:arames_project/dashbord/quantiteslist.dart';
import 'package:flutter/material.dart';
import 'package:arames_project/dashbord/appbar.dart';
import 'package:arames_project/Assemblage/Assemblagepage.dart';

import '../colors/colors.dart';
import 'eng.dart';

class Homepage extends StatefulWidget {
   final double trsTotal;
  final double tpTotal;
  final double tdTotal;
  final double tqTotal;
  final double trTotal;
  final double QPTotal;
   final int nofTbs;
   final int nofSovema1;
   final int nofSovema2;
  const Homepage({super.key, required this.trsTotal, required this.tpTotal, required this.tdTotal, required this.tqTotal, required this.trTotal, required this.nofTbs, required this.nofSovema1, required this.nofSovema2, required this.QPTotal, });

  @override
  State<Homepage> createState() => _HomepageState();

}

class _HomepageState extends State<Homepage> {
  
  List<bool> _isListVisible = [false, false, false];

  void _toggleListVisibility(int index) {
    setState(() {
      _isListVisible[index] = !_isListVisible[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
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
                isListVisible: _isListVisible[0],
                onToggleVisibility: () => _toggleListVisibility(0),
                 destinationPage: Ligne(),
                 isActive: true,
                 content1: Assemblage(),
              ),

              // Maintenance Card
              _buildCard(
                title: 'Palque',
                subtitle: '',
                imagePath: 'assets/images/plaque.jpg',
                isListVisible: _isListVisible[1],
                onToggleVisibility: () => _toggleListVisibility(1),
                 destinationPage: Ligne(),
                 isActive: false,
                 content1:widget,
              ),

              _buildCard(
                title: 'Charge-Finition',
                subtitle: '',
                imagePath: 'assets/images/p2.jpg',
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

 // Modify _buildCard to include isActive
Widget _buildCard({
  required String title,
  required String subtitle,
  required String imagePath,
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
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[300], // Change color when inactive
        borderRadius: BorderRadius.circular(10),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              color: isActive ? navbar : Colors.grey[500], // Inactive color for navbar
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
                  fontSize: 30,
                  color: textcolor,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                iconSize: 30,
                onPressed: isActive ? onToggleVisibility : null, // Disable toggle when inactive
                icon: Icon(
                  isListVisible
                      ? Icons.arrow_circle_up_rounded
                      : Icons.arrow_circle_down_rounded,
                ),
              ),
            ],
          ),
         if (isListVisible)content1,
            
        ],
      ),
    ),
  );
}Widget Assemblage() {
  return Column(
    children: [
      fun1("KPI | Performance de l'UAP", 'assets/images/iconKpi.webp'),
      Container(
        constraints: BoxConstraints(maxHeight: 450),
        child: ListDisplay(
          items: [
            {"title": "TRS", "subtitle": "Taux de rendement synthétique", "value":"${widget.trsTotal}"},
            {"title": "TP", "subtitle": "Taux de performance", "value": "${widget.tpTotal}"},
            {"title": "TD", "subtitle": "Taux de disponibilité", "value": "${widget.tdTotal}"},
            {"title": "TQ", "subtitle": "Taux de qualité", "value":  "${widget.tqTotal}"},
            {"title": "TR", "subtitle": "Taux retouch", "value":"${widget.trTotal}"},
          ],
        ),
      ),
      SizedBox(height: 10),
      fun1('OF | Running OFs', 'assets/images/of.png'),
      Container(
        constraints: BoxConstraints(maxHeight: 400),
        child: ListDisplay(
          items: [
            {"title": "TBS", "subtitle": "ligne d'Assemblage TBS", "value": '${widget.nofTbs}'},
            {"title": "SOVEMA1", "subtitle": "ligne d'Assemblage SOVEMA1", "value": "${widget.nofSovema1}"},
            {"title": "SOVEMA2", "subtitle": "ligne d'Assemblage SOVEMA2", "value": "${widget.nofSovema1}"},
          ],
        ),
      ),
      SizedBox(height: 10),
      fun1('Qté | Détail des quantités produites', 'assets/images/quantity.png'),
      Container(
        constraints: BoxConstraints(maxHeight: 400),
        child: ListDisplay(
          items: [
            {"title": "Qté Conf [batterie]", "subtitle": "Quantité totale produites conformes", "value":"${widget.QPTotal}" },
            {"title": "Qté NC [batterie]", "subtitle": "Quantité totale non conformes", "value": "0"},
            {"title": "Qté Ret [batterie]", "subtitle": "Quantité totale retouchée", "value": "0"},
          ],
        ),
      ),
      SizedBox(height: 10),
      fun1('Eng | Performance énergétique', 'assets/images/eng.png'),
      Container(
        constraints: BoxConstraints(maxHeight: 450),
        child: ListDisplay(
          items: [
            {"title": "Energie [KWh]", "subtitle": "Total consommation d'énergie active", "value": "0"},
            {"title": "P [KW]", "subtitle": "Total puissance active", "value": "0"},
            {"title": "Q [KVAR]", "subtitle": "Total puissance réactive", "value": "0"},
            {"title": "cos ϕ [ ]", "subtitle": "Facteur de puissance", "value": "0"},
            {"title": "CO2 [Kg]", "subtitle": "Total Empreinte carbone", "value": "0"},
          ],
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}

  Widget fun1(String title, String pathimage) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
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
          Image.asset(pathimage, width: 30),
        ],
      ),
    );
  }
}
