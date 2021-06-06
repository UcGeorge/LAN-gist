import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:lets_talk/models/contact.dart';
import 'package:provider/provider.dart';

class Client extends ChangeNotifier {
  bool connected = false;
  String? errorMessage;
  bool connecting = false;
  String? name;

  connect(BuildContext context, String name, String addr) async {
    this.name = name;
    // connect to the socket server
    try {
      connecting = true;
      notifyListeners();
      final socket = await Socket.connect(addr, 1234);
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      connected = true;
      connecting = false;
      notifyListeners();

      await sendMessage(
        socket,
        message: name,
        receiver: 'Admin',
      );

      // listen for responses from the server
      socket.listen(
        // handle data from the server
        (Uint8List data) {
          final serverResponse = String.fromCharCodes(data);
          print('Server: $serverResponse');

          String sender = serverResponse.split('~')[0];
          String message = serverResponse.split('~')[1];

          switch (sender) {
            case 'Contacts':
              context.read<ContactListModel>().setContacts(message);
              break;
            default:
              break;
          }
        },

        // handle errors
        onError: (error) {
          print(error);
          socket.destroy();
          errorMessage = error;
          connected = false;
          connecting = false;
          notifyListeners();
        },

        // handle server ending connection
        onDone: () {
          print('Lost connection to server.');
          socket.destroy();
          errorMessage = 'Lost connection to server.';
          connected = false;
          connecting = false;
          notifyListeners();
        },
      );
    } catch (e) {
      errorMessage = e.toString();
      connected = false;
      connecting = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(Socket socket,
      {required String message, String? receiver}) async {
    print('Client: ' + (receiver == null ? message : '$receiver~$message'));
    socket.writeln(receiver == null ? message : '$receiver~$message');
  }
}
