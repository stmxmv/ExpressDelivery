import 'package:express_delivery/models/postman.dart';
import 'package:express_delivery/services/request.dart';

import '../models/User.dart';
import '../services/Storage.dart';
import 'dart:convert';

class UserServices {
  static final UserServices _userServices = UserServices._internal();

  UserServices._internal();

  factory UserServices() {
    return _userServices;
  }

  Future<int> getUserId() async {
    /// 登陆后user id 保持到本地中获取
    // bool state = await getUserLoginState();

    // if (!state) {
    //   return -1;
    // }
    var id = await Storage().getString('user_id');
    return int.parse(id!);
  }

  Future<User> getUserInfo() async {
    return await getUserInfoById(
        int.parse((await Storage().getString('user_id'))!));
  }

  Future<User> getUserInfoById(int id) async {
    var data = {"id": id};
    try {
      Response response = await Request()
          .get("/express/user/getUserInfo", queryParameters: data);

      if (response.data != null && response.data['data'] != null) {
        return User.fromJson(response.data['data']);
      }
    } catch (e) {
      return Future.error(e);
    }
    return Future.error("获取用户信息失败");
  }

  Future<Postman> getPostmanInfo() async {
    User user = await getUserInfo();
    if (user.postmanId != null) {
      Postman postman = await getPostmanById(user.postmanId!);
      return postman;
    }
    return Future.error("该用户没有快递员ID");
  }

  // Future<bool> getUserLoginState() async {
  //   /// TODO

  //   // var userInfo = await UserServices().getUserInfo();
  //   // if (userInfo.isNotEmpty && userInfo[0]["username"] != "") {
  //   //   return true;
  //   // }
  //   return false;
  // }

  /// TODO 登陆模块没做暂时使用本地数据
  void login() {
    Storage().setString('user_id', 1.toString());
  }

  void loginOut() {
    Storage().remove('userInfo');
  }

  Future<bool> hasPostmanEntitlement() async {
    var id = await Storage().getString('user_id');
    if (id == "1") {
      return true;
    }
    return false;
  }

  /// @id the postman id, 与user id 不同！
  Future<Postman> getPostmanById(int id) async {
    var data = {"id": id};

    try {
      Response response = await Request()
          .get("/express/user/getDeliverymanInfo", queryParameters: data);

      if (response.data['data'] != null) {
        return Postman.fromJson(response.data['data']);
      }
    } catch (error) {
      return Future.error(error);
    }

    return Future.error("获取代拿人员信息发生错误");

    /// test hook
    // return const User(
    //     id: 3,
    //     username: "快递员名",
    //     nickname: "快递员昵称",
    //     email: "123@example.com",
    //     phone: "123123123");
  }

  /// debug 测试用，转换普通用户和有代拿资格的用户
  Future<void> debugSwitchAccount() async {
    var id = await Storage().getString('user_id');
    if (id == "1") {
      Storage().setString('user_id', 2.toString());
    } else {
      Storage().setString('user_id', 1.toString());
    }
  }
}
