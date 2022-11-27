import 'dart:io';

import 'package:express_delivery/services/screenAdapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class PostmanRegisterPage extends StatefulWidget {
  const PostmanRegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _PostmanRegisterPageState();
}

class _PostmanRegisterPageState extends State<PostmanRegisterPage> {
  XFile? idCardFrontImage;
  XFile? idCardBackImage;

  var phoneTextEditingController = TextEditingController();
  var phoneTextFieldFocusNode = FocusNode();

  void _getUserUploadImage(
      BuildContext context, void Function(XFile? image) completionHandler) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('上传'),
        message: null,
        actions: [
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text.
            isDefaultAction: true,
            isDestructiveAction: false,
            onPressed: () async {
              Navigator.pop(context);
              completionHandler(
                  await ImagePicker().pickImage(source: ImageSource.camera));
            },
            child: const Text('拍照'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              completionHandler(
                  await ImagePicker().pickImage(source: ImageSource.gallery));
            },
            child: const Text('相册'),
          ),
        ],
      ),
    );
  }

  Widget _keyboardDismisser(BuildContext context, Widget child) {
    final gesture = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: child,
    );
    return gesture;
  }

  void showAgreeMentAlertDialog(BuildContext context) {
    // set up the buttons

    Widget continueButton = TextButton(
      child: const Text("确定"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("平台协议"),
      content: const SingleChildScrollView(
        child: Text(
            "各效劳条款前所列索引关键词仅为协助您了解该条款表达的宗旨之用，不影响或限制本协议条款的含义或解释。为维护您本身权益，倡议您认真阅读各条款详细表述。 【审慎阅读】您在申请注册流程中点击同意本协议之前，应当认真阅读本协议。请您务必审慎阅读、充沛了解各条款内容，特别是免除或者限制义务的条款、法律适用和争议处理条款。免除或者限制义务的条款将以粗体下划线标识，您应重点阅读。如您对协议有任何疑问，可向快递代拿平台客服咨询。"),
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _keyboardDismisser(
        context,
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("快递员注册"),
            centerTitle: true,
          ),
          body: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.05),
              child: Container(
                margin: EdgeInsets.all(ScreenAdapter().width(20)),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _getUserUploadImage(context, (image) {
                          setState(() {
                            idCardFrontImage = image;
                          });
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: ScreenAdapter().height(150),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: idCardFrontImage != null
                            ? Image.file(
                                File(idCardFrontImage!.path),
                                fit: BoxFit.cover,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    const Icon(Icons.camera_alt),
                                    SizedBox(
                                      width: ScreenAdapter().width(10),
                                    ),
                                    const Text("上传身份证正面")
                                  ]),
                      ),
                    ),
                    SizedBox(
                      height: ScreenAdapter().height(50),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _getUserUploadImage(context, (image) {
                          setState(() {
                            idCardBackImage = image;
                          });
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: ScreenAdapter().height(150),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: idCardBackImage != null
                            ? Image.file(
                                File(idCardBackImage!.path),
                                fit: BoxFit.cover,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    const Icon(Icons.camera_alt),
                                    SizedBox(
                                      width: ScreenAdapter().width(10),
                                    ),
                                    const Text("上传身份证反面")
                                  ]),
                      ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(top: ScreenAdapter().height(50)),
                        child: Row(
                          children: [
                            const Text("手机号"),
                            const Spacer(),
                            SizedBox(
                              width: ScreenAdapter().width(270),
                              child: CupertinoTextField(
                                controller: phoneTextEditingController,
                                focusNode: phoneTextFieldFocusNode,
                                keyboardType: TextInputType.phone,
                                maxLines: 1,
                                minLines: 1,
                                placeholder: "输入手机号",
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: ScreenAdapter().height(10),
                    ),
                    GestureDetector(
                      onTap: () {
                        // launchUrl(Uri.parse('https://www.baidu.com'));
                        showAgreeMentAlertDialog(context);
                      },
                      child: const Text(
                        "阅读代拿人员协议",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: Container(
                        width: ScreenAdapter().width(200),
                        height: ScreenAdapter().height(50),
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Ink(
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: const Center(
                                    child: Text(
                                  '同意协议并申请认证',
                                  style: TextStyle(color: Colors.white),
                                ))),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
