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
                        launchUrl(Uri.parse('https://www.baidu.com'));
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
