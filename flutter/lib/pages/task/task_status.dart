import 'package:express_delivery/services/UserServices.dart';
import 'package:express_delivery/services/screenAdapter.dart';
import 'package:express_delivery/widgets/ANButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/User.dart';
import '../../models/task.dart';

class TaskStatus extends StatefulWidget {
  const TaskStatus({super.key});

  @override
  State<StatefulWidget> createState() => TaskStatusState();
}

class TaskStatusTile extends StatefulWidget {
  final Task task;
  const TaskStatusTile({super.key, required this.task});

  @override
  State<StatefulWidget> createState() => TaskStatusTileState();
}

class TaskStatusTileState extends State<TaskStatusTile> {
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
                  Builder(builder: (context) {
                    if (widget.task.state == TaskState.accepted &&
                        widget.task.postmanId != null) {
                      return FutureBuilder(
                          future: UserServices()
                              .getPostmanById(widget.task.postmanId!),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              User postman = snapshot.data!;
                              return Text("代拿员联系电话 ${postman.phone}");
                            }
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
                                child: const Center(
                                    child: Text(
                                  '确认收货',
                                  style: TextStyle(color: Colors.redAccent),
                                )),
                              ),
                              onTap: () {},
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

class TaskStatusState extends State<TaskStatus> {
  // test data
  static final List<Task> testTasksData = [
    Task(
        id: 123,
        userId: 3,
        expressNum: 2,
        weight: 20,
        reward: 16.3,
        address: "深圳大学冬筑1428",
        doorTime: DateTime.now(),
        createTime: DateTime.now(),
        comment: "一些备注",
        taskValue: TaskValue.high,
        state: TaskState.pending),
    Task(
        id: 124,
        userId: 2,
        expressNum: 2,
        weight: 20,
        reward: 14.3,
        address: "深圳大学冬筑1428",
        doorTime: DateTime.now(),
        createTime: DateTime.now(),
        comment: "一些备注",
        taskValue: TaskValue.high,
        state: TaskState.pending),
    Task(
        id: 125,
        userId: 6,
        postmanId: 7,
        expressNum: 2,
        weight: 20,
        reward: 12.3,
        address: "深圳大学冬筑1428",
        doorTime: DateTime.now(),
        createTime: DateTime.now(),
        comment: "一些备注",
        taskValue: TaskValue.high,
        state: TaskState.accepted),
  ];

  static final List<Task> testFinishedTasksData = [
    Task(
        id: 123,
        userId: 3,
        expressNum: 2,
        weight: 20,
        reward: 16.3,
        address: "深圳大学冬筑1428",
        doorTime: DateTime.now(),
        createTime: DateTime.now(),
        comment: "一些备注",
        taskValue: TaskValue.high,
        state: TaskState.complete),
    Task(
        id: 124,
        userId: 2,
        expressNum: 2,
        weight: 20,
        reward: 14.3,
        address: "深圳大学冬筑1428",
        doorTime: DateTime.now(),
        createTime: DateTime.now(),
        comment: "一些备注",
        taskValue: TaskValue.high,
        state: TaskState.complete),
    Task(
        id: 125,
        userId: 6,
        postmanId: 7,
        expressNum: 2,
        weight: 20,
        reward: 12.3,
        address: "深圳大学冬筑1428",
        doorTime: DateTime.now(),
        createTime: DateTime.now(),
        comment: "一些备注",
        taskValue: TaskValue.high,
        state: TaskState.complete),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "已接受",
              ),
              Tab(
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
              child: ListView.builder(
                  itemCount: testTasksData.length,
                  itemBuilder: ((context, index) {
                    return TaskStatusTile(task: testTasksData[index]);
                  })),
            ),
            Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.05)),
              child: ListView.builder(
                  itemCount: testFinishedTasksData.length,
                  itemBuilder: ((context, index) {
                    return TaskStatusTile(task: testFinishedTasksData[index]);
                  })),
            )
          ],
        ),
      ),
    );
  }
}
