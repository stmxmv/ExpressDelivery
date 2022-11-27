import 'dart:convert';
import '../services/request.dart';

enum TaskState {
  pending("等待接受"),
  accepted("配送中"),
  complete("已完成");

  const TaskState(this.description);
  final String description;
}

enum TaskValue {
  low("低"),
  medium("中"),
  high("高");

  const TaskValue(this.description);
  final String description;
}

class Task {
  final int id;
  final int userId;
  final int? postmanId;
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
  const Task({
    required this.id,
    required this.userId,
    required this.expressNum,
    required this.weight,
    required this.reward,
    required this.address,
    required this.doorTime,
    required this.createTime,
    this.acceptTime,
    this.completeTime,
    this.postmanId,
    required this.comment,
    required this.taskValue,
    required this.state,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        userId: json['userId'],
        postmanId: json['courierId'],
        expressNum: json['expressNum'],
        weight: double.parse(json['weight']),
        reward: double.parse(json['reward']),
        address: json['address'],
        doorTime: DateTime.parse(json['doorTime']),
        createTime: DateTime.parse(json['createTime']),
        acceptTime: json['acceptTime'] == null
            ? null
            : DateTime.parse(json['acceptTime']),
        completeTime: json['completeTime'] == null
            ? null
            : DateTime.parse(json['completeTime']),
        comment: json['comment'],
        taskValue: TaskValue.values[json['value']],
        state: TaskState.values[json['state']],
        id: json['id']);
  }
}

class TaskItemInfo {
  String description;

  TaskItemInfo(this.description);
}
