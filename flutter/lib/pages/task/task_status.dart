import 'package:express_delivery/models/postman.dart';
import 'package:express_delivery/models/task_state_model.dart';
import 'package:express_delivery/pages/task/postman_complete_task.dart';
import 'package:express_delivery/services/UserServices.dart';
import 'package:express_delivery/services/screenAdapter.dart';
import 'package:express_delivery/services/task_service.dart';
import 'package:express_delivery/widgets/ANButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/User.dart';
import '../../models/task.dart';

enum TaskStatusPageType { User, Postman }

class TaskStatusPage extends StatefulWidget {
  final TaskStatusPageType statusType;
  const TaskStatusPage({super.key, required this.statusType});

  @override
  State<StatefulWidget> createState() => TaskStatusPageState();
}

class TaskStatusTile extends StatefulWidget {
  final Task task;
  final TaskStatusPageType statusType;
  const TaskStatusTile(
      {super.key, required this.task, required this.statusType});

  @override
  State<StatefulWidget> createState() => TaskStatusTileState();
}

class TaskStatusTileState extends State<TaskStatusTile> {
  late Future<Postman> postmanInfo;

  void showFinishConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("取消"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("是的"),
      onPressed: () {
        Navigator.of(context).pop();

        if (widget.statusType == TaskStatusPageType.User) {
          var taskStateModel =
              Provider.of<TaskStateModel>(context, listen: false);
          () async {
            await TaskService().userConfirmFinishTask(widget.task.id);
            taskStateModel.refresh();
          }();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("温馨提示"),
      content: const Text("你确定有收到快递吗？"),
      actions: [
        cancelButton,
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
  void initState() {
    super.initState();
    if (widget.task.state == TaskState.accepted &&
        widget.task.postmanId != null) {
      postmanInfo = UserServices().getPostmanById(widget.task.postmanId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(ScreenAdapter().width(10)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
            margin: EdgeInsets.all(ScreenAdapter().width(10)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.task,
                        size: ScreenAdapter().width(30),
                      ),
                      SizedBox(
                        width: ScreenAdapter().width(10),
                      ),
                      Text("任务 ID: ${widget.task.id}"),
                    ],
                  ),
                  SizedBox(
                    height: ScreenAdapter().height(10),
                  ),
                  Text(
                    '创建时间: ${DateFormat('yyyy-MM-dd - kk:mm').format(widget.task.createTime)}',
                    softWrap: true,
                    style: const TextStyle(color: Colors.black45),
                  ),
                  if (widget.task.state == TaskState.complete &&
                      widget.task.completeTime != null)
                    Text(
                      '完成时间: ${DateFormat('yyyy-MM-dd - kk:mm').format(widget.task.completeTime!)}',
                      softWrap: true,
                      style: const TextStyle(color: Colors.black45),
                    ),
                  Builder(builder: (context) {
                    if (widget.statusType == TaskStatusPageType.User &&
                        widget.task.state == TaskState.accepted &&
                        widget.task.postmanId != null) {
                      return FutureBuilder(
                          future: postmanInfo,
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              Postman postman = snapshot.data!;
                              return Text("代拿员联系电话 ${postman.phone}");
                            } else if (snapshot.hasError) {}
                            return const SizedBox.shrink();
                          }));
                    }

                    return const SizedBox.shrink();
                  }),
                  Text(
                    "状态: ${widget.task.state.description}",
                    style: const TextStyle(color: Colors.black45),
                  ),
                  if (widget.task.state == TaskState.accepted)
                    Row(
                      children: [
                        const Spacer(),
                        Material(
                          child: Container(
                            width: ScreenAdapter().width(90),
                            height: ScreenAdapter().height(30),
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.redAccent),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: Center(
                                    child: Text(
                                  widget.statusType == TaskStatusPageType.User
                                      ? "确认收货"
                                      : "确认完成",
                                  style: TextStyle(color: Colors.redAccent),
                                )),
                              ),
                              onTap: () {
                                if (widget.statusType ==
                                    TaskStatusPageType.User) {
                                  showFinishConfirmDialog(context);
                                } else {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: ((context) {
                                    return PostmanCompleteTask(
                                      task: widget.task,
                                    );
                                  }))).then((value) {
                                    Provider.of<TaskStateModel>(context,
                                            listen: false)
                                        .refresh();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (widget.task.state == TaskState.pending)
                    Row(
                      children: [
                        const Spacer(),
                        Material(
                          child: Container(
                            width: ScreenAdapter().width(90),
                            height: ScreenAdapter().height(30),
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.pinkAccent),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: const Center(
                                    child: Text(
                                  '取消任务',
                                  style: TextStyle(color: Colors.pinkAccent),
                                )),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (widget.task.state == TaskState.complete)
                    Row(
                      children: [
                        const Spacer(),
                        Material(
                          child: Container(
                            width: ScreenAdapter().width(90),
                            height: ScreenAdapter().height(30),
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.redAccent),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: const Center(
                                    child: Text(
                                  '评价',
                                  style: TextStyle(color: Colors.redAccent),
                                )),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    )
                ])),
      ),
    );
  }
}

class TaskStatusPageState extends State<TaskStatusPage> {
  // data

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: widget.statusType == TaskStatusPageType.User
                    ? "进行中"
                    : "已接受",
              ),
              const Tab(
                text: "已完成",
              ),
            ],
          ),
          title: const Text('任务状态'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.05)),
              child: FutureBuilder(
                  future: widget.statusType == TaskStatusPageType.User
                      ? Provider.of<TaskStateModel>(context, listen: true)
                          .userTasks
                      : Provider.of<TaskStateModel>(context, listen: true)
                          .postmanTasks,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      List<Task> tasks = snapshot.data!;
                      return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: ((context, index) {
                            return TaskStatusTile(
                              task: tasks[index],
                              statusType: widget.statusType,
                            );
                          }));
                    }
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  })),
            ),
            Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.05)),
              child: FutureBuilder(
                future: widget.statusType == TaskStatusPageType.User
                    ? Provider.of<TaskStateModel>(context, listen: true)
                        .userCompleteTasks
                    : Provider.of<TaskStateModel>(context, listen: true)
                        .postmanCompleteTasks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Task> completeTasks = snapshot.data!;
                    return ListView.builder(
                        itemCount: completeTasks.length,
                        itemBuilder: ((context, index) {
                          return TaskStatusTile(
                            task: completeTasks[index],
                            statusType: widget.statusType,
                          );
                        }));
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error!.toString()),
                    );
                  }

                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
