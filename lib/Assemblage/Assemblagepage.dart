import 'package:arames_project/Assemblage/List2.dart';
import 'package:arames_project/Assemblage/classe%20.dart';
import 'package:arames_project/colors/colors.dart';
import 'package:arames_project/dashbord/homepage.dart';
import 'package:arames_project/dashbord/men.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../dashbord/appbar.dart';
import 'indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:arames_project/Assemblage/time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ligne extends StatefulWidget {
  const Ligne({super.key});

  @override
  State<Ligne> createState() => _LigneState();
}

class _LigneState extends State<Ligne> {
  List<bool> _isListVisible1 = [false, false, false];
  List<bool> _showTimePage = [false, false, false];
  //api connection
  Map<String, dynamic>? sovema1Data;
  Map<String, dynamic>? sovema2Data;
  Map<String, dynamic>? data;
//webshooket
  Map<String, IO.Socket?> sockets = {};
  Map<String, dynamic>? dataTbs1;
  Map<String, dynamic>? dataSovema1;
  Map<String, dynamic>? dataSovema2;
// Déclaration des variables d'instance

  double trsTotal = 0.0;
  double tpTotal = 0.0;
  double tdTotal = 0.0;
  double tqTotal = 0.0;
  double trTotal = 0.0;

  double QPTotal = 0.0;
  String nofValue = ""; // Declare it as a class-level variable
  String nofSovema1 = "";
  String nofSovema2 = "";

  String? errorMessage;
  int tpsArt = 0;
  int tpsMrc = 0;

// Variables pour stocker les données reçues par WebSocket

  double calculatePercentage(dynamic data) {
    final int qo = data?['OF']['QO'] ?? 0;
    final int qp = data?['OF']['QP'] ?? 0;

    if (qo == 0 || qp == 0) {
      return 0.0; // Retourner 0 si l'une des valeurs est égale à 0
    } else if (qp > qo) {
      return 1.0; // Si QP est plus grand que QO, retourner 100%
    } else {
      // Calcul du pourcentage normal
      return (qo / qp) * 100;
    }
  }

  double calculatePercentagesovema1(dynamic sovema1Data) {
    final int qo = sovema1Data?['OF']['QO'] ?? 0;
    final int qp = sovema1Data?['OF']['QP'] ?? 0;

    if (qo == 0 || qp == 0) {
      return 0.0; // Retourner 0 si l'une des valeurs est égale à 0
    } else if (qp > qo) {
      return 1.0; // Si QP est plus grand que QO, retourner 100%
    } else {
      // Calcul du pourcentage normal
      return (qo / qp) * 100;
    }
  }

  double calculatePercentagesovema2(dynamic sovema2Data) {
    final int qo = sovema2Data?['OF']['QO'] ?? 0;
    final int qp = sovema2Data?['OF']['QP'] ?? 0;

    if (qo == 0 || qp == 0) {
      return 0.0; // Retourner 0 si l'une des valeurs est égale à 0
    } else if (qp > qo) {
      return 1.0; // Si QP est plus grand que QO, retourner 100%
    } else {
      // Calcul du pourcentage normal
      return (qo / qp) * 100;
    }
  }

  void _toggleListVisibility(int index) {
    setState(() {
      _isListVisible1[index] = !_isListVisible1[index];
      _showTimePage[index] = _isListVisible1[index];
    });
  }

//suvgraderr
  Future<void> saveDataToCache(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(data));
  }

//apisauvegrader sharedpreference api
  Future<dynamic> loadDataFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }




  void connectSockets()  {
    // Connecting to all Socket.IO instances
    sockets['tbs1'] = IO.io('http://localhost:5003', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    sockets['sovema1'] = IO.io('http://localhost:5002', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    sockets['sovema2'] = IO.io('http://localhost:5001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Listening for data updates from each socket
    sockets['tbs1']?.on('kpiData', (jsonData) async {
      print('tbs 1 Données reçues: $jsonData');

      setState(() {
        dataTbs1 = jsonData;
        // Divide cad_env, cad_cos, cad_soud by 1000 and round the values

        dataTbs1?['cad_env'] = ((dataTbs1?['cad_env'] as num) / 1000).round();
        dataTbs1?['cad_cos'] = ((dataTbs1?['cad_cos'] as num) / 1000).round();
        dataTbs1?['cad_soud'] = ((dataTbs1?['cad_soud'] as num) / 1000).round();
        dataTbs1?['cad'] = ((dataTbs1?['cad'] as num) / 1000).round();
      });

  // Sauvegarder dans le cache

    });

    sockets['sovema1']?.on('kpiData', (jsonData) async {
      print('sovema1 Données reçues: $jsonData');

      setState(() {
        dataSovema1 = jsonData;
        // Divide cad_env, cad_cos, cad_soud by 1000 and round the values
        dataSovema1?['cad_env'] =
            ((dataSovema1?['cad_env'] as num) / 1000).round();
        dataSovema1?['cad_cos'] =
            ((dataSovema1?['cad_cos'] as num) / 1000).round();
        dataSovema1?['cad_soud'] =
            ((dataSovema1?['cad_soud'] as num) / 1000).round();
        dataSovema1?['cad'] = ((dataSovema1?['cad'] as num) / 1000).round();
      });

    });

    sockets['sovema2']?.on('kpiData', (jsonData) async {
      print(' sovema2 Données reçues: $jsonData');

      setState(() {
        dataSovema2 = jsonData;
        // Divide cad_env, cad_cos, cad_soud by 1000 and round the values
        dataSovema2?['cad_env'] =
            ((dataSovema2?['cad_env'] as num) / 1000).round();
        dataSovema2?['cad_cos'] =
            ((dataSovema2?['cad_cos'] as num) / 1000).round();
        dataSovema2?['cad_soud'] =
            ((dataSovema2?['cad_soud'] as num) / 1000).round();
        dataSovema2?['cad'] = ((dataSovema2?['cad'] as num) / 1000).round();
      });

    });
 // Handle connection errors
    sockets['tbs1']?.on('connect_error', (data) {
      setState(() {
        errorMessage = 'Erreur de connexion à TBS 1';
      });
      print('Erreur de connexion à TBS 1: $data');
    });

    sockets['sovema1']?.on('connect_error', (data) {
      setState(() {
        errorMessage = 'Erreur de connexion à Sovema 1';
      });
      print('Erreur de connexion à Sovema 1: $data');
    });

    sockets['sovema2']?.on('connect_error', (data) {
      setState(() {
        errorMessage = 'Erreur de connexion à Sovema 2';
      });
      print('Erreur de connexion à Sovema 2: $data');
    });
  }

  
 

  Future<void> fetchMachines() async {
    try {
      // Charger les données en cache
      data = await loadDataFromCache('tbsData');
      sovema1Data = await loadDataFromCache('sovema1Data');
      sovema2Data = await loadDataFromCache('sovema2Data');

      // Fetch TBS data
      final responseTBS =
          await http.get(Uri.parse('http://localhost:3001/api/v1/machine/tbs'));
      if (responseTBS.statusCode == 200) {
        data = json.decode(responseTBS.body);
        await saveDataToCache('tbsData', data); // Enregistrer dans le cache
        print('TBS Data: $data');
      }

      // Fetch Sovema1 data
      final responseSovema1 = await http
          .get(Uri.parse('http://localhost:3002/api/v1/machine/sovema1'));
      if (responseSovema1.statusCode == 200) {
        sovema1Data = json.decode(responseSovema1.body);
        await saveDataToCache(
            'sovema1Data', sovema1Data); // Enregistrer dans le cache
        print('SOVEMA1 Data: $sovema1Data');
      }

      // Fetch Sovema2 data
      final responseSovema2 = await http
          .get(Uri.parse('http://localhost:3003/api/v1/machine/sovema2'));
      if (responseSovema2.statusCode == 200) {
        sovema2Data = json.decode(responseSovema2.body);
        await saveDataToCache(
            'sovema2Data', sovema2Data); // Enregistrer dans le cache
        print('SOVEMA2 Data: $sovema2Data');
      }

      setState(() {
        calculatePercentage(data);
        calculatePercentagesovema1(sovema1Data);
        calculatePercentagesovema2(sovema2Data);

        trsTotal = ((data?['KPIs']['TRS'] ?? 0) +
                (sovema1Data?['KPIs']['TRS'] ?? 0) +
                (sovema2Data?['KPIs']['TRS'] ?? 0)) /
            3;
        tpTotal = ((data?['KPIs']['TP'] ?? 0) +
                (sovema1Data?['KPIs']['TP'] ?? 0) +
                (sovema2Data?['KPIs']['TP'] ?? 0)) /
            3;
        tdTotal = ((data?['KPIs']['TD'] ?? 0) +
                (sovema1Data?['KPIs']['TD'] ?? 0) +
                (sovema2Data?['KPIs']['TD'] ?? 0)) /
            3;
        tqTotal = ((data?['KPIs']['TQ'] ?? 0) +
                (sovema1Data?['KPIs']['TQ'] ?? 0) +
                (sovema2Data?['KPIs']['TQ'] ?? 0)) /
            3;
        trTotal = ((data?['KPIs']['TR'] ?? 0) +
                (sovema1Data?['KPIs']['TR'] ?? 0) +
                (sovema2Data?['KPIs']['TR'] ?? 0)) /
            3;
        QPTotal = ((data?['OF']?['QP'] ?? 0) +
                (sovema1Data?['OF']?['QP'] ?? 0) +
                (sovema2Data?['OF']?['QP'] ?? 0)) /
            3;
        nofValue = data?['OF']?['NOF'] ?? 0;
        print('NOF Value: $nofValue');
        nofSovema1 = sovema1Data?['OF']['NOF'] ?? 0;
        print('NOF Valuesovema 1: $nofSovema1');
        nofSovema2 = sovema2Data?['OF']['NOF'] ?? 0;
        print('NOF Value sovema2: $nofSovema2');
        print('valeur de qtotlae: $QPTotal');
        print('valeur de td: $tdTotal');
        print('valeur de tp: $tpTotal');
        print('valeur de tq: $tqTotal');
        print('valeur de tr: $trTotal');
        print('valeur de trs: $trsTotal');
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
      });
    }
  }


@override
void initState() {
  super.initState();
  fetchMachines();
  connectSockets();
}

  @override
  void dispose() {
    sockets.forEach((key, socket) {
      socket?.dispose();
    });
    super.dispose();
  }

Color getShadowColor(String kpi, double value) {
  if (value == 0.0) {
    return shadowcolor; // Si aucune valeur ou valeur égale à 0
  }

  if (kpi == "TRS") {
    if (value > 90) {
      return green1;  // Vert si TRS > 90
    } else if (value > 55 && value < 65) {
      return Colors.yellow; // Jaune si 55 < TRS < 65
    } else {
      return red1;    // Rouge si TRS < 55
    }
  } else if (kpi == "TP" || kpi == "TQ" || kpi =="TR") {
    if (value > 90) {
      return green1;  // Vert si TP ou TQ > 90
    } else if (value > 80 && value < 90) {
      return Colors.yellow; // Jaune si 80 < TP/TQ < 90
    } else {
      return red1;    // Rouge si TP/TQ < 80
    }
  } else if (kpi == "TD" ) {
    if (value > 75) {
      return green1;    // Vert si TD > 75
    } else if (value > 55 && value < 75) {
      return Colors.yellow; // Jaune si 55 < TD <= 75
    } else {
      return red1;    // Rouge si TD < 55
    }
  }
  
  return Colors.white;       // Valeur par défaut si aucun KPI
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: const Color.fromARGB(255, 13, 12, 12), size: 15),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(
                          nofValue: nofValue,
                          nofSovema1: nofSovema1,
                          nofSovema2: nofSovema2,
                          QPTotal: QPTotal,
                          trsTotal: trsTotal,
                          tpTotal: tpTotal,
                          tdTotal: tdTotal,
                          tqTotal: tqTotal,
                          trTotal: trTotal,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  'UAP-Assemblage',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textcolor),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  _ListCard(
                    title: 'TBS',
                    subtitle: 'Ligne',
                    TimePage1: TimePage(
                      tpsArt: dataTbs1?['tps_art'] ?? 0,
                      tpsMrc: dataTbs1?['tps_mrc'] ?? 0,
                    ),
                    imagePath: 'assets/images/mach.png',
                    showTimePage: _showTimePage[0],
                    isListVisible: _isListVisible1[0],
                    onToggleVisibility: () => _toggleListVisibility(0),
                    contentwidget:
                        TBScontent(presentage: calculatePercentage(data)),
                    containerColor: dataTbs1?['etat'] == true
                        ? green1
                        : red1, // Color change based on etat
                  ),
                   _ListCard(
                    title: 'SOVEMA1',
                    subtitle: 'Ligne',
                    TimePage1: TimePage(
                      tpsArt: dataSovema1?['tps_art'] ?? 0,
                      tpsMrc: dataSovema1?['tps_mrc'] ?? 0,
                    ),
                    imagePath: 'assets/images/mach.png',
                    isListVisible: _isListVisible1[1],
                    onToggleVisibility: () => _toggleListVisibility(1),
                    contentwidget: Sovema1content(
                        presentage: calculatePercentage(sovema1Data)),
                    showTimePage: _showTimePage[1],
                    containerColor: dataSovema1?['etat'] == true
                        ? green1
                        : red1, // Color change based on etat
                  ),
                  _ListCard
                  (
                    title: 'SOVEMA2',
                    TimePage1: TimePage(
                      tpsArt: dataSovema2?['tps_art'] ?? 0,
                      tpsMrc: dataSovema2?['tps_mrc'] ?? 0,
                    ),
                    subtitle: 'Ligne',
                    imagePath: 'assets/images/mach.png',
                    isListVisible: _isListVisible1[2],
                    onToggleVisibility: () => _toggleListVisibility(2),
                   contentwidget: Sovema2content(
                       presentage: calculatePercentage(sovema2Data)),
                    showTimePage: _showTimePage[2],
                    containerColor: dataSovema2?['etat'] == true
                        ? green1
                        : red1, // Color change based on etat
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget TBScontent({required double presentage}) {
    return Column(
      children: [
        fun2('OF | Progression d\'OF', 'assets/images/of.png'),
        IndicateurPage(percentage: calculatePercentage(data)),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(
            items: [
              ListItem(
                title: "N°OF",
                subtitle: "Numéro de l’ordre de fabrication",
                value: '${data?['OF']['NOF'] ?? "0"}',
                shadowColor: shadowcolor,
                
              ),
              ListItem(
                title: "Réf Art",
                subtitle: "Référence de l’article à réaliser",
                value: '${data?['OF']['Article'] ?? "0"}',
                shadowColor: shadowcolor
              ),
              ListItem(
                title: "Qté Obj",
                subtitle: "Quantité objectif à réaliser",
                value: '${data?['OF']['QO'] ?? "0"}',
                shadowColor: shadowcolor
              ),
              ListItem(
                title: "Production",
                subtitle: "Quantité réalisée jusqu’à l’instant",
                value: '${data?['OF']['QP'] ?? "0"}',
                shadowColor: shadowcolor
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        fun2('KPI | Performance De la Machine ', 'assets/images/iconKpi.webp'),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(
            items: [
              ListItem(
                title: "TRS",
                subtitle: "Taux de rendement synthétique",
                value: '${(data?['KPIs']['TRS'] ?? 0.0).toStringAsFixed(0)}%',
                shadowColor: getShadowColor("TRS", data?['KPIs']['TRS'] ?? 0.0),

              ),
              ListItem(
                title: "TP",
                subtitle: "Taux de performance",
                value: '${(data?['KPIs']['TP'] ?? 0.0).toStringAsFixed(0)}%',
                shadowColor: getShadowColor("TP", data?['KPIs']['TP'] ?? 0.0),

              ),
              ListItem(
                title: "TD",
                subtitle: "Taux de disponibilité",
                value: '${(data?['KPIs']['TD'] ?? 0.0).toStringAsFixed(0)}%',
               shadowColor: getShadowColor("TD", data?['KPIs']['TD'] ?? 0.0),

              ),
              ListItem(
                title: "TQ",
                subtitle: "Taux de qualité",
                value: '${(data?['KPIs']['TQ'] ?? 0.0).toStringAsFixed(0)}%',
                  shadowColor: getShadowColor("TQ", data?['KPIs']['TQ'] ?? 0.0),

              ),
              ListItem(
                title: "TR",
                subtitle: "Taux retouche",
                value: '${(data?['KPIs']['TR'] ?? 0.0).toStringAsFixed(0)}%',
                              shadowColor: getShadowColor("TR", data?['KPIs']['TR'] ?? 0.0),

              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        fun2('Process | Paramètres process', 'assets/images/process.png'),
        Container(
          constraints: BoxConstraints(maxHeight: 480),
          child: Listof(items: [
            ListItem(
                title: "TC Env [sec]",
                subtitle: "Cadence réelle de la phase enveloppeuse",
                value: ' ${dataTbs1?['cad_env'] ?? '0'}'
                ,shadowColor: shadowcolor
                ),
                
            ListItem(
                title: "TC COS [sec]",
                subtitle: "Temps de cycle réel de la phase COS",
                value: '${dataTbs1?['cad_cos'] ?? '0'}'
                ,shadowColor: shadowcolor),
            ListItem(
                title: "TC SC [sec]",
                subtitle: "Temps de cycle réel soudure des connexions",
                value: '${dataTbs1?['cad_soud'] ?? '0'}'
                ,shadowColor: shadowcolor),
            ListItem(
                title: "TC BC [sec]",
                subtitle: "Temps de cycle réel soudure Bac/couvercle",
                value: '${dataTbs1?['cad'] ?? '0'}'
                ,shadowColor: shadowcolor),
            ListItem(
                title: "TC th [sec]",
                subtitle: "Temps de cycle théorique de la ligne",
                value: '30%',shadowColor: shadowcolor),
          ]),
        ),
        SizedBox( height: 10, ),
          Container(
         constraints: BoxConstraints(maxHeight: 480),
        child: Listof(items: [
          ListItem(title: 'Arrêt [sec]', subtitle:'Dernier arrêt enregistré par cause' ,
           value:'${data?['historique'][0]['Arrêts'] ?? "00:00:09"}',shadowColor: shadowcolor),
           ListItem(title: 'Qté NC [BAT]', subtitle: 'Dernière quantité NC déclarée par cause ', 
           value: '${data?['historique'][0]['Qté NC']?.toString() ?? "0"}',shadowColor: shadowcolor ),
        ]),

        ),
      SizedBox(height: 10,),
    
      ],
    );
  }

  //card2
  Widget Sovema1content({required double presentage}) {
    return Column(
      children: [
        fun2('OF | Progression d\'OF', 'assets/images/of.png'),
        IndicateurPage(
          percentage: calculatePercentage(sovema1Data),
        ),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(
            items: [
              ListItem(
                  title: "N°OF",
                  subtitle: "Numéro de l’ordre de fabrication",
                  value: '${sovema1Data?['OF']['NOF'] ?? "0"}',
                  shadowColor: shadowcolor),
              ListItem(
                  title: "Réf Art",
                  subtitle: "Référence de l’article à réaliser",
                  value: '${sovema1Data?['OF']['Article'] ?? "0"}',
                  shadowColor: shadowcolor),
              ListItem(
                  title: "Qté Obj",
                  subtitle: "Quantité objectif à réaliser",
                  value: '${sovema1Data?['OF']?['QO'] ?? "0"}',
                  shadowColor: shadowcolor),
              ListItem(
                  title: "Production",
                  subtitle: "Quantité réalisée jusqu’à l’instant",
                  value: '${sovema1Data?['OF']['QP'] ?? "0"}',
                  shadowColor: shadowcolor),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        fun2('KPI | Performance De la Machine ', 'assets/images/iconKpi.webp'),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(items: [
            ListItem(
                title: "TRS",
                subtitle: "Taux de rendement synthétique",
                value:
                    '${(sovema1Data?['KPIs']['TRS'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TRS", sovema1Data?['KPIs']['TRS'] ?? 0.0)
                    
                    ),
            ListItem(
                title: "TP",
                subtitle: "Taux de performance",
                value:
                    '${(sovema1Data?['KPIs']['TP'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TP", sovema1Data?['KPIs']['TP'] ?? 0.0),
                    
                    ),
            ListItem(
                title: "TD",
                subtitle: "Taux de disponibilité",
                value:
                    '${(sovema1Data?['KPIs']['TD'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TD", sovema1Data?['KPIs']['TD'] ?? 0.0)
                    ),
            ListItem(
                title: "TQ",
                subtitle: "Taux de qualité",
                value:
                    '${(sovema1Data?['KPIs']['TQ'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TQ", sovema1Data?['KPIs']['TQ'] ?? 0.0)),
            ListItem(
                title: "TR",
                subtitle: "Taux retouche",
                value:
                    '${(sovema1Data?['KPIs']['TR'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TR", sovema1Data?['KPIs']['TR'] ?? 0.0)),
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        fun2('Process | Paramètres process', 'assets/images/process.png'),
        Container(
          constraints: BoxConstraints(maxHeight: 480),
          child: Listof(items: [
            ListItem(
                title: "TC Env [sec]",
                subtitle: "Cadence réelle de la phase enveloppeuse",
                value: '${dataSovema1?['cad_env'] ?? '0'}',
                shadowColor: shadowcolor),
            ListItem(
                title: "TC COS [sec]",
                subtitle: "Temps de cycle réel de la phase COS",
                value: '${dataSovema1?['cad_cos'] ?? '0'}',
                shadowColor: shadowcolor),
            ListItem(
                title: "TC SC [sec]",
                subtitle: "Temps de cycle réel soudure des connexions",
                value: '${dataSovema1?['cad_soud'] ?? '0'}',shadowColor: shadowcolor),
            ListItem(
                title: "TC BC [sec]",
                subtitle: "Temps de cycle réel soudure Bac/couvercle",
                value: '${dataSovema1?['cad'] ?? '0'}',shadowColor: shadowcolor),
            ListItem(
                title: "TC th [sec]",
                subtitle: "Temps de cycle théorique de la ligne",
                value: "30%",
                shadowColor: shadowcolor),
          ]),
        ),
        SizedBox( height: 20, ),
        fun2('Alerte| flash incidents ', 'assets/images/news.png'),
        Container(
         constraints: BoxConstraints(maxHeight: 480),
        child: Listof(items: [
         ListItem(title: 'Arrêt [sec]', subtitle:'Dernier arrêt enregistré par cause' ,
           value: '${sovema1Data?['historique'][0]['Arrêts'] ?? "00:00:09"}',shadowColor: shadowcolor),
           ListItem(title: 'Qté NC [BAT]', subtitle: 'Dernière quantité NC déclarée par cause ',
            value:'${sovema1Data?['historique'][0]['Qté NC']?.toString() ?? "0"}',shadowColor: shadowcolor)
        ]),

        ),
      SizedBox(height: 10,),

      ],
    );
  }

  //card2
  Widget Sovema2content({required double presentage}) {
    return Column(
      children: [
        fun2('OF | Progression d\'OF', 'assets/images/of.png'),
        IndicateurPage(
          percentage: calculatePercentage(sovema2Data),
        ),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(
            items: [
              ListItem(
                  title: "N°OF",
                  subtitle: "Numéro de l’ordre de fabrication",
                  value: '${sovema2Data?['OF']['NOF'] ?? "0"}',
                  shadowColor: shadowcolor),
              ListItem(
                  title: "Réf Art",
                  subtitle: "Référence de l’article à réaliser",
                  value: '${sovema2Data?['OF']['Article'] ?? "0"}',
                  shadowColor: shadowcolor),
              ListItem(
                  title: "Qté Obj",
                  subtitle: "Quantité objectif à réaliser",
                  value: '${sovema2Data?['OF']?['QO'] ?? "0"}',
                  shadowColor: shadowcolor),
              ListItem(
                  title: "Production",
                  subtitle: "Quantité réalisée jusqu’à l’instant",
                  value: '${sovema2Data?['OF']['QP'] ?? "0"}',
                  shadowColor: shadowcolor),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        fun2('KPI | Performance De la Machine ', 'assets/images/iconKpi.webp'),
        Container(
          constraints: BoxConstraints(maxHeight: 450),
          child: Listof(items: [
            ListItem(
                title: "TRS",
                subtitle: "Taux de rendement synthétique",
                value:
                    '${(sovema2Data?['KPIs']['TRS'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TRS", sovema2Data?['KPIs']['TRS'] ?? 0.0)),
            ListItem(
                title: "TP",
                subtitle: "Taux de performance",
                value:
                    '${(sovema2Data?['KPIs']['TP'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TP", sovema2Data?['KPIs']['TP'] ?? 0.0)),
            ListItem(
                title: "TD",
                subtitle: "Taux de disponibilité",
                value:
                    '${(sovema2Data?['KPIs']['TD'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TD", sovema2Data?['KPIs']['TD'] ?? 0.0)),
            ListItem(
                title: "TQ",
                subtitle: "Taux de qualité",
                value:
                    '${(sovema2Data?['KPIs']['TQ'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TQ", sovema2Data?['KPIs']['TQ'] ?? 0.0)),
            ListItem(
                title: "TR",
                subtitle: "Taux retouche",
                value:
                    '${(sovema2Data?['KPIs']['TR'] ?? 0.0).toStringAsFixed(0)}%',
                    shadowColor: getShadowColor("TR", sovema2Data?['KPIs']['TR'] ?? 0.0)),
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        fun2('Process | Paramètres process', 'assets/images/process.png'),
        Container(
          constraints: BoxConstraints(maxHeight: 480),
          child: Listof(items: [
            ListItem(
                title: "TC Env [sec]",
                subtitle: "Cadence réelle de la phase enveloppeuse",
                value: '${dataSovema2?['cad_env'] ?? '0'}',
                shadowColor: shadowcolor),
            ListItem(
                title: "TC COS [sec]",
                subtitle: "Temps de cycle réel de la phase COS",
                value: '${dataSovema2?['cad_cos'] ?? '0'}',
                shadowColor: shadowcolor),
            ListItem(
                title: "TC SC [sec]",
                subtitle: "Temps de cycle réel soudure des connexions",
                value: '${dataSovema2?['cad_soud'] ?? '0'}',
                shadowColor: shadowcolor),
            ListItem(
                title: "TC BC [sec]",
                subtitle: "Temps de cycle réel soudure Bac/couvercle",
                value: '${dataSovema2?['cad'] ?? '0'}',
                shadowColor: shadowcolor),
            ListItem(
                title: "TC th [sec]",
                subtitle: "Temps de cycle théorique de la ligne",
                value: '30%',
                shadowColor: shadowcolor),
          ]),
        ),
        SizedBox(
          height: 20,
        ),
        fun2('Alerte| flash incidents ', 'assets/images/news.png'),
         Container(
         constraints: BoxConstraints(maxHeight: 480),
        child: Listof(items: [
          ListItem(title: 'Arrêt [sec]', subtitle:'Dernier arrêt enregistré par cause' ,
           value: '${sovema2Data?['historique'][0]['Arrêts'] ?? "00:00:00"}',
           shadowColor: shadowcolor),
          ListItem(title: 'Qté NC [BAT]', subtitle: 'Dernière quantité NC déclarée par cause ',
          value: '${sovema2Data?['historique'][0]['Qté NC']?.toString() ?? "0"}',
          shadowColor: shadowcolor)
        ]),

        ),
      SizedBox(height: 10,),

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
    required Color containerColor,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), // Adjust the radius as needed
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), // Adjust the radius as needed
                topRight: Radius.circular(30),
              ),
              color: containerColor,
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
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: textcolor),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textcolor),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (showTimePage) TimePage1,
          Image.asset(imagePath),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isListVisible
                        ? Text(
                            "Poste: ${PeriodeDay()}",
                            style: TextStyle(fontSize: 15),
                          )
                        : Image.asset(
                            'assets/images/alert.png',
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
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(230, 219, 219, 1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 0),
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
/* Future<void> fetchMachines() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('http://localhost:3001/api/v1/machine/tbs')),
        http.get(Uri.parse('http://localhost:3002/api/v1/machine/sovema1')),
        http.get(Uri.parse('http://localhost:3003/api/v1/machine/sovema2')),
      ]);

      if (responses[0].statusCode == 200) {
        data = json.decode(responses[0].body);
        print('TBS Data: $data');
      }
      if (responses[1].statusCode == 200) {
        sovema1Data = json.decode(responses[1].body);
        print('SOVEMA1 Data: $sovema1Data');
      }
      if (responses[2].statusCode == 200) {
        sovema2Data = json.decode(responses[2].body);
        print('SOVEMA2 Data: $sovema2Data');
      }

      setState(() {
        calculatePercentage(data);
        calculatePercentagesovema1(sovema1Data);
        calculatePercentagesovema2(sovema2Data);
        // Update the totals
        trsTotal = ((data?['KPIs']['TRS'] ?? 0) +
                    (sovema1Data?['KPIs']['TRS'] ?? 0) +
                    (sovema2Data?['KPIs']['TRS'] ?? 0)) /
                3;
        tpTotal = ((data?['KPIs']['TP'] ?? 0) +
                    (sovema1Data?['KPIs']['TP'] ?? 0) +
                    (sovema2Data?['KPIs']['TP'] ?? 0)) /
                3;
        tdTotal = ((data?['KPIs']['TD'] ?? 0) +
                    (sovema1Data?['KPIs']['TD'] ?? 0) +
                    (sovema2Data?['KPIs']['TD'] ?? 0)) /
                3;
        tqTotal = ((data?['KPIs']['TQ'] ?? 0) +
                    (sovema1Data?['KPIs']['TQ'] ?? 0) +
                    (sovema2Data?['KPIs']['TQ'] ?? 0)) /
                3;
        trTotal = ((data?['KPIs']['TR'] ?? 0) +
                    (sovema1Data?['KPIs']['TR'] ?? 0) +
                    (sovema2Data?['KPIs']['TR'] ?? 0)) /
                3;
        nofTbs = data?['OF']['NOF'] ?? 0;
        nofSovema1 = sovema1Data?['OF']?['NOF'] ?? 0;
        nofSovema2 = sovema2Data?['OF']?['NOF'] ?? 0;
        QPTotal = ((data?['OF']?['QP'] ?? 0) +
                    (sovema1Data?['OF']?['QP'] ?? 0) +
                    (sovema2Data?['OF']?['QP'] ?? 0)) /
                3;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
      });
    }
  }
*/

/* void connectSockets() {
    // Connecting to all Socket.IO instances
    sockets['tbs1'] = IO.io('http://localhost:5003', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    sockets['sovema2'] = IO.io('http://localhost:5002', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    sockets['sovema3'] = IO.io('http://localhost:5001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Listening for data updates from each socket
    sockets['tbs1']?.on('kpiData', (jsonData) {
            print('tbs 1 Données reçues: $jsonData');

      setState(() {
        dataTbs1 = jsonData;
        if (dataTbs1 != null && dataTbs1!['cad_env'] != null) {
          dataTbs1!['cad_env'] = ((dataTbs1!['cad_env'] as num) / 1000).round();
        }
      });
    });
    // Repeat similarly for sovema2 and sovema3
     sockets['sovema1']?.on('kpiData', (jsonData) {
      print('Sovema 1 Données reçues: $jsonData');
      setState(() {
        dataSovema1 = jsonData;
        // Dividing cad_env by 1000 and rounding the value before displaying it
        if (dataSovema1 != null && dataSovema1!['cad_env'] != null) {
          dataSovema2!['cad_env'] = ((dataSovema1!['cad_env'] as num) / 1000).round();
        }
      });
    });
     sockets['sovema2']?.on('kpiData', (jsonData) {
      print('Sovema 2 Données reçues: $jsonData');
      setState(() {
        dataSovema2 = jsonData;
        // Dividing cad_env by 1000 and rounding the value before displaying it
        if (dataSovema2 != null && dataSovema2!['cad_env'] != null) {
          dataSovema2!['cad_env'] = ((dataSovema2!['cad_env'] as num) / 1000).round();
        }
      });
    });

       // Handle connection errors
    sockets['tbs1']?.on('connect_error', (data) {
      setState(() {
        errorMessage = 'Erreur de connexion à TBS 1';
      });
      print('Erreur de connexion à TBS 1: $data');
    });
    sockets['sovema2']?.on('connect_error', (data) {
      setState(() {
        errorMessage = 'Erreur de connexion à Sovema 1';
      });
      print('Erreur de connexion à Sovema 1: $data');
    });
    sockets['sovema3']?.on('connect_error', (data) {
      setState(() {
        errorMessage = 'Erreur de connexion à Sovema 2';
      });
      print('Erreur de connexion à Sovema 2: $data');
    });
    // Repeat similarly for sovema2 and sovema3
  }*/
