import 'dart:convert';

import 'package:arames_project/Assemblage/List2.dart';
import 'package:arames_project/Assemblage/classe%20.dart';
import 'package:arames_project/dashbord/men.dart';
import 'package:flutter/material.dart';
import 'package:arames_project/dashbord/appbar.dart';
import 'package:arames_project/Assemblage/Assemblagepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../colors/colors.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SharedPreferences prefs;

  double trsTotal = 0.0;
  double tpTotal = 0.0;
  double tdTotal = 0.0;
  double tqTotal = 0.0;
  double trTotal = 0.0;

  double QPTotal = 0.0;
  String? errorMessage;

  //api connection
  Map<String, dynamic>? sovemaData1;
  Map<String, dynamic>? sovemaData2;
  Map<String, dynamic>? datatbs;

  Future<void> fetchMachine2() async {
    try {
      // Charger les données en cache
      datatbs = await loadDataFromCache2('tbsData');
      sovemaData1 = await loadDataFromCache2('sovema1Data');
      sovemaData2 = await loadDataFromCache2('sovema2Data');

      // Fetch TBS data
      final responseTBS =
          await http.get(Uri.parse('http://localhost:3001/api/v1/machine'));
      if (responseTBS.statusCode == 200) {
        datatbs = json.decode(responseTBS.body);
        await saveDataToCache2('tbsData', datatbs); // Enregistrer dans le cache
        print('TBS Data dans home page: $datatbs');

        // Initialiser les totaux avec les données TBS
        setState(() {
          tdTotal = (datatbs?['KPIs']['TD'] ?? 0);
          tpTotal = (datatbs?['KPIs']['TP'] ?? 0);
          tqTotal = (datatbs?['KPIs']['TQ'] ?? 0);
          trTotal = (datatbs?['KPIs']['TR'] ?? 0);
          trsTotal = (datatbs?['KPIs']['TRS'] ?? 0);
          QPTotal = (datatbs?['OF']['QP'] ?? 0);
        });

        await saveTotalsToCache(); // Sauvegarder après TBS
      }

      // Fetch Sovema1 data
      final responseSovema1 =
          await http.get(Uri.parse('http://localhost:3002/api/v1/machine'));
      if (responseSovema1.statusCode == 200) {
        sovemaData1 = json.decode(responseSovema1.body);
        await saveDataToCache2(
            'sovema1Data', sovemaData1); // Enregistrer dans le cache
        print('SOVEMA1 Data dans home page : $sovemaData1');

        // Calculer la moyenne pour Sovema1 (TBS + Sovema1) / 2
        setState(() {
          tdTotal = (tdTotal + (sovemaData1?['KPIs']['TD'] ?? 0)) / 2;
          tpTotal = (tpTotal + (sovemaData1?['KPIs']['TP'] ?? 0)) / 2;
          tqTotal = (tqTotal + (sovemaData1?['KPIs']['TQ'] ?? 0)) / 2;
          trTotal = (trTotal + (sovemaData1?['KPIs']['TR'] ?? 0)) / 2;
          trsTotal = (trsTotal + (sovemaData1?['KPIs']['TRS'] ?? 0)) / 2;
          QPTotal = (QPTotal + (sovemaData1?['OF']['QP'] ?? 0)) / 2;
        });

        await saveTotalsToCache(); // Sauvegarder après Sovema1
      }

      // Fetch Sovema2 data
      final responseSovema2 =
          await http.get(Uri.parse('http://localhost:3003/api/v1/machine'));
      if (responseSovema2.statusCode == 200) {
        sovemaData2 = json.decode(responseSovema2.body);
        await saveDataToCache2(
            'sovema2Data', sovemaData2); // Enregistrer dans le cache
        print('SOVEMA2 Data dans home page : $sovemaData2');

        // Calculer la moyenne pour Sovema2 ((TBS + Sovema1 + Sovema2) / 3)
        setState(() {
          tdTotal = (tdTotal * 2 + (sovemaData2?['KPIs']['TD'] ?? 0)) / 3;
          tpTotal = (tpTotal * 2 + (sovemaData2?['KPIs']['TP'] ?? 0)) / 3;
          tqTotal = (tqTotal * 2 + (sovemaData2?['KPIs']['TQ'] ?? 0)) / 3;
          trTotal = (trTotal * 2 + (sovemaData2?['KPIs']['TR'] ?? 0)) / 3;
          trsTotal = (trsTotal * 2 + (sovemaData2?['KPIs']['TRS'] ?? 0)) / 3;
          QPTotal = (QPTotal * 2 + (sovemaData2?['OF']['QP'] ?? 0)) / 3;
        });
        await saveTotalsToCache(); // Sauvegarder après Sovema1
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
      });
    }
  }

  Future<void> saveTotalsToCache() async {
    final totals = {
      'tdTotal': tdTotal,
      'tpTotal': tpTotal,
      'tqTotal': tqTotal,
      'trTotal': trTotal,
      'trsTotal': trsTotal,
      'QPTotal': QPTotal,
    };
    await saveDataToCache2('totalsData', totals);
    print('Totaux sauvegardés dans le cache : $totals');
  }

  Future<void> loadTotalsFromCache() async {
    final totals = await loadDataFromCache2('totalsData');
    if (totals != null) {
      setState(() {
        tdTotal = totals['tdTotal'] ?? 0;
        tpTotal = totals['tpTotal'] ?? 0;
        tqTotal = totals['tqTotal'] ?? 0;
        trTotal = totals['trTotal'] ?? 0;
        trsTotal = totals['trsTotal'] ?? 0;
        QPTotal = totals['QPTotal'] ?? 0;
      });
      print('Totaux chargés depuis le cache : $totals');
    } else {
      print('Aucun total trouvé dans le cache.');
    }
  }

//suvgraderr
  Future<void> saveDataToCache2(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(data));
  }

//apisauvegrader sharedpreference api
  Future<dynamic> loadDataFromCache2(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchMachine2();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadTotalsFromCache(); // Recharger les données depuis le cache chaque fois que la page est affichée
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
      drawer: CustomDrawer(),
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
                imagePath2: 'assets/images/alert.png',
                isListVisible: _isListVisible[0],
                onToggleVisibility: () => _toggleListVisibility(0),
                destinationPage: Ligne(),
                isActive: true,
                content1: Assemblage(),
              ),

              // Maintenance Card
              _buildCard(
                title: 'Plaque',
                subtitle: 'UAP',
                imagePath: 'assets/images/plaque.png',
                imagePath2: 'assets/images/alert.png',
                isListVisible: _isListVisible[1],
                onToggleVisibility: () => _toggleListVisibility(1),
                destinationPage: Ligne(),
                isActive: false,
                content1: widget,
              ),

              _buildCard(
                title: 'Finition-Charge',
                subtitle: 'UAP',
                imagePath: 'assets/images/p2.png',
                imagePath2: 'assets/images/alert.png',
                isListVisible: _isListVisible[2],
                onToggleVisibility: () => _toggleListVisibility(2),
                destinationPage: Ligne(),
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
                value: "${trsTotal.toStringAsFixed(0)}%",
                shadowColor: getShadowColor("TRS", trsTotal),
              ),
              ListItem(
                title: "TP",
                subtitle: "Taux de performance",
                value: "${tpTotal.toStringAsFixed(0)}%",
                shadowColor: getShadowColor("TP", tpTotal),
              ),
              ListItem(
                title: "TD",
                subtitle: "Taux de disponibilité",
                value: "${tdTotal.toStringAsFixed(0)}%",
                shadowColor: getShadowColor("TD", tdTotal),
              ),
              ListItem(
                title: "TQ",
                subtitle: "Taux de qualité",
                value: "${tqTotal.toStringAsFixed(0)}%",
                shadowColor: getShadowColor("TQ", tqTotal),
              ),
              ListItem(
                title: "TR",
                subtitle: "Taux de retouche",
                value: "${trTotal.toStringAsFixed(0)}%",
                shadowColor: getShadowColor("TR", trTotal),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        fun1('OF | Running OFs', 'assets/images/of.png'),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(
            items: [
              ListItem(
                title: "TBS",
                subtitle: "ligne d'Assemblage TBS",
                value: '${datatbs?['OF']['NOF'] ?? "0"}',
                shadowColor: shadowcolor,
              ),
              ListItem(
                title: "SOVEMA1",
                subtitle: "OF_Batterie",
                value: '${sovemaData1?['OF']['NOF'] ?? "0"}',
                shadowColor: shadowcolor,
              ),
              ListItem(
                title: "SOVEMA1",
                subtitle: "OF_Élément",
                value: '${sovemaData1?['OF_elem']['NOF'] ?? "0"}',
                shadowColor: shadowcolor,
              ),
              ListItem(
                title: "SOVEMA2",
                subtitle: "OF_Batterie",
                value: '${sovemaData2?['OF']['NOF'] ?? "0"}',
                shadowColor: shadowcolor,
              ),
              ListItem(
                title: "SOVEMA2",
                subtitle: "OF_Élément",
                value: '${sovemaData2?['OF_elem']['NOF'] ?? "0"}',
                shadowColor: shadowcolor,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        fun1('Qté | Détail des quantités produites',
            'assets/images/quantity.png'),
        Container(
          constraints: BoxConstraints(maxHeight: 400),
          child: Listof(
            items: [
              ListItem(
                title: "Qté Conf [batterie]",
                subtitle: "Quantité totale produites conformes",
                value: "${QPTotal.toStringAsFixed(0)}%",
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
          Image.asset(
            pathimage,
            width: 30,
          ),
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
          color: isActive
              ? Colors.white
              : Colors.grey[300], // Change color when inactive
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), // Adjust the radius as needed
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
                color: isActive
                    ? navbar
                    : Colors.grey[400], // Inactive color for navbar
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
                          MaterialPageRoute(
                              builder: (context) => destinationPage),
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
                Image.asset(
                  imagePath2,
                  width: 65,
                ),
                IconButton(
                  iconSize: 35,
                  onPressed: onToggleVisibility,
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Forme circulaire de l'icône
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 168, 166, 166)
                              .withOpacity(
                                  0.2), // Couleur de l'ombre avec opacité
                          offset: Offset(1, 1), // Décalage de l'ombre
                          blurRadius: 2, // Flou de l'ombre
                        ),
                      ],
                    ),
                    child: Icon(
                      isListVisible
                          ? Icons.arrow_circle_up
                          : Icons.arrow_circle_down_rounded,
                      color: const Color.fromARGB(
                          255, 80, 78, 78), // Couleur de l'icône
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (isListVisible &&
                isActive) // Afficher le contenu seulement si actif
              SizedBox(
                child: content1,
              ),
          ],
        ),
      ),
    );
  }
}
