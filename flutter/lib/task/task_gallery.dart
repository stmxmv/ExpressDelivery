import 'package:express_delivery/AddTask.dart';
import 'package:express_delivery/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../TaskDetail.dart';

class TaskGallery extends StatefulWidget {
  const TaskGallery({super.key});

  @override
  State<StatefulWidget> createState() => TaskGalleryState();
}

class TaskGalleryState extends State<TaskGallery>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Task>> tasks;

  var hover = false;
  var hoverIndex = -1;

  var scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    tasks = fetchTasks();
  }

  Widget detailText(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<void> _pullRefresh() async {
    try {
      tasks = fetchTasks();
      await tasks;
      setState(() {});
    } catch (error) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("任务广场"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return const AddTask();
              }));
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: tasks,
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: _pullRefresh,
            child: _listView(snapshot),
          );
        },
      ),
    );
  }

  Widget _listView(AsyncSnapshot<List<Task>> snapshot) {
    if (snapshot.hasData) {
      List<Task> tasks = snapshot.data!;

      return CupertinoScrollbar(
          controller: scrollController,
          child: ListView.builder(
              controller: scrollController,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      hover = true;
                      hoverIndex = index;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      hover = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      hover = false;
                    });
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return TaskDetail(task: tasks[index]);
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: (hover == true && hoverIndex == index)
                            ? Colors.black26
                            : null,
                        border: const Border(
                            top: BorderSide(color: Colors.black12),
                            bottom: BorderSide(color: Colors.black12))),
                    child: Row(
                      children: [
                        Container(
                          constraints: const BoxConstraints(minHeight: 100),
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "发布者ID ${tasks[index].userId}",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text("快递数量 ${tasks[index].expressNum}")
                                ],
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 380.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      detailText(
                                        "重量: ${tasks[index].weight} kg",
                                      ),
                                      detailText(
                                        "珍贵程度: ${tasks[index].taskValue.description}",
                                      ),
                                      detailText(
                                        "创建时间 ${DateFormat('yyyy-MM-dd - kk:mm').format(tasks[index].createTime)}",
                                      ),
                                      detailText(
                                        "地址: ${tasks[index].address}",
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          "任务描述: ${tasks[index].comment}...................................................................................................",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ),
                                      Text(
                                        "金额: ${tasks[index].reward} 元",
                                        style: const TextStyle(
                                            color: Colors.amber),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }));
    } else if (snapshot.hasError) {
      return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(snapshot.error.toString()),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                    onPressed: () {
                      _pullRefresh();
                    },
                    icon: const Icon(Icons.refresh)),
              )
            ]),
      );
    }

    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
