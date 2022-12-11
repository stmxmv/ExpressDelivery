import 'package:express_delivery/pages/postman_center.dart';
import 'package:express_delivery/pages/task/task_publish.dart';
import 'package:express_delivery/services/UserServices.dart';
import 'package:express_delivery/services/screenAdapter.dart';
import 'package:express_delivery/widgets/swiper_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'task/task_gallery.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget mainButton(
    BuildContext context,
    Widget child,
    Color color,
    double width,
    double height,
    void Function()? onPressed,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        child: child,
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("取消"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("继续"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return const PostmanCenter();
        }));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("提示"),
      content: const Text("你现在还未有快递员资格，是否继续注册成为快递员？"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("快递代领"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Column(children: [
              Row(children: const [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                Text(
                  "深大南校区",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer()
              ]),
              const SizedBox(
                height: 10,
              )
            ]),
          ),
          centerTitle: true,
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.chat),
          //     onPressed: () {},
          //   )
          // ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenAdapter().height(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mainButton(
                    context,
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "任务广场",
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize,
                                color: Colors.white),
                          ),
                          const Icon(Icons.task)
                        ]),
                    const Color(0xFF3F94E5),
                    150,
                    108 * 2 + 20, () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const TaskGallery();
                  }));
                }),
                SizedBox(
                  width: ScreenAdapter().width(20),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mainButton(
                        context,
                        Text(
                          "活动中心",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize,
                              color: Colors.white),
                        ),
                        const Color(0xFF81B336),
                        150,
                        108,
                        () {}),
                    SizedBox(
                      height: ScreenAdapter().height(20),
                    ),
                    mainButton(
                        context,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "发布任务",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .fontSize,
                                  color: Colors.white),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 70),
                              child: Icon(Icons.publish),
                            )
                          ],
                        ),
                        const Color(0xFFFEBF6B),
                        150,
                        108, () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return const TaskPublish();
                      }));
                    }),
                  ],
                )
              ],
            ),
            SizedBox(
              height: ScreenAdapter().height(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mainButton(
                    context,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "快递员中心",
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize,
                                color: Colors.white),
                          ),
                          const Icon(Icons.delivery_dining)
                        ]),
                    const Color(0xFF94DEF4),
                    324,
                    108, () async {
                  if (await UserServices().hasPostmanEntitlement()) {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return const PostmanCenter();
                    }));
                  } else {
                    showAlertDialog(context);
                  }
                }),
              ],
            ),
            SizedBox(
              height: ScreenAdapter().height(20),
            ),
            SizedBox(
              width: ScreenAdapter().width(300),
              height: ScreenAdapter().width(150),
              child: const SwiperView(),
            ),
          ],
        ));
  }
}
