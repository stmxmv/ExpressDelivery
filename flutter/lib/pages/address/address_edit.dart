import 'package:express_delivery/services/address_manager.dart';
import 'package:flutter/material.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';

import '../../services/screenAdapter.dart';
import '../../widgets/ANButton.dart';
import '../../widgets/ANText.dart';

class AddressEditPage extends StatefulWidget {
  AddressInfo info;
  AddressEditPage({super.key, required this.info});

  @override
  State<AddressEditPage> createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  String area = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // print(widget.arguments);

    nameController.text = widget.info.name;
    phoneController.text = widget.info.phone;
    area = widget.info.area;
    addressController.text = widget.info.detail;
  }
  //监听页面销毁的事件
  // @override
  // void dispose(){
  //   super.dispose();
  //   eventBus.fire(new AddressEvent('增加成功...'));
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("修改收货地址"),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 20),
                ANText(
                  controller: nameController,
                  text: "收货人姓名",
                  onChanged: (value) {
                    widget.info.name = value;
                  },
                ),
                const SizedBox(height: 10),
                ANText(
                  controller: phoneController,
                  text: "收货人电话",
                  onChanged: (value) {
                    widget.info.phone = value;
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
                          locationCode: "130102",
                          cancelWidget: const Text("取消",
                              style: TextStyle(color: Colors.blue)),
                          confirmWidget: const Text("确定",
                              style: TextStyle(color: Colors.blue)));

                      // print(result);
                      setState(() {
                        if (result != null) {
                          area =
                              "${result.provinceName}/${result.cityName}/${result.areaName}";
                          widget.info.area = area;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ANText(
                  controller: addressController,
                  text: "详细地址",
                  maxLines: 4,
                  height: 200,
                  onChanged: (value) {
                    widget.info.detail = value;
                  },
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 40),
                ANButton(
                    text: "修改",
                    color: Colors.red,
                    onTap: () async {
                      bool result =
                          await AddressManager().updateAddress(widget.info);
                      if (result && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('修改成功')));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('修改失败')));
                      }
                    })
              ],
            ),
          )),
    );
  }
}
