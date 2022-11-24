import 'package:express_delivery/models/task.dart';
import 'package:express_delivery/services/screenAdapter.dart';
import 'package:express_delivery/services/task_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_detail.dart';

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
    tasks = TaskService().fetchAvailableTasks();
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
      tasks = TaskService().fetchAvailableTasks();
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
          // actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {
          //     Navigator.push(context, CupertinoPageRoute(builder: (context) {
          //       return const AddTask();
          //     }));
          //   },
          // )
          // ],
        ),
        body: Container(
          decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.05)),
          child: FutureBuilder(
            future: tasks,
            builder: (context, snapshot) {
              return RefreshIndicator(
                onRefresh: _pullRefresh,
                child: _listView(snapshot),
              );
            },
          ),
        ));
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
                    })).then((value) {
                      _pullRefresh();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenAdapter().width(5),
                        horizontal: ScreenAdapter().height(10)),
                    decoration: BoxDecoration(
                      color: (hover == true && hoverIndex == index)
                          ? Colors.black26
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                        margin: EdgeInsets.all(ScreenAdapter().width(10)),
                        child: Row(
                          children: [
                            Container(
                              constraints: const BoxConstraints(minHeight: 100),
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: ScreenAdapter().height(4),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "发布者ID ${tasks[index].userId}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      SizedBox(
                                        width: ScreenAdapter().width(30),
                                      ),
                                      Text("快递数量 ${tasks[index].expressNum}")
                                    ],
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: ScreenAdapter().width(200)),
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
                                          // SizedBox(
                                          //   width: ScreenAdaper.width(300),
                                          //   child: Text(
                                          //     "备注: ${tasks[index].comment}",
                                          //     overflow: TextOverflow.ellipsis,
                                          //     style: Theme.of(context)
                                          //         .textTheme
                                          //         .caption,
                                          //   ),
                                          // ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: ScreenAdapter().height(4),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: ScreenAdapter().width(90),
                              child: Center(
                                  child: Text(
                                "¥ ${tasks[index].reward}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )),
                            )
                          ],
                        )),
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
