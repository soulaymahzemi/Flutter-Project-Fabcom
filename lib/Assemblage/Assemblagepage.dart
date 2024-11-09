import 'package:arames_project/Assemblage/List2.dart';
import 'package:arames_project/Assemblage/classe%20.dart';
import 'package:arames_project/Assemblage/time.dart';
import 'package:arames_project/colors/colors.dart';
import 'package:flutter/material.dart';
import '../dashbord/appbar.dart';
import 'indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON

class Ligne extends StatefulWidget {
  const Ligne({super.key});

  @override
  State<Ligne> createState() => _LigneState();
  
}

class _LigneState extends State<Ligne> {
  List<bool> _isListVisible1 = [false, false, false];
  List<bool> _showTimePage = [false, false, false];
  List<dynamic> _datatbs = [];
  List<dynamic> _dataSovema1 = [];
  List<dynamic> _dataSovema2 = [];

// Déclaration des variables d'instance
  double trsTotal = 0.0;
  double tpTotal = 0.0;
  double tdTotal = 0.0;
  double tqTotal = 0.0;
  double trTotal = 0.0;
  int nofTbs = 0;
  int nofSovema1 =0;
  int nofSovema2 = 0;
 double QPTotal=0.0;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }


Future<void> _fetchData() async {
  try {
    final responseTbs = await http.get(Uri.parse('http://192.168.0.105:3001/api/v1/machine/tbs'));
    final responseSovema1 = await http.get(Uri.parse('http://192.168.0.105:3002/api/v1/machine/sovema1'));
    final responseSovema2 = await http.get(Uri.parse('http://192.168.0.105:3003/api/v1/machine/sovema2'));

    if (responseTbs.statusCode == 200 && responseSovema1.statusCode == 200 && responseSovema2.statusCode == 200) {
      final List<dynamic> tbsData = json.decode(responseTbs.body);
      final List<dynamic> sovema1Data = json.decode(responseSovema1.body);
      final List<dynamic> sovema2Data = json.decode(responseSovema2.body);

      setState(() {
        _datatbs = tbsData;
        _dataSovema1 = sovema1Data;
        _dataSovema2 = sovema2Data;

        // Extraction des valeurs de N°OF
        nofTbs = _datatbs[0]['OF']['NOF'] ?? '';
        nofSovema1 = _dataSovema1[0]['OF']['NOF'] ?? '';
        nofSovema2 = _dataSovema2[0]['OF']['NOF'] ?? '';

        // Calcul des totaux, divisés par 3
        trsTotal = (_datatbs[0]['KPIe']['TRS'] + _dataSovema1[0]['KPIs']['TRS'] + _dataSovema2[0]['KPIs']['TRS']) / 3;
        tpTotal = (_datatbs[0]['KPIs']['TP'] + _dataSovema1[0]['KPIs']['TP'] + _dataSovema2[0]['KPIs']['TP']) / 3;
        tdTotal = (_datatbs[0]['KPIs']['TD'] + _dataSovema1[0]['KPIs']['TD'] + _dataSovema2[0]['KPIs']['TD']) / 3;
        tqTotal = (_datatbs[0]['KPIs']['TQ'] + _dataSovema1[0]['KPIs']['TQ'] + _dataSovema2[0]['KPIs']['TQ']) / 3;
        trTotal = (_datatbs[0]['KPIs']['TR'] + _dataSovema1[0]['KPIs']['TR'] + _dataSovema2[0]['KPIs']['TR']) / 3;

        // Production calculée divisée par 3
        QPTotal = (_datatbs[0]['OF']['QP'] + _dataSovema1[0]['OF']['QP'] + _dataSovema2[0]['OF']['QP']) / 3;
      });

      print(_datatbs);
      print(_dataSovema1);
      print(_dataSovema2);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
}


    // Function to calculate percentage
  double calculatePercentage(dynamic data) {
    final int qo = data['OF']['QO'] ?? 0;
    final int qp = data['OF']['QP'] ?? 0;

    if (qo == 0 || qp == 0) {
      return 0.0;
    } else if (qp > qo) {
      return 1.0; // 100% if `QP` is greater than `QO`
    } else {
      return (qo + qp) / 2 / qo;
    }
  }
  void _toggleListVisibility(int index) { 
    setState(() {
      _isListVisible1[index] = !_isListVisible1[index];
      _showTimePage[index] = _isListVisible1[index];
    });
  }

@override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        children: [
          _ListCard(
            title: 'TBS',
            subtitle: 'Ligne',
            TimePage1: TimePage(),
            imagePath: 'assets/images/mach.png',
             showTimePage:_showTimePage[0],
            isListVisible: _isListVisible1[0],
            onToggleVisibility: () => _toggleListVisibility(0),
            contentwidget: TBScontent(presentage:  _datatbs.isNotEmpty ? calculatePercentage(_datatbs[0]) : 0.0),
           
          ),
          SizedBox(height: 10),
          _ListCard(
              title: 'SOVEMA1',
              subtitle: 'Ligne',
              TimePage1: TimePage(),
              imagePath: 'assets/images/mach.png',
              isListVisible: _isListVisible1[1],
              onToggleVisibility: () => _toggleListVisibility(1),
              contentwidget: Sovema1content(presentage: _dataSovema1.isNotEmpty ? calculatePercentage(_dataSovema1[0]) : 0.0),
              showTimePage: _showTimePage[1],
              ),
             
          SizedBox(height: 10),
          _ListCard(
            title: 'SOVEMA2',
           TimePage1: TimePage(),
            subtitle: 'Ligne',
            imagePath: 'assets/images/mach.png',
            isListVisible: _isListVisible1[2],
            onToggleVisibility: () => _toggleListVisibility(2),
            contentwidget: Sovema2content(presentage: _dataSovema2.isNotEmpty ? calculatePercentage(_dataSovema2[0]) : 0.0),
            showTimePage:_showTimePage[2],
          ),
        ],
      ),
    );
  }


  // card1
  Widget TBScontent({required double presentage} ) {
   return 
         Column(         
      children: [
        fun2('OF | Progression d\'OF', 'assets/images/of.png'),
         IndicateurPage(percentage: presentage,),

        Container(
           constraints: BoxConstraints(maxHeight: 450),
          child: Listof(
            items: [
            ListItem(title: "N°OF", subtitle: "Numéro de l’ordre de fabrication", value:_datatbs.isNotEmpty ? _datatbs[0]['OF']['NOF'] : "112365"),
              ListItem( title: "Réf Art",subtitle: "Référence de l’article à réaliser", value: _datatbs.isNotEmpty ? _datatbs[0]['OF']['Article'] : "Batterie 52 AH STD FORZA Premium"),
              ListItem(  title: "Qté Obj", subtitle: "TQuantité objectif à réaliser",  value: _datatbs.isNotEmpty ? _datatbs[0]['OF']['QO'] : "9"),
              ListItem( title: "Production", subtitle: "Quantité réalisée jusqu’à l’instant", value: _datatbs.isNotEmpty ? _datatbs[0]['OF']['QP'] : "6"),
            ],
          ),
        ),
        fun2('KPI | Performance de l\'UAP', 'assets/images/iconKpi.webp'),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(items: [
            ListItem(title: "TRS", subtitle: "Taux de rendement synthétique",value: _datatbs.isNotEmpty ? _datatbs[0]['KPIs']['TRS'] : "1" ),
            ListItem(title: "TP", subtitle: "Taux de performance", value:  _datatbs.isNotEmpty ? _datatbs[0]['KPIs']['TP'] : "1"),
            ListItem( title: "TD", subtitle: "Taux de disponibilité", value:  _datatbs.isNotEmpty ? _datatbs[0]['KPIs']['TD'] : "3"),
            ListItem(title: "TQ", subtitle: "Taux de qualité", value:  _datatbs.isNotEmpty ? _datatbs[0]['KPIs']['TQ'] : "2"),
            ListItem(title: "TR", subtitle: "Taux retouche", value:  _datatbs.isNotEmpty ? _datatbs[0]['KPIs']['TR'] : "1"),
          ]
          
          ),
          
        ),
        fun2('Process | Paramètres process', 'assets/images/process.png'),
        Container(
          constraints: BoxConstraints(maxHeight: 480),
          child: Listof(items: [
            ListItem(title: "TC Env [sec]",subtitle: "Cadence réelle de la phase enveloppeuse",value: "0"),
            ListItem( title: "TC COS [sec]",subtitle: "Temps de cycle réel de la phase COS",value: "0"),
            ListItem(title: "TC SC [sec]",subtitle: "Temps de cycle réel soudure des connexions",value: "0"),
            ListItem(title: "TC BC [sec]",subtitle: "Temps de cycle réel soudure Bac/couvercle", value: "0"),
            ListItem(title: "TC th [sec]",subtitle: "Temps de cycle théorique de la ligne",value: "0"),
          ]),
        ),
        SizedBox(height: 20,),
      ],
    );
  }

  //card2
  Widget Sovema1content( {required double presentage}) {
    return Column(
      children: [
        fun2('OF | Progression d\'OF', 'assets/images/of.png'),
                IndicateurPage(percentage: presentage,),

        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(
            items: [
              ListItem( title: "N°OF", subtitle: "Numéro de l’ordre de fabrication",value: _dataSovema1.isNotEmpty ? _dataSovema1[0]['OF']['NOF'] : "1"),
              ListItem(title: "Réf Art",subtitle: "Référence de l’article à réaliser", value: _dataSovema1.isNotEmpty ? _dataSovema1[0]['OF']['Articles'] : "batterie 523 ww"),
              ListItem( title: "Qté Obj", subtitle: "TQuantité objectif à réaliser", value: _dataSovema1.isNotEmpty ? _dataSovema1[0]['OF']['QO'] : "1"),
              ListItem(title: "Production",subtitle: "Quantité réalisée jusqu’à l’instant",value: _dataSovema1.isNotEmpty ? _dataSovema1[0]['OF']['QP'] : "1"),
            ],
          ),
        ),
        fun2('KPI | Performance de l\'UAP', 'assets/images/iconKpi.webp'),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(items: [
            ListItem(title: "TRS",subtitle: "Taux de rendement synthétique", value: _dataSovema1.isNotEmpty ? _dataSovema1[0]['KPIs']['TRS'] : "1"),
            ListItem(title: "TP", subtitle: "Taux de performance", value:  _dataSovema1.isNotEmpty ? _dataSovema1[0]['KPIs']['TP'] : "1"),
            ListItem(title: "TD", subtitle: "Taux de disponibilité", value:  _dataSovema1.isNotEmpty ? _dataSovema1[0]['KPIs']['TD'] : "1"),
            ListItem(title: "TQ", subtitle: "Taux de qualité", value:  _dataSovema1.isNotEmpty ? _dataSovema1[0]['KPIs']['TQ'] : "1"),
            ListItem(title: "TR", subtitle: "Taux retouche", value:  _dataSovema1.isNotEmpty ? _dataSovema1[0]['KPIs']['TR'] : "1"),
          ]),
        ),
        fun2('Process | Paramètres process', 'assets/images/process.png'),
        Container(
          constraints: BoxConstraints(maxHeight: 480),
          child: Listof(items: [
            ListItem(title: "TC Env [sec]",subtitle: "Cadence réelle de la phase enveloppeuse",value: "0"),
            ListItem( title: "TC COS [sec]",subtitle: "Temps de cycle réel de la phase COS",value: "0"),
            ListItem( title: "TC SC [sec]",   subtitle: "Temps de cycle réel soudure des connexions",   value: "0"),
            ListItem(title: "TC BC [sec]",subtitle: "Temps de cycle réel soudure Bac/couvercle",value: "0"),
            ListItem(  title: "TC th [sec]",  subtitle: "Temps de cycle théorique de la ligne",value: "0"),
          ]),
        ),
        SizedBox( height: 20, ),
      ],
    );
  }

  //card3
  Widget Sovema2content({required double presentage}) {
   
   

    return Column(
      children: [
        fun2('OF | Progression d\'OF', 'assets/images/of.png'),
                IndicateurPage(percentage: presentage,),

        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(
            items: [
              ListItem(title: "N°OF",subtitle: "Numéro de l’ordre de fabrication",value:  _dataSovema2.isNotEmpty ? _dataSovema2[0]['OF']['NOF'] : "1"),
              ListItem( title: "Réf Art", subtitle: "Référence de l’article à réaliser",value:  _dataSovema2.isNotEmpty ? _dataSovema2[0]['OF']['Article'] : "1"),
              ListItem(  title: "Qté Obj",  subtitle: "TQuantité objectif à réaliser",  value:  _dataSovema2.isNotEmpty ? _dataSovema2[0]['OF']['QO'] : "1"),
              ListItem(title: "Production",subtitle: "Quantité réalisée jusqu’à l’instant",value:  _dataSovema2.isNotEmpty ? _dataSovema2[0]['OF']['QP'] : "1"),
            ],
          ),
        ),
        fun2('KPI | Performance de l\'UAP', 'assets/images/iconKpi.webp'),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(items: [
            ListItem( title: "TRS", subtitle: "Taux de rendement synthétique", value:  _dataSovema2.isNotEmpty ? _dataSovema2[0]['KPIs']['TRS'] : "1"),
            ListItem(title: "TP", subtitle: "Taux de performance", value: _dataSovema2.isNotEmpty ? _dataSovema2[0]['KPIs']['TP'] : "1"),
            ListItem( title: "TD", subtitle: "Taux de disponibilité", value:  _dataSovema2.isNotEmpty ? _dataSovema2[0]['KPIs']['TD'] : "1"),
            ListItem(title: "TQ", subtitle: "Taux de qualité", value:  _dataSovema2.isNotEmpty ? _dataSovema2[0]['KPIs']['TQ'] : "1"),
            ListItem(title: "TR", subtitle: "Taux retouche", value: _dataSovema2.isNotEmpty ? _dataSovema2[0]['KPIs']['TR'] : "1"),
          ]),
        ),
        fun2('Process | Paramètres process', 'assets/images/process.png'),
        Container(
          constraints: BoxConstraints(maxHeight: 480),
          child: Listof(items: [
            ListItem( title: "TC Env [sec]", subtitle: "Cadence réelle de la phase enveloppeuse", value: "0"),
            ListItem(title: "TC COS [sec]",subtitle: "Temps de cycle réel de la phase COS",value: "0"),
            ListItem(  title: "TC SC [sec]", subtitle: "Temps de cycle réel soudure des connexions",  value: "0"),
            ListItem(  title: "TC BC [sec]",subtitle: "Temps de cycle réel soudure Bac/couvercle",  value: "0"),
            ListItem( title: "TC th [sec]", subtitle: "Temps de cycle théorique de la ligne", value: "0"),
          ]),
        ),
        SizedBox( height: 20, ),
      ],
    );
  }

//******************************* */
  Widget _ListCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required bool isListVisible,
    required VoidCallback onToggleVisibility,
    required Widget contentwidget,
    required Widget TimePage1,
    required bool showTimePage,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: green1,
              boxShadow: [
                BoxShadow(
                  color: shadowcolor,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              title: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: textcolor),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: textcolor),
              ),
            ),
          ),
          SizedBox(height: 10,),
         if(showTimePage) TimePage1,

          Image.asset(imagePath),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Poste: ${PeriodeDay()}",
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: onToggleVisibility,
                      icon: Icon(
                        
                        isListVisible
                            ? Icons.arrow_circle_up_rounded
                            : Icons.arrow_circle_down_rounded,
                      ),
                    ),
                  ],
                ),
                if (isListVisible) contentwidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
 
//******************* */
  Widget fun2(String title, String pathimage) {
    return Container(
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
          Flexible(
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
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
  
  PeriodeDay() {
     final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 6 && hour < 14) {
    return "Matin";
  } else if (hour >= 14 && hour < 22) {
    return "Après-midi";
  } else {
    return "Nuit";
  }
  }
}
