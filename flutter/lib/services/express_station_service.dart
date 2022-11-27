import 'package:express_delivery/models/express_station.dart';
import 'request.dart';

class ExpressStationService {
  /// 获取所有驿站地址
  Future<List<ExpressStation>> getStationList() async {
    Response response =
        await Request().get("/express/expressStation/getExpressStationList");

    if (response.data['msg'] == null || response.data['msg'] != "成功") {
      return Future.error("获取驿站地址出错");
    }
    List<dynamic> stations = response.data['data'];

    List<ExpressStation> ret = [];
    for (var jsonData in stations) {
      final station = ExpressStation(
          id: jsonData['id'],
          name: jsonData['name'],
          address: jsonData['location']);

      ret.add(station);
    }
    return ret;
  }
}
