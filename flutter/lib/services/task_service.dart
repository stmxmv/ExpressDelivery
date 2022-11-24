import 'package:express_delivery/models/task.dart';

import 'UserServices.dart';
import 'request.dart';

class TaskPublishDescriptor {
  int stationId;
  String address;
  int weight;
  DateTime doorTime;
  int expressNum;
  String? comment;
  double reward;
  List<TaskAddExpressDescriptor> expressDescriptors;
  TaskValue value;
  bool useBlackList = false;
  bool useWhileList = false;

  TaskPublishDescriptor(
      {required this.stationId,
      required this.address,
      required this.weight,
      required this.doorTime,
      required this.expressNum,
      required this.comment,
      required this.reward,
      required this.expressDescriptors,
      this.value = TaskValue.low});
}

class TaskAddExpressDescriptor {
  String descripton;

  TaskAddExpressDescriptor({required this.descripton});
}

class TaskService {
  Future<int> _addExpress(TaskAddExpressDescriptor descriptor) async {
    var data = {"description": descriptor.descripton};

    try {
      Response response =
          await Request().post("/express/express/addExpress", data: data);

      if (response.data["msg"] != null && response.data["msg"] == "成功") {
        return response.data["data"];
      }
    } catch (error) {
      print(error);
    }

    return Future.error("cannot add express");
  }

  Future<List<Task>> fetchAvailableTasks() async {
    try {
      final response = await Request().get("/express/task/getTaskAvailable",
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status == 200;
              }));

      // final response = await http
      // .get(Uri.parse('http://10.0.2.2:8080/user/page?page=1&size=10'));

      // If the server did return a 200 OK response,
      // then parse the JSON.

      final List<dynamic> records = response.data['data'];

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
        return Future.error("获取任务列表失败 ");
      }
    }
  }

  Future<bool> acceptTask(int taskId) async {
    try {
      int userId = await UserServices().getUserId();

      var data = {"deliverymanId": userId, "taskId": taskId};

      Response response =
          await Request().post("/express/task/acceptTask", data: data);
      if (response.data["msg"] != null && response.data["msg"] == "成功") {
        return true;
      }
    } catch (error) {
      print(error);
    }

    return false;
  }

  Future<bool> publishTask(TaskPublishDescriptor descriptor) async {
    try {
      int userId = await UserServices().getUserId();

      List<int> expressIds = [];

      for (var descriptor in descriptor.expressDescriptors) {
        expressIds.add(await _addExpress(descriptor));
      }

      var data = {
        "expressStationId": descriptor.stationId,
        "userId": userId,
        "address": descriptor.address,
        "weight": descriptor.weight,
        "value": descriptor.value.index,
        "doorTime": descriptor.doorTime.toString(),
        "expressNum": descriptor.expressNum,
        "reward": descriptor.reward,
        "expressIdList": expressIds,
        "useBlackList": descriptor.useBlackList,
        "useWhileList": descriptor.useWhileList
      };

      if (descriptor.comment != null) {
        data["comment"] = descriptor.comment!;
      }

      Response response =
          await Request().post("/express/task/releaseTask", data: data);

      if (response.data["msg"] != null && response.data["msg"] == "成功") {
        return true;
      }
    } catch (error) {
      print(error);
    }

    return false;
  }
}
