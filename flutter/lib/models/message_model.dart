import 'package:express_delivery/services/message_services.dart';
import 'package:flutter/cupertino.dart';

import 'message.dart';

class MessageModel extends ChangeNotifier {
  List<Message> messages = [];

  MessageModel() {
    refresh();
  }

  Future<void> refresh() async {
    try {
      List<Message> newMessages = await MessageServices().fetchAllMessage();
      messages = newMessages;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> markAllRead() async {
    try {
      await MessageServices().markAllRead();
      await refresh();
    } catch (error) {
      print(error);
    }
  }

  int get unreadCount {
    int count = 0;
    for (var msg in messages) {
      count += msg.unreadCount;
    }
    return count;
  }
}
