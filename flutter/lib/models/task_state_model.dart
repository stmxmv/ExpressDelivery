import 'package:express_delivery/services/task_service.dart';
import 'package:flutter/foundation.dart';

import 'task.dart';

/// 任务状态的数据模型
class TaskStateModel extends ChangeNotifier {
  late Future<List<Task>> userTasks;
  late Future<List<Task>> userCompleteTasks;

  late Future<List<Task>> postmanTasks;

  late Future<List<Task>> postmanCompleteTasks;

  TaskStateModel() {
    refresh();
  }

  /// 刷新数据
  void refresh() {
    /// userTasks 的状态包括等待中和进行配送中
    userTasks = () async {
      List<Task> tasks = [];

      try {
        List<Task> acceptedTasks =
            await TaskService().getTasks(false, TaskState.accepted);

        tasks.addAll(acceptedTasks);

        List<Task> pendingTasks =
            await TaskService().getTasks(false, TaskState.pending);

        tasks.addAll(pendingTasks);
      } catch (error) {
        print(error);
      }

      return tasks;
    }();

    userCompleteTasks = () async {
      List<Task> tasks = [];
      try {
        tasks = await TaskService().getTasks(false, TaskState.complete);
      } catch (error) {
        print(error);
      }
      return tasks;
    }();

    postmanTasks = () async {
      List<Task> tasks = [];
      try {
        tasks = await TaskService().getTasks(true, TaskState.accepted);
      } catch (error) {
        print(error);
      }
      return tasks;
    }();

    postmanCompleteTasks = () async {
      List<Task> tasks = [];
      try {
        tasks = await TaskService().getTasks(true, TaskState.complete);
      } catch (error) {
        print(error);
      }
      return tasks;
    }();

    notifyListeners();
  }
}
