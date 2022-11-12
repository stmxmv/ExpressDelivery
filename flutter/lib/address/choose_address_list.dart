import 'package:express_delivery/models/address_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:express_delivery/address/address_add.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/request.dart';
import '../services/UserServices.dart';
import 'address_edit.dart';

class ChooseAddressList extends StatefulWidget {
  ChooseAddressList({super.key});

  // List<AddressInfo> addressInfos = [
  //   const AddressInfo("张三", "11111111", "广东省深圳市南山区", "深圳某小区"),
  //   const AddressInfo("李四", "22222222", "河北省北京市海淀区", "北京某小区"),
  //   const AddressInfo("余姚", "33333333", "台湾省台北市", "某街道某小区"),
  // ];
  AddressInfo? addressInfo;
  int selectIndex = 0;

  AddressInfo? getSelectedAddress() {
    return addressInfo;
  }

  @override
  State<StatefulWidget> createState() => AddressListState();
}

class AddressListState extends State<ChooseAddressList> {
  late Future<List<AddressInfo>> addressInfos;

  @override
  void initState() {
    super.initState();

    addressInfos = AddressManager().fetchAddressInfos();
  }

  List<Widget> getAddressRows(List<AddressInfo> addressInfos) {
    List<Widget> children = [const SizedBox(height: 20)];
    for (var i = 0; i < addressInfos.length; ++i) {
      children.add(
        addressRow(addressInfos[i], i == widget.selectIndex, () {
          setState(() {
            widget.selectIndex = i;
            widget.addressInfo = addressInfos[i];
          });
        }, () async {
          bool result = await AddressManager().deleteAddress(addressInfos[i]);
          var infos = await AddressManager().fetchAddressInfos();
          this.addressInfos = Future.value(infos);
          await this.addressInfos;
          if (result && mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('删除成功')));
            setState(() {
              if (widget.selectIndex == i) {
                widget.selectIndex = 0;
                widget.addressInfo = infos[0];
              }
            });
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('删除失败')));
          }
        }),
      );
      if (i != addressInfos.length - 1) {
        children.add(const Divider(height: 20));
      }
    }

    return children;
  }

  Widget addressRow(AddressInfo info, bool selected, void Function()? onTap,
      void Function()? onDelete) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (onDelete != null) {
                onDelete();
              }
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: selected ? const Icon(Icons.check, color: Colors.red) : null,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("${info.name}  ${info.phone}"),
          const SizedBox(height: 10),
          Text("${info.area} ${info.detail}"),
        ]),
        trailing: GestureDetector(
          child: const Icon(Icons.edit, color: Colors.blue),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return AddressEditPage(
                info: info,
              );
            })).then((value) {
              setState(() {
                addressInfos = AddressManager().fetchAddressInfos();
              });
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("收件地址列表"),
          centerTitle: true,
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              FutureBuilder(
                  future: addressInfos,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: getAddressRows(snapshot.data!),
                      );
                    }
                    return const Center(
                      child: Text("加载中"),
                    );
                  })),
              Positioned(
                bottom: 0,
                width: 400,
                height: 88,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 400,
                  height: 88,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black26))),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: Colors.white),
                        Text("增加收货地址", style: TextStyle(color: Colors.white))
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return const AddressAdd();
                      })).then(
                        (value) {
                          setState(() {
                            addressInfos = AddressManager().fetchAddressInfos();
                          });
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
