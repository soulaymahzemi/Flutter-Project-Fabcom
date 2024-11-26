// socket_manager.dart

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  final Map<String, IO.Socket> sockets = {};
  Function(String, dynamic)? onDataReceived;

  SocketManager({this.onDataReceived});

  void connectSockets() {
    // Initialize and connect to each socket instance
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

    // Listen for 'kpiData' events
    sockets.forEach((key, socket) {
      socket.on('kpiData', (jsonData) {
        onDataReceived?.call(key, jsonData);
      });
    });
  }

  void dispose() {
    sockets.forEach((key, socket) => socket.dispose());
  }
}
