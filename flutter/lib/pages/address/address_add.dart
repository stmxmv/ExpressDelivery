import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';

import '../../services/address_manager.dart';
import '../../services/screenAdapter.dart';
import '../../widgets/ANButton.dart';
import '../../widgets/ANText.dart';

class AddressAdd extends StatefulWidget {
  const AddressAdd({super.key});

  @override
  State<StatefulWidget> createState() => AddressAddState();
}

class AddressAddState extends State<AddressAdd> {
  String name = '';
  String phone = '';
  String area = '';
  String addressTetail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("增加收件地址"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 20),
                ANText(
                  text: "收货人姓名",
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 10),
                ANText(
                  text: "收货人电话",
                  onChanged: (value) {
                    phone = value;
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  height: ScreenAdapter().height(68),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black12))),
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.add_location),
                        area.isNotEmpty
                            ? Text(area,
                                style: const TextStyle(color: Colors.black54))
                            : const Text('省/市/区',
                                style: TextStyle(color: Colors.black54))
                      ],
                    ),
                    onTap: () async {
                      Result? result = await CityPickers.showCityPicker(
                          context: context,
                          cancelWidget: const Text("取消",
                              style: TextStyle(color: Colors.blue)),
                          confirmWidget: const Text("确定",
                              style: TextStyle(color: Colors.blue)));

                      // print(result);
                      setState(() {
                        if (result != null) {
                          area =
                              "${result.provinceName}/${result.cityName}/${result.areaName}";
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ANText(
                  text: "详细地址",
                  maxLines: 4,
                  height: 200,
                  onChanged: (value) {
                    addressTetail = value;
                  },
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 40),
                ANButton(
                  text: "增加",
                  color: Colors.red,
                  onTap: () async {
                    AddressInfo info =
                        AddressInfo(name, phone, area, addressTetail);
                    bool result = await AddressManager().addAddress(info);
                    if (result && mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('添加成功')));

                      Navigator.pop(context);
                    } else if (mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('添加失败')));
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
