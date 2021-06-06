import 'package:flutter/cupertino.dart';

class Contact {
  final String address;
  final String name;

  Contact({
    required this.address,
    required this.name,
  });
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
}
