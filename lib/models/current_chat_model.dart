import 'package:flutter/cupertino.dart';

import 'contact.dart';

class CurrentChatModel extends ChangeNotifier {
  Contact? selected;

  void selectContact(Contact contact) {
    selected = contact;
    print('Selected: ${contact.name}');
    notifyListeners();
  }
}
