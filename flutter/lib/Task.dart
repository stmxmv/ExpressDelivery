import 'package:express_delivery/AddTask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TaskDetail.dart';

import 'models/User.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<StatefulWidget> createState() => TaskState();
}

class TaskState extends State<Task> with AutomaticKeepAliveClientMixin {
  late Future<List<User>> users;

  var hover = false;
  var hoverIndex = -1;

  var scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    users = fetchUser();
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
      users = fetchUser();
      await users;
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
        title: const Text("快递代拿"),
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
        future: users,
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: _pullRefresh,
            child: _listView(snapshot),
          );
        },
      ),
    );
  }

  Widget _listView(AsyncSnapshot<List<User>> snapshot) {
    if (snapshot.hasData) {
      List<User> users = snapshot.data!;

      return CupertinoScrollbar(
          controller: scrollController,
          child: ListView.builder(
              controller: scrollController,
              itemCount: users.length,
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
                      return TaskDetail(user: users[index]);
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: (hover == true && hoverIndex == index)
                            ? Colors.black26
                            : null,
                        border: const Border(
                            top: BorderSide(color: Colors.black12))),
                    child: Row(
                      children: [
                        Container(
                          constraints: const BoxConstraints(minHeight: 100),
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "用户名 ${users[index].username}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 380.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      detailText(
                                        "昵称 ${users[index].nickname}",
                                      ),
                                      detailText(
                                        "手机 ${users[index].phone}",
                                      ),
                                      detailText(
                                        "邮箱 ${users[index].email} ${users[index].email} ${users[index].email} ${users[index].email} ${users[index].email} ${users[index].email}",
                                      ),
                                      detailText(
                                        "地址 ${users[index].address}",
                                      ),
                                    ]),
                              )
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
