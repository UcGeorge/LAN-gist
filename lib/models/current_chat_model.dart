import 'package:flutter/cupertino.dart';
import 'package:lets_talk/data/data.dart';

class CurrentChatModel extends ChangeNotifier {
  Contact? selected;

  void selectContact(Contact contact) {
    selected = contact;
    print('Selected: ${contact.name}');
    notifyListeners();
  }
}
