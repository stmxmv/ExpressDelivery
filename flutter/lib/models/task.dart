import 'dart:convert';
import 'request.dart';

enum TaskState { pending, complete }

enum TaskValue {
  low("低"),
  medium("中"),
  high("高");

  const TaskValue(this.description);
  final String description;
}

class Task {
  final int userId;
  final int expressNum;
  final double weight;
  final double reward;
  final String address;
  final DateTime doorTime;
  final DateTime createTime;
  final DateTime? acceptTime;

  final DateTime? completeTime;

  final String comment;
  final TaskValue taskValue;
  final TaskState state;

  // constructor
  const Task(
    this.userId,
    this.expressNum,
    this.weight,
    this.reward,
    this.address,
    this.doorTime,
    this.createTime,
    this.acceptTime,
    this.completeTime,
    this.comment,
    this.taskValue,
    this.state,
  );

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['uid'],
      json['expressNum'],
      json['dweight'],
      json['dreward'],
      json['daddress'],
      DateTime.parse(json['ddoorTime']),
      DateTime.parse(json['dcreateTime']),
      json['dacceptTime'] == null ? null : DateTime.parse(json['dacceptTime']),
      json['dcompleteTime'] == null
          ? null
          : DateTime.parse(json['dcompleteTime']),
      json['comment'],
      TaskValue.values[json['dvalue']],
      TaskState.values[json['dstate']],
    );
  }
}

Future<List<Task>> fetchTasks() async {
  try {
    final response = await Request().get("/express/getTaskAvailable",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status == 200;
            }));

    // final response = await http
    // .get(Uri.parse('http://10.0.2.2:8080/user/page?page=1&size=10'));

    // If the server did return a 200 OK response,
    // then parse the JSON.

    final List<dynamic> records = response.data;

    List<Task> ret = [];

    for (var record in records) {
      Task user = Task.fromJson(record);
      ret.add(user);
    }

    return ret;
  } on DioError catch (error) {
    if (error.response?.statusCode == 404) {
      return Future.error("404");
    } else {
      return Future.error(error.message);
    }
  }
}

class TaskItemInfo {
  String description;

  TaskItemInfo(this.description);
}
