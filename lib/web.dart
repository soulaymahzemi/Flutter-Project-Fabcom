import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MachinesPage extends StatefulWidget {
  @override
  _MachinesPageState createState() => _MachinesPageState();
}

class _MachinesPageState extends State<MachinesPage> {
  String? errorMessage;
  Map<String, IO.Socket?> sockets = {};
  Map<String, dynamic>? dataTbs1;
  Map<String, dynamic>? dataSovema2;
  Map<String, dynamic>? dataSovema3;

  @override
  void initState() {
    super.initState();
    connectSockets();
  }

  void connectSockets() {
    // Connecting to all three Socket.IO instances
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

    // Listen for data from each socket and log it to the console
    sockets['tbs1']?.on('kpiData', (jsonData) {
      print('TBS 1 Données reçues: $jsonData');
      setState(() {
        dataTbs1 = jsonData;
        // Dividing cad_env by 1000 and rounding the value before displaying it
        if (dataTbs1 != null && dataTbs1!['cad_env'] != null) {
          dataTbs1!['cad_env'] = ((dataTbs1!['cad_env'] as num) / 1000).round();
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

    sockets['sovema3']?.on('kpiData', (jsonData) {
      print('Sovema 3 Données reçues: $jsonData');
      setState(() {
        dataSovema3 = jsonData;
        // Dividing cad_env by 1000 and rounding the value before displaying it
        if (dataSovema3 != null && dataSovema3!['cad_env'] != null) {
          dataSovema3!['cad_env'] = ((dataSovema3!['cad_env'] as num) / 1000).round();
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
        errorMessage = 'Erreur de connexion à Sovema 2';
      });
      print('Erreur de connexion à Sovema 2: $data');
    });
    sockets['sovema3']?.on('connect_error', (data) {
      setState(() {
        errorMessage = 'Erreur de connexion à Sovema 3';
      });
      print('Erreur de connexion à Sovema 3: $data');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Données des Machines')),
      body: ListView(
        children: [
          if (dataTbs1 != null)
            ListTile(
              title: Text('TBS 1 - CAD Environment: ${dataTbs1!['cad_env'] ?? 'N/A'}'),
            ),
          if (dataSovema2 != null)
            ListTile(
              title: Text('Sovema 2 - CAD Environment: ${dataSovema2!['cad_env'] ?? 'N/A'}'),
            ),
          if (dataSovema3 != null)
            ListTile(
              title: Text('Sovema 3 - CAD Environment: ${dataSovema3!['cad_env'] ?? 'N/A'}'),
            ),
          if (dataTbs1 == null && dataSovema2 == null && dataSovema3 == null)
            Center(child: Text('Aucune donnée disponible')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Close all sockets when the widget is disposed
    sockets.forEach((key, socket) {
      socket?.dispose();
    });
    super.dispose();
  }
}
 /* Future<void> loadDataFromCacheIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final tbs1Data = prefs.getString('tbs1Data');
    final sovema1Data = prefs.getString('sovema1Data');
    final sovema2Data = prefs.getString('sovema2Data');

    if (tbs1Data != null) {
      setState(() {
        dataTbs1 = json.decode(tbs1Data);
      });
    }
    if (sovema1Data != null) {
      setState(() {
        dataSovema1 = json.decode(sovema1Data);
      });
    }
    if (sovema2Data != null) {
      setState(() {
        dataSovema2 = json.decode(sovema2Data);
      });
    }
  }*/



//socket
/*  void handleSocketData(String socketName, dynamic jsonData) {
    setState(() {
      // Enregistrer les données reçues dans le cache
      if (socketName == 'tbs1') {
        dataTbs1 = jsonData;
        saveDataToCache('tbs1Data',
            dataTbs1); // Enregistrer les données de TBS dans le cache
      } else if (socketName == 'sovema1') {
        dataSovema1 = jsonData;
        saveDataToCache('sovema1Data',
            dataSovema1); // Enregistrer les données de Sovema1 dans le cache
      } else if (socketName == 'sovema2') {
        dataSovema2 = jsonData;
        saveDataToCache('sovema2Data',
            dataSovema2); // Enregistrer les données de Sovema2 dans le cache
      }
    });
  }*/
















/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MachinesPage extends StatefulWidget {
  @override
  _MachinesPageState createState() => _MachinesPageState();
}

class _MachinesPageState extends State<MachinesPage> {
  Map<String, dynamic>? data; // Pour stocker les données de l'API et du socket
  bool isLoading = true;
  String? errorMessage;
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    socket = IO.io('http://localhost:5001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true, // Connecte automatiquement
    });

    socket!.on('kpiData', (jsonData1) {
      setState(() {
        data = jsonData1; // Mettez à jour les données avec les nouvelles données reçues via le socket
        isLoading = false;
      });
      print('Données reçues via Socket.IO: $data');
    });

    socket!.on('connect_error', (data1) {
      setState(() {
        errorMessage = 'Erreur de connexion';
        isLoading = false;
      });
      print('Erreur de connexion : $data1');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Données des Machines')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : data != null
                  ? ListView(
                      children: [
                        // Affichage des données de la machine récupérées via API ou Socket
                        ListTile(
                          title: Text('Données de la machine'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CAD Environment: ${data!['cad_env'] ?? 'N/A'}'),
                              Text('CAD Soud: ${data!['cad_soud'] ?? 'N/A'}'),
                              Text('CAD COS: ${data!['cad_cos'] ?? 'N/A'}'),
                              Text('CAD: ${data!['cad'] ?? 'N/A'}'),
                            ],
                          ),
                        ),
                        Divider(),
                        // Affichage des KPI si disponibles dans les données reçues
                        if (data!.containsKey('TP')) 
                          ListTile(
                            title: Text('KPIs'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TP: ${data!['TP'] ?? 'N/A'}'),
                                Text('TQ: ${data!['TQ'] ?? 'N/A'}'),
                                Text('TRS: ${data!['TRS'] ?? 'N/A'}'),
                                Text('TD: ${data!['TD'] ?? 'N/A'}'),
                                Text('Tr: ${data!['Tr'] ?? 'N/A'}'),
                              ],
                            ),
                          ),
                        Divider(),
                      ],
                    )
                  : Center(child: Text('Aucune donnée disponible')),
    );
  }

  @override
  void dispose() {
    socket?.dispose(); // Ferme la connexion Socket.IO lorsque le widget est supprimé
    super.dispose();
  }
}
*/