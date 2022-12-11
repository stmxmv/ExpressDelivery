import 'dart:ffi';

import 'package:express_delivery/models/conversation.dart';
import 'package:express_delivery/services/request.dart';
import 'package:image_picker/image_picker.dart';

import '../models/User.dart';
import '../models/message.dart';
import '../services/Storage.dart';
import 'UserServices.dart';

class MessageServices {
  static final MessageServices _messageServices = MessageServices._internal();
  MessageServices._internal();

  factory MessageServices() {
    return _messageServices;
  }

  Future<List<Message>> fetchAllMessage() async {
    try {
      int userId = await UserServices().getUserId();

      var data = {"userId": userId};

      Response response = await Request()
          .get("/express/msg/getAllConversation", queryParameters: data);
      if (response.data["msg"] != null && response.data["code"] == "1111") {
        List<dynamic> messageList = response.data['data']['conversationList'];

        List<Message> messages = [];

        for (var msgJson in messageList) {
          messages.add(Message.fromjson(msgJson));
        }

        return messages;
      }
    } catch (error) {
      print(error);
    }

    return Future.error("获取用户消息发生错误");
  }

  Future<bool> markAllRead() async {
    try {
      int userId = await UserServices().getUserId();

      var data = {"userId": userId};

      Response response = await Request()
          .post("/express/msg/markAllAsRead", queryParameters: data);
      if (response.data["msg"] != null && response.data["code"] == "1111") {
        return true;
      }
    } catch (error) {
      print(error);
    }

    return Future.error("标记信息已阅读出现错误");
  }

  Future<List<ConversationReply>> fetchConversation(int targetId) async {
    try {
      int userId = await UserServices().getUserId();

      var data = {"userId": userId, "targetId": targetId};

      Response response = await Request()
          .get("/express/msg/getConversationDetail", queryParameters: data);
      if (response.data["msg"] != null && response.data["code"] == "1111") {
        List<ConversationReply> replies = [];
        List<dynamic> conversationList = response.data['data']['messageList'];
        for (var json in conversationList) {
          var reply = ConversationReply.fromjson(json);
          // if (reply.type == ReplyType.Text) {
          // if (reply.type == ReplyType.Image) {
          //   reply.imgsrc = reply.imgsrc!.substring(5);
          // }

          replies.add(reply);
          // }
        }

        return replies;
      }
    } catch (error) {
      print(error);
    }

    return Future.error("获取用户消息发生错误");
  }

  Future<bool> sendReply(int receiver, XFile? image, String? text) async {
    try {
      int userId = await UserServices().getUserId();
      Map<String, dynamic> body = {
        "sender": userId,
        "receiver": receiver,
      };
      if (image != null) {
        body["image"] = await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last);
      }
      if (text != null) {
        body['text'] = text;
      }

      Response response = await Request()
          .post("/express/msg/sendMsg", data: FormData.fromMap(body));
      if (response.data["msg"] != null && response.data["code"] == "1111") {
        return true;
      }
    } catch (error) {
      print(error);
    }

    return Future.error("发送消息出现错误");
  }
}
