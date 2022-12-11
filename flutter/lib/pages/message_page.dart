import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../models/message_model.dart';
import 'message/message_reply_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  /// test data
  // List<Message> _message = [
  //   Message(
  //       targetId: 0,
  //       targetName: "快递员1",
  //       imageUrl:
  //           "https://img-blog.csdnimg.cn/20201014180756724.png?x-oss-process=image/resize,m_fixed,h_64,w_64",
  //       firstMessage: "已接受快递",
  //       unreadCount: 2),
  //   Message(
  //       targetId: 0,
  //       targetName: "快递员2",
  //       imageUrl:
  //           "https://img-blog.csdnimg.cn/20201014180756724.png?x-oss-process=image/resize,m_fixed,h_64,w_64",
  //       firstMessage: "已完成快递",
  //       unreadCount: 3),
  //   Message(
  //       targetId: 0,
  //       targetName: "快递员3",
  //       imageUrl:
  //           "https://img-blog.csdnimg.cn/20201014180756724.png?x-oss-process=image/resize,m_fixed,h_64,w_64",
  //       firstMessage: "已完成快递 bra bra",
  //       unreadCount: 0)
  // ];

  @override
  void initState() {
    super.initState();
    Provider.of<MessageModel>(context, listen: false).refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<MessageModel>().messages.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("消息"),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 100,
            icon: const Text("全部标记已读"),
            onPressed: () async {
              await context.read<MessageModel>().markAllRead();
              setState(() {});
            },
          )
        ],
      ),
      body: Container(
        child: Column(children: [
          Expanded(
              child: ListView.separated(
            itemCount: context.watch<MessageModel>().messages.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.black12,
                height: 1.0,
                indent: 18,
              );
            },
            itemBuilder: (context, index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: EachItem(context.watch<MessageModel>().messages[index]),
                onTap: () {
                  final model = context.read<MessageModel>();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return OverdueUrgeReplyPage(
                      targetId: model.messages[index].targetId,
                    );
                  })).then((value) {
                    Provider.of<MessageModel>(context, listen: false).refresh();
                  });
                }), //调用函数构造每一行的内容
          ))
        ]),
      ),
    );
  }
}

//构造每一行的内容的类
class EachItem extends StatelessWidget {
  final Message message;
  const EachItem(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 14.0, right: 14.0),
                child: Badge(
                  showBadge: message.unreadCount > 0,
                  badgeContent: Text(
                    '${message.unreadCount}',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(message.imageUrl),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(message.targetName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17.0)),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          message.firstMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ]),
              ),
            ]));
  }
}
