import 'package:express_delivery/services/UserServices.dart';
import 'package:express_delivery/services/message_services.dart';
import 'package:flutter/material.dart';

enum ReplyType { Text, Image }

class ConversationReply {
  int sender;
  ReplyType type;
  String? text;
  String? imgsrc;
  bool read;
  DateTime sendTime;

  ConversationReply(
      {required this.sender,
      required this.type,
      required this.text,
      required this.imgsrc,
      required this.read,
      required this.sendTime});

  factory ConversationReply.fromjson(Map<String, dynamic> json) {
    return ConversationReply(
        sender: json['sender'],
        type: ReplyType.values[json['type']],
        text: json['text'],
        imgsrc: json['imgsrc'],
        read: json['read'],
        sendTime: DateTime.parse(json['sendTime']));
  }
}

class ConversationReplyModel extends ChangeNotifier {
  int targetId;
  int userId = -1;
  String userName = "";
  String targetName = "";
  List<ConversationReply> replies = [];
  ConversationReplyModel({required this.targetId});

  Future<void> refresh() async {
    try {
      List<ConversationReply> newReplies =
          await MessageServices().fetchConversation(targetId);
      userId = await UserServices().getUserId();
      replies = newReplies;
      final userInfo = await UserServices().getUserInfo();
      userName = userInfo.username;
      final targetUserInfo = await UserServices().getUserInfoById(targetId);
      targetName = targetUserInfo.username;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
