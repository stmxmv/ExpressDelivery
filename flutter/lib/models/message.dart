//定义消息对象，包含用户名，头像，以及最近一条消息。
class Message {
  int targetId;
  String targetName;
  String imageUrl;
  String firstMessage;
  int unreadCount;
  Message(
      {required this.targetId,
      required this.targetName,
      required this.imageUrl,
      required this.firstMessage,
      required this.unreadCount});

  factory Message.fromjson(Map<String, dynamic> json) {
    return Message(
        targetId: json['targetId'],
        targetName: json['targetName'],
        imageUrl:
            "https://img-blog.csdnimg.cn/20201014180756724.png?x-oss-process=image/resize,m_fixed,h_64,w_64",
        firstMessage: json['lastMessage'],
        unreadCount: json['nonReadNum']);
  }
}
