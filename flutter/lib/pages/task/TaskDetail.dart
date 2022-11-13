import 'package:express_delivery/services/screenAdaper.dart';
import 'package:express_delivery/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/User.dart';
import '../../models/task.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key, required this.task});

  final Task task;

  @override
  State<StatefulWidget> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    var doorTime =
        DateFormat('yyyy-MM-dd - kk:mm').format(widget.task.doorTime);
    return Scaffold(
        appBar: AppBar(
          title: const Text("任务详情"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person_outline_outlined),
                  title: Text("发布者"),
                  subtitle: Text(
                    'ID: ${widget.task.userId}',
                    softWrap: true,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.numbers),
                  title: Text("快递数量"),
                  subtitle: Text('${widget.task.expressNum}', softWrap: true),
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text("珍贵程度"),
                  subtitle: Text('${widget.task.taskValue.description}',
                      softWrap: true),
                ),
                ListTile(
                  leading: Icon(Icons.add_home_rounded),
                  title: Text("地址"),
                  subtitle: Text('${widget.task.address}', softWrap: true),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("电话"),
                  subtitle: Text('${widget.task.expressNum}', softWrap: true),
                ),
                ListTile(
                  leading: Icon(Icons.line_weight),
                  title: Text("重量"),
                  subtitle: Text('${widget.task.weight} kg', softWrap: true),
                ),
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text("上门时间"),
                  subtitle: Text('${doorTime}', softWrap: true),
                ),
                ListTile(
                  leading: Icon(Icons.comment),
                  title: Text("备注:"),
                  subtitle: Text('${widget.task.comment}', softWrap: true),
                ),
              ],
            )),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FittedBox(
                    child: SizedBox(
                        width: ScreenAdaper.width(100),
                        child: Text('¥ ${widget.task.reward}',
                            style: const TextStyle(fontSize: 30.0))),
                  ),
                  GestureDetector(
                    child: Container(
                      //margin: EdgeInsets.fromLTRB(50, 50, 50, 50),
                      alignment: Alignment.center,
                      width: ScreenAdaper.width(200),
                      height: ScreenAdaper.height(50),
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text("接受任务", style: TextStyle(fontSize: 20)),
                    ),
                    onTap: () async {
                      bool success =
                          await TaskService().acceptTask(widget.task.id);
                      ;
                      if (mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('已接受')));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('接受失败或已被其他人接受')));
                          Navigator.pop(context);
                        }
                      } else {
                        // TODO send notification ?
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }
}
