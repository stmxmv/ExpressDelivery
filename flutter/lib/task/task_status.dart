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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "未完成",
              ),
              Tab(
                text: "以完成",
              ),
            ],
          ),
          title: const Text('任务状态'),
          centerTitle: true,
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
