import 'dart:math';

import 'package:express_delivery/address/choose_address_list.dart';
import 'package:express_delivery/models/address_manager.dart';
import 'package:express_delivery/models/express_station.dart';
import 'package:express_delivery/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_pickers/pickers.dart';

class TaskPublish extends StatefulWidget {
  const TaskPublish({super.key});

  @override
  State<StatefulWidget> createState() => TaskPublishState();
}

class TaskPublishState extends State<TaskPublish> {
  FocusNode bountyFocusNode = FocusNode();

  var bountyTextFieldController = TextEditingController(text: "0.00");

  double? bounty;
  double weight = 0.0;

  TaskValue taskValue = TaskValue.low;

  var chooseAddressList = ChooseAddressList();

  AddressInfo? currentAddressInfo;

  @override
  void initState() {
    AddressManager().getDefaultAddressInfo().then((value) {
      if (mounted) {
        setState(() {
          currentAddressInfo = value;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var node in taskItemCommentFocusNodes) {
      node.dispose();
    }
    for (var controller in taskItemTextEditingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  DateTime finaldate = DateTime.now();

  List<ExpressStation> stations = [
    ExpressStation(0, "深大沧海校区菜鸟驿站", "深大沧海校区"),
    ExpressStation(1, "深大粤海校区菜鸟驿站", "深大粤海校区")
  ];

  ExpressStation station = ExpressStation(0, "深大沧海校区菜鸟驿站", "深大沧海校区");

  TextEditingController commentTextEditingController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  List<FocusNode> taskItemCommentFocusNodes = [FocusNode()];
  List<TextEditingController> taskItemTextEditingControllers = [
    TextEditingController()
  ];

  List<TaskItemInfo> taskItemInfos = [TaskItemInfo("")];

  Widget taskItemInput(int index) {
    assert(index >= 1);

    if (taskItemCommentFocusNodes.length < index + 1) {
      taskItemCommentFocusNodes.add(FocusNode());
      taskItemTextEditingControllers.add(TextEditingController());
    }

    return Slidable(
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              setState(() {
                taskItemInfos.removeAt(index);
                taskItemCommentFocusNodes.removeAt(index);
                taskItemTextEditingControllers.removeAt(index);
              });
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Column(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "快递 ${index + 1}",
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: TextField(
            controller: taskItemTextEditingControllers[index],
            focusNode: taskItemCommentFocusNodes[index],
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            minLines: 2,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '请输入需要代领的快递的基本信息（如货架，取件码等）',
            ),
            onChanged: (value) {
              taskItemInfos[index].description = value;
            },
          ),
        ),
      ]),
    );
  }

  Widget _selectStation() {
    return TextButton(
      onPressed: () {
        Pickers.showSinglePicker(context, data: stations, selectData: station,
            onConfirm: (p, position) {
          setState(() {
            station = p;
          });
        }, onChanged: (p, pos) {});
      },
      child: Text(station.name),
    );
  }

  Widget _selectValue() {
    var values = [
      TaskValue.low.description,
      TaskValue.medium.description,
      TaskValue.high.description
    ];
    return TextButton(
      onPressed: () {
        Pickers.showSinglePicker(context,
            data: values,
            selectData: taskValue.description, onConfirm: (p, position) {
          setState(() {
            if (position == 0) {
              taskValue = TaskValue.low;
            } else if (position == 1) {
              taskValue = TaskValue.medium;
            } else {
              taskValue = TaskValue.high;
            }
          });
        }, onChanged: (p, pos) {});
      },
      child: Text(taskValue.description),
    );
  }

  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: CupertinoDatePicker(
                        initialDateTime: finaldate,
                        onDateTimeChanged: (val) {
                          setState(() {
                            finaldate = val;
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: const Text('确定'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  Widget keyboardDismisser(BuildContext context, Widget child) {
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
    var date = DateFormat('yyyy-MM-dd - kk:mm').format(finaldate);
    return keyboardDismisser(
        context,
        Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text("发布任务"),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Text("发布"),
                  onPressed: () {},
                )
              ],
            ),
            body: Container(
                child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Slidable(
                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                if (taskItemInfos.length > 1) {
                                  setState(() {
                                    taskItemInfos.removeAt(0);
                                    taskItemCommentFocusNodes.removeAt(0);
                                    taskItemTextEditingControllers.removeAt(0);
                                  });
                                }
                              },
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: '删除',
                            ),
                          ],
                        ),

                        // The child of the Slidable is what the user sees when the
                        // component is not dragged.
                        child: Column(children: [
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(left: 15, top: 8),
                                child: Text(
                                  "快递 1",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: TextField(
                              controller: taskItemTextEditingControllers[0],
                              focusNode: taskItemCommentFocusNodes[0],
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                              minLines: 2,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '请输入需要代领的快递的基本信息（如货架，取件码等）',
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Builder(
                        builder: ((context) {
                          if (taskItemInfos.length > 1) {
                            List<Widget> children = [];
                            for (var i = 1; i < taskItemInfos.length; ++i) {
                              children.add(taskItemInput(i));
                            }
                            return Column(
                              children: children,
                            );
                          }
                          return const Center();
                        }),
                      ),
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 8),
                            child: Text(
                              "备注",
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: TextField(
                          controller: commentTextEditingController,
                          focusNode: commentFocusNode,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          minLines: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '备注信息',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CupertinoButton(
                          //   onPressed: () {},
                          //   child: const Text("+ 添加快递图片"),
                          // ),
                          Spacer(),
                          const Text(
                            "¥",
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 30),
                              decoration: null,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                DecimalTextInputFormatter(decimalRange: 2),
                              ],
                              maxLength: 10,
                              controller: bountyTextFieldController,
                              focusNode: bountyFocusNode,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  bounty = double.parse(value);
                                }
                              },
                            ),
                          ),
                          // SizedBox(
                          //   width: 15,
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            onPressed: () {
                              _showDatePicker(context);
                            },
                            child: Text('上门时间 $date',
                                style: const TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Text("驿站地址   "),
                              _selectStation(),
                            ],
                          )),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Text("收件地址   "),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return chooseAddressList;
                                  })).then((value) {
                                    setState(() {
                                      var addressInfo = chooseAddressList
                                          .getSelectedAddress();
                                      if (addressInfo != null) {
                                        currentAddressInfo = addressInfo;
                                      }
                                    });
                                  });
                                },
                                child: currentAddressInfo == null
                                    ? const Text("加载中")
                                    : Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 250),
                                        child: Text(
                                          currentAddressInfo != null
                                              ? "${currentAddressInfo?.name} ${currentAddressInfo?.detail}"
                                              : "不存在地址",
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                        )),
                              )
                            ],
                          )),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Text("珍贵程度   "),
                              _selectValue(),
                            ],
                          )),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Text("重量   "),
                              SizedBox(
                                width: 300,
                                child: CupertinoSpinBox(
                                  suffix: const Text("kg"),
                                  min: 1,
                                  max: double.maxFinite,
                                  value: weight,
                                  onChanged: (value) {
                                    weight = value;
                                  },
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 500,
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 5,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        taskItemInfos.add(TaskItemInfo(""));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.blue, // <-- Button color
                      foregroundColor: Colors.red, // <-- Splash color
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ))));
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

class PrecisionLimitFormatter extends TextInputFormatter {
  int _scale;

  PrecisionLimitFormatter(this._scale);

  RegExp exp = RegExp(r"[0-9]");
  static const String POINTER = ".";
  static const String DOUBLE_ZERO = "00";
  static const String ZERO = "0";

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    print('oldValue:' + oldValue.text);
    print('newValue:' + newValue.text);
    if (newValue.text.startsWith('.')) {
      return TextEditingValue(
          text: '0.', selection: TextSelection.collapsed(offset: 2));
    }

    // if (newValue.text.startsWith(POINTER) && newValue.text.length == 1) {
    //   //第一个不能输入小数点
    //   return oldValue;
    // }

    ///输入完全删除
    if (newValue.text.isEmpty) {
      return TextEditingValue();
    }

    ///只允许输入小数
    if (!exp.hasMatch(newValue.text)) {
      return oldValue;
    }

    if (newValue.text.startsWith(ZERO) &&
        newValue.text.split("0")[1].startsWith(RegExp(r'[0-9]'))) {
      return TextEditingValue(
          text: '0', selection: TextSelection.collapsed(offset: 1));

      // return newValue;
    }

    ///包含小数点的情况
    if (newValue.text.contains(POINTER)) {
      ///包含多个小数
      if (newValue.text.indexOf(POINTER) !=
          newValue.text.lastIndexOf(POINTER)) {
        return oldValue;
      }
      String input = newValue.text;
      int index = input.indexOf(POINTER);

      ///小数点后位数
      int lengthAfterPointer = input.substring(index, input.length).length - 1;

      ///小数位大于精度
      if (lengthAfterPointer > _scale) {
        return oldValue;
      }
    } else if (newValue.text.startsWith(POINTER) ||
        newValue.text.startsWith(DOUBLE_ZERO)) {
      ///不包含小数点,不能以“00”开头
      return oldValue;
    }
    return newValue;
  }
}
