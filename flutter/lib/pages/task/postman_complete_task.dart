import 'dart:io';
import 'package:express_delivery/services/task_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/task.dart';
import '../../services/screenAdapter.dart';

class PostmanCompleteTask extends StatefulWidget {
  final Task task;
  const PostmanCompleteTask({super.key, required this.task});

  @override
  State<PostmanCompleteTask> createState() => _PostmanCompleteTaskState();
}

class _PostmanCompleteTaskState extends State<PostmanCompleteTask> {
  XFile? image;
  // XFile? idCardBackImage;

  bool isKeyboardVisible = false;

  var phoneTextEditingController = TextEditingController();
  var phoneTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((isKeyboardVisible) {
      if (mounted) {
        setState(() {
          this.isKeyboardVisible = isKeyboardVisible;
        });
      }
    });
  }

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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("上传图片和信息"),
            centerTitle: true,
          ),
          body: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.05),
              child: Container(
                margin: EdgeInsets.all(ScreenAdapter().width(20)),
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  ListView(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          _getUserUploadImage(context, (image) {
                            setState(() {
                              this.image = image;
                            });
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: ScreenAdapter().height(150),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: image != null
                              ? Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      const Icon(Icons.camera_alt),
                                      SizedBox(
                                        width: ScreenAdapter().width(10),
                                      ),
                                      const Text("上传快递图片")
                                    ]),
                        ),
                      ),
                      SizedBox(
                        height: ScreenAdapter().height(50),
                      ),
                      Container(
                          padding:
                              EdgeInsets.only(top: ScreenAdapter().height(50)),
                          child: Column(
                            children: [
                              const Text("备注"),
                              SizedBox(
                                height: ScreenAdapter().height(10),
                              ),
                              SizedBox(
                                height: ScreenAdapter().height(100),
                                width: ScreenAdapter().width(350),
                                child: CupertinoTextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  controller: phoneTextEditingController,
                                  focusNode: phoneTextFieldFocusNode,
                                  keyboardType: TextInputType.text,
                                  maxLines: 10,
                                  minLines: 1,
                                  placeholder: "输入备注信息",
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: ScreenAdapter().height(10),
                      ),
                    ],
                  ),
                  if (!isKeyboardVisible)
                    Positioned(
                      bottom: ScreenAdapter().height(20),
                      child: Material(
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: const Center(
                                      child: Text(
                                    '确认',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                            ),
                            onTap: () async {
                              bool result = await TaskService()
                                  .postmanRequestFinishTask(widget.task.id,
                                      image, phoneTextEditingController.text);
                              if (mounted && result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('已发送')));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ),
                    )
                ]),
              )),
        ));
  }
}
