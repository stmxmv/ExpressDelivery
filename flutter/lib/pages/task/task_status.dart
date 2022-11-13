import 'package:flutter/material.dart';

class TaskStatus extends StatefulWidget {
  const TaskStatus({super.key});

  @override
  State<StatefulWidget> createState() => TaskStatusState();
}

class TaskStatusState extends State<TaskStatus> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "已接受",
              ),
              Tab(
                text: "已发布",
              ),
              Tab(
                text: "已完成",
              ),
            ],
          ),
          title: const Text('任务状态'),
          centerTitle: true,
        ),
        body: const TabBarView(
          children: [
            Center(
              child: Text("已接受"),
            ),
            Center(
              child: Text("已发布"),
            ),
            Center(
              child: Text("已完成"),
            )
          ],
        ),
      ),
    );
  }
}
