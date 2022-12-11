import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:express_delivery/models/conversation.dart';
import 'package:express_delivery/services/message_services.dart';
import 'package:express_delivery/services/request.dart';
import 'package:express_delivery/services/screenAdapter.dart';
import 'package:express_delivery/widgets/photo_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class OverdueUrgeReplyPage extends StatefulWidget {
  final int targetId;

  const OverdueUrgeReplyPage({
    super.key,
    required this.targetId,
  });

  State<OverdueUrgeReplyPage> createState() => _OverdueUrgeReplyPageState();
}

class _OverdueUrgeReplyPageState extends State<OverdueUrgeReplyPage> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  double contentMaxWidth = 0;

  bool showAddContext = false;

  List<ConversationReply> replies = [];
  late int userId;
  late int targetId;
  late String userName;
  late String targetName;

  late Timer timer;
  // int employeeNo = 0;

  // List list = [
  //   {
  //     "createdAt": DateTime(2022, 12, 1, 6, 23),
  //     "employeeNo": 0,
  //     "name": "name1",
  //     "reply":
  //         "come text 1 bra bra bra bra bra brabra bra bravvvvv bra bra brabra bra brabra bra brabra bra brabra bra brabra bra brabra bra brabra bra bra",
  //     "status": 2,
  //   },
  //   {
  //     "createdAt": DateTime(2022, 12, 2, 6, 23),
  //     "employeeNo": 1,
  //     "name": "name2",
  //     "reply": "come text 2 bra bra bra",
  //     "status": 2,
  //   },
  //   {
  //     "createdAt": DateTime(2022, 12, 2, 6, 23),
  //     "employeeNo": 0,
  //     "name": "name2",
  //     "reply": "come text 2 bra bra bra",
  //     "status": 2,
  //   },
  //   {
  //     "createdAt": DateTime(2022, 12, 2, 6, 23),
  //     "employeeNo": 0,
  //     "name": "name2",
  //     "reply": "come text 2 bra bra bra",
  //     "status": 2,
  //   },
  //   {
  //     "createdAt": DateTime(2022, 12, 2, 6, 23),
  //     "employeeNo": 1,
  //     "name": "name2",
  //     "reply": "come text 2 bra bra bra",
  //     "status": 2,
  //   }
  // ]; //列表要展示的数据

  @override
  void initState() {
    super.initState();
    initData();

    KeyboardVisibilityController().onChange.listen((isKeyboardVisible) {
      if (mounted && isKeyboardVisible) {
        setState(() {
          showAddContext = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  initData() async {
    // employeeNo = await LocalStorage.get('employeeNo');
    // userId = await LocalStorage.get('userId');
    // userName = await LocalStorage.get('name');
    // String url =
    //     '${Address.getPrefix()}hbpay/overdue/urge/getOverdueUrgeReplyList';
    // var res = await httpManager.netFetch(url,
    //     queryParameters: {'orderNo': widget.orderNo},
    //     options: Options(method: 'post'),
    //     showLoadingForPost: false);
    // setState(() {
    //   if (res.data == null || res.data.length == 0) {
    //     return;
    //   }
    //   list = (res.data as List).reversed.toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    contentMaxWidth = MediaQuery.of(context).size.width - 90;
    return ChangeNotifierProvider(
      create: ((context) {
        final model = ConversationReplyModel(targetId: widget.targetId);
        model.refresh();
        return model;
      }),
      builder: (context, child) {
        ConversationReplyModel model = context.watch<ConversationReplyModel>();
        replies = model.replies;
        userId = model.userId;
        targetId = model.targetId;
        userName = model.userName;
        targetName = model.targetName;

        timer = Timer(const Duration(seconds: 5), () {
          model.refresh();
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(targetName),
            centerTitle: true,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFF1F5FB),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    //列表内容少的时候靠上
                    alignment: Alignment.topCenter,
                    child: _renderList(context),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: ScreenAdapter().width(7),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(Icons.add_outlined),
                        onTap: () {
                          setState(() {
                            showAddContext = !showAddContext;
                            if (showAddContext) {
                              if (KeyboardVisibilityController().isVisible) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              ScreenAdapter().width(7),
                              ScreenAdapter().height(7),
                              0,
                              ScreenAdapter().height(7)),
                          constraints: BoxConstraints(
                            maxHeight: ScreenAdapter().height(100.0),
                          ),
                          decoration: const BoxDecoration(
                              color: Color(0xFFF5F6FF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          child: CupertinoTextField(
                            controller: textEditingController,
                            cursorColor: const Color(0xFF464EB5),
                            maxLines: null,
                            maxLength: 200,
                            placeholder: "回复",
                            placeholderStyle: const TextStyle(
                                color: Color(0xFFADB3BA), fontSize: 15),
                            padding: EdgeInsets.only(
                                left: ScreenAdapter().width(16.0),
                                right: ScreenAdapter().width(16.0),
                                top: ScreenAdapter().height(10.0),
                                bottom: ScreenAdapter().height(10.0)),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.01)),
                            style: const TextStyle(
                                color: Color(0xFF03073C), fontSize: 15),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          alignment: Alignment.center,
                          child: const Text(
                            '发送',
                            style: TextStyle(
                              color: Color(0xFF464EB5),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onTap: () {
                          sendTxt();
                        },
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  height: showAddContext ? ScreenAdapter().height(200) : 0,
                  child: SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.all(ScreenAdapter().width(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: ScreenAdapter().width(60),
                                          height: ScreenAdapter().width(60),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: EdgeInsets.all(
                                              ScreenAdapter().width(10)),
                                          child: Icon(Icons.camera),
                                        ),
                                        Text(
                                          "照片",
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenAdapter().size(10)),
                                        )
                                      ],
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              )
                            ],
                          ))),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderList(BuildContext context) {
    return GestureDetector(
      child: ListView.builder(
        reverse: true,
        // shrinkWrap: true,
        padding: const EdgeInsets.only(top: 27),
        itemCount: replies.length,
        itemBuilder: (context, index) {
          var item = replies[index];
          return GestureDetector(
            child: item.sender == userId
                ? _renderRowSendByMe(context, item, index)
                : _renderRowSendByOthers(context, item, index),
            onTap: () {},
          );
        },
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
      ),
      onTap: () {
        showAddContext = false;
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  void onTapImage(int index) {
    List<String> imageUrls = [];
    int imageIndex = index;
    for (var i = 0; i < replies.length; i++) {
      if (replies[i].type == ReplyType.Image) {
        imageUrls.add(Request().serverAddress + replies[i].imgsrc!);
      } else {
        if (index > i) {
          --imageIndex;
        }
      }
    }

    Navigator.push(context, MaterialPageRoute(builder: ((context) {
      return PhotoPreview(
        galleryItems: imageUrls,
        defaultImage: imageIndex,
        onTap: () {
          Navigator.pop(context);
        },
      );
    })));
  }

  Widget _renderRowSendByOthers(
      BuildContext context, ConversationReply item, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              DateFormat('yyyy-MM-dd - kk:mm').format(item.sendTime),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFA1A6BB),
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 45),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      color: Color(0xFF464EB5),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      targetName.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 30),
                        child: Text(
                          targetName,
                          softWrap: true,
                          style: const TextStyle(
                            color: Color(0xFF677092),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.fromLTRB(2, 16, 0, 0),
                            child: const Image(
                                width: 11,
                                height: 20,
                                image: AssetImage(
                                    "assets/images/chat_white_arrow.png")),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(4.0, 7.0),
                                    color: Color(0x04000000),
                                    blurRadius: 10,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: const EdgeInsets.only(top: 8, left: 10),
                            padding: item.type == ReplyType.Text
                                ? const EdgeInsets.all(10)
                                : const EdgeInsets.all(5),
                            child: item.type == ReplyType.Text
                                ? Text(
                                    item.text!,
                                    style: const TextStyle(
                                      color: Color(0xFF03073C),
                                      fontSize: 15,
                                    ),
                                  )
                                : GestureDetector(
                                    child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                ScreenAdapter().width(100)),
                                        child: CachedNetworkImage(
                                          imageUrl: Request().serverAddress +
                                              item.imgsrc!,
                                          placeholder: (context, url) => SizedBox(
                                              width: ScreenAdapter().width(50),
                                              height: ScreenAdapter().width(50),
                                              child:
                                                  const CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )),
                                    onTap: () {
                                      onTapImage(index);
                                    }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderRowSendByMe(
      BuildContext context, ConversationReply item, index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              DateFormat('yyyy-MM-dd - kk:mm').format(item.sendTime),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFA1A6BB),
                fontSize: 14,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: ui.TextDirection.rtl,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: Color(0xFF464EB5),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    userName.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      userName,
                      softWrap: true,
                      style: const TextStyle(
                        color: Color(0xFF677092),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 2, 0),
                        child: const Image(
                            width: 11,
                            height: 20,
                            image: AssetImage(
                                "assets/images/chat_purple_arrow.png")),
                      ),
                      Row(
                        textDirection: ui.TextDirection.rtl,
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: contentMaxWidth,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, right: 10),
                              decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(4.0, 7.0),
                                      color: Color(0x04000000),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  color: Color(0xFF838CFF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: item.type == ReplyType.Text
                                  ? const EdgeInsets.all(10)
                                  : const EdgeInsets.all(5),
                              child: item.type == ReplyType.Text
                                  ? Text(
                                      item.text!,
                                      softWrap: true,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    )
                                  : GestureDetector(
                                      child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth:
                                                  ScreenAdapter().width(100)),
                                          child: CachedNetworkImage(
                                            imageUrl: Request().serverAddress +
                                                item.imgsrc!,
                                            placeholder: (context, url) => SizedBox(
                                                width:
                                                    ScreenAdapter().width(50),
                                                height:
                                                    ScreenAdapter().width(50),
                                                child:
                                                    const CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )),
                                      onTap: () {
                                        onTapImage(index);
                                      },
                                    ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                              child: item.read
                                  ? ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          maxWidth: 10, maxHeight: 10),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey),
                                        ),
                                      ),
                                    )
                                  : Container()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  final int maxValue = 1 << 32;

  void sendTxt() async {
    int tag = random.nextInt(maxValue);

    if (textEditingController.value.text.trim().isEmpty) {
      return;
    }

    String message = textEditingController.value.text;
    addMessage(message, tag);

    try {
      await MessageServices().sendReply(targetId, null, message);
    } catch (error) {
      print(error);
    }

    // textEditingController.text = '';

    // String url = '${Address.getPrefix()}hbpay/overdue/urge/saveReply';
    // var res = await httpManager.netFetch(url,
    //     data: {
    //       'cusUid': userId,
    //       'orderNo': widget.orderNo,
    //       'employeeNo': employeeNo,
    //       'name': userName,
    //       'reply': message,
    //       'tag': '${tag}',
    //     },
    //     options: Options(method: 'post'),
    //     showLoadingForPost: false);

    // int index = 0;
    // if (res.result) {
    //   for(int i = 0; index < list.length; i++) {
    //     if (list[i]['tag'] == res.data) {
    //       index = i;
    //       break;
    //     }
    //   }
    //   setState(() {
    //     list[index]['status'] = SUCCESSED_TYPE;
    //   });
    // } else {
    //   setState(() {
    //     list[index]['status'] = FAILED_TYPE;
    //   });
    // }
  }

  final random = Random();

  void addMessage(content, tag) {
    setState(() {
      DateTime now = DateTime.now();
      replies.insert(
          0,
          ConversationReply(
              sender: userId,
              type: ReplyType.Text,
              text: content,
              imgsrc: null,
              read: true,
              sendTime: now));
    });

    Timer(Duration(milliseconds: 100), () => _scrollController.jumpTo(0));
  }

  static int SENDING_TYPE = 0;
  static int FAILED_TYPE = 1;
  static int SUCCESSED_TYPE = 2;
}
