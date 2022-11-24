import 'package:express_delivery/services/UserServices.dart';
import 'package:express_delivery/services/screenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/cell.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<StatefulWidget> createState() => PersonalPageState();
}

class PersonalPageState extends State<PersonalPage> {
  Widget headerWidget() {
    return Container(
      height: 200,
      color: Colors.white,
      child: Container(
        margin:
            const EdgeInsets.only(top: 100, bottom: 20, left: 10, right: 10),
        child: Row(
          children: [
            //头像
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child:
                    const Image(image: AssetImage('assets/images/avater.png')),
              ),
            ),

            //left side

            Container(
              margin: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width - 20 - 90,
              height: 100,
              child: Stack(
                children: const [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Text(
                      "用户名",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Text(
                      "账号: 12345678",
                      style: TextStyle(
                        color: Color.fromRGBO(144, 144, 144, 1.0),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image(
                      image: AssetImage('assets/images/arrow_right.png'),
                      width: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.05)),
          child: Stack(
            children: [
              Container(
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(children: [
                      headerWidget(),
                      SizedBox(
                        height: ScreenAdapter().height(10),
                      ),
                      const Cell(
                        title: "我的订单",
                        imageName: "assets/images/order.png",
                      ),
                      SizedBox(
                        height: ScreenAdapter().height(10),
                      ),
                      const Cell(
                        title: "客服",
                        imageName: "assets/images/customer_service.png",
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: 50, height: 0.5, color: Colors.white),
                          Container(height: 0.5, color: Colors.grey)
                        ],
                      ),
                      const Cell(
                        title: "会员中心",
                        imageName: "assets/images/vip.png",
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: 50, height: 0.5, color: Colors.white),
                          Container(height: 0.5, color: Colors.grey)
                        ],
                      ),
                      const Cell(
                        title: "服务中心",
                        imageName: "assets/images/earth.png",
                      ),
                      SizedBox(
                        height: ScreenAdapter().height(10),
                      ),
                      Cell(
                        title: "注销",
                        imageName: "assets/images/signout.png",
                        onTap: () async {
                          await UserServices().debugSwitchAccount();
                          var id = await UserServices().getUserId();
                          print(id);
                        },
                      )
                    ])),
              ),
              Positioned(
                right: 10,
                top: ScreenAdapter().height(40),
                child: Image.asset(
                  "assets/images/camera.png",
                  width: 25,
                ),
              ),
            ],
          )),
    );
  }
}
