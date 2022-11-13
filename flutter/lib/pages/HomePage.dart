import 'package:express_delivery/pages/task/task_publish.dart';
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
    String label,
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
        child: Text(
          label,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              color: Colors.white),
        ),
      ),
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {},
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            final buttonWidth = constraint.biggest.width * 0.4;
            final buttonHeight = buttonWidth * 0.75;

            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      mainButton(context, "任务广场", const Color(0xFF3F94E5),
                          buttonWidth, buttonHeight, () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return const TaskGallery();
                        }));
                      }),
                      SizedBox(
                        width: buttonWidth * 0.25,
                      ),
                      mainButton(context, "快递员列表", const Color(0xFF81B336),
                          buttonWidth, buttonHeight, () {}),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      mainButton(context, "成为快递员", const Color(0xFF94DEF4),
                          buttonWidth, buttonHeight, () {}),
                      SizedBox(
                        width: buttonWidth * 0.25,
                      ),
                      mainButton(context, "发布任务", const Color(0xFFFEBF6B),
                          buttonWidth, buttonHeight, () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return const TaskPublish();
                        }));
                      }),
                    ],
                  )
                ]);
          },
        ));
  }
}
