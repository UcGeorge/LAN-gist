import 'package:flutter/cupertino.dart';
import 'package:lets_talk/models/message.dart';

class Contact {
  final String address;
  final String name;
  List<Message> messsages = [];
  int unread = 0;

  Contact({
    required this.address,
    required this.name,
  });

  newMessage(Message message) {
    messsages.add(message);
    unread++;
  }

  readMessages() {
    unread = 0;
  }
}

class ContactListModel extends ChangeNotifier {
  List<Contact>? contactList;

  setContacts(String clist) {
    List<String> list = clist.split('+');
    contactList = list
        .map((e) => Contact(
              address: '0.0.0.0',
              name: e.trim(),
            ))
        .toList();
    notifyListeners();
  }

  newMessage(BuildContext context, String contact, Message message) {
    contactList!
        .where((element) => element.name == contact)
        .first
        .newMessage(message);
    notifyListeners();
  }
}
