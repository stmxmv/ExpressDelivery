import 'package:dio/dio.dart';

import 'UserServices.dart';
import 'request.dart';

class AddressInfo {
  int? id;
  String name;
  String phone;
  String area;
  String detail;

  AddressInfo(this.name, this.phone, this.area, this.detail);
}

/// global sinlenton class
class AddressManager {
  static final AddressManager _addressManager = AddressManager._internal();

  factory AddressManager() {
    return _addressManager;
  }

  AddressManager._internal();

  List<AddressInfo> addressInfos = [];

  /// 获取用户默认的收件地址，取第一个作为默认地址
  Future<AddressInfo?> getDefaultAddressInfo() async {
    List<AddressInfo> infos = await fetchAddressInfos();
    if (infos.isNotEmpty) {
      return infos[0];
    }
    return null;
  }

  /// 获取所有地址列表
  Future<List<AddressInfo>> fetchAddressInfos() async {
    int userId = await UserServices().getUserId();

    var tempJson = {
      "userId": userId,
    };

    try {
      Response response = await Request()
          .get("/express/address/getAddressList", queryParameters: tempJson);

      List<dynamic> addressInfoList = response.data['data'];
      List<AddressInfo> infos = [];
      for (var jsonInfo in addressInfoList) {
        var addressInfo = AddressInfo(jsonInfo['name'], jsonInfo['phone'],
            jsonInfo['address'], jsonInfo['detailAddress']);
        if (jsonInfo['id'] == null) {
          return Future.error("the address has no id");
        }
        addressInfo.id = jsonInfo['id'];
        infos.add(addressInfo);
      }

      return infos;
    } catch (error) {
      print(error);
    }

    return [];
  }

  //// 下面为地址的添加，删除，修改操作
  ///

  Future<bool> addAddress(AddressInfo info) async {
    int userId = await UserServices().getUserId();
    var tempJson = {
      "userId": userId,
      "name": info.name,
      "phone": info.phone,
      "address": info.area,
      "detailAddress": info.detail
    };

    try {
      Response response =
          await Request().post("/express/address/addAddress", data: tempJson);
      if (response.data['msg'] == "成功") {
        return true;
      }
    } catch (error) {
      print(error);
    }

    return false;
  }

  Future<bool> updateAddress(AddressInfo info) async {
    int userId = await UserServices().getUserId();
    var data = {
      "id": info.id,
      "userId": userId,
      "name": info.name,
      "phone": info.phone,
      "address": info.area,
      "detailAddress": info.detail
    };

    try {
      Response response =
          await Request().post("/express/address/setAddress", data: data);
      if (response.data['msg'] == "成功") {
        return true;
      }
    } catch (error) {
      print(error);
    }

    return false;
  }

  Future<bool> deleteAddress(AddressInfo info) async {
    int userId = await UserServices().getUserId();
    try {
      Response response = await Request().get("/express/address/deleteAddress",
          queryParameters: {"id": info.id});

      if (response.data['msg'] != null && response.data['msg'] == "成功") {
        return true;
      }
    } catch (error) {
      print(error);
    }

    return false;
  }
}
