import 'package:express_delivery/pages/postman_register.dart';
import 'package:express_delivery/pages/task/task_status.dart';
import 'package:express_delivery/services/UserServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/User.dart';
import '../models/postman.dart';
import '../models/task_state_model.dart';
import '../services/screenAdapter.dart';

class PostmanCenter extends StatefulWidget {
  const PostmanCenter({super.key});

  @override
  State<StatefulWidget> createState() => _PostmanCenterState();
}

class _PostmanCenterState extends State<PostmanCenter> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserServices().hasPostmanEntitlement(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool hasPostmanEntitlement = snapshot.data!;
          if (hasPostmanEntitlement) {
            return const PostmanCenterRealPage();
          } else {
            return const PostmanRegisterPage();
          }
        }
        return const Center(
          child: Text("获取快递员信息出现错误"),
        );
      },
    );
  }
}

class PostmanCenterRealPage extends StatefulWidget {
  const PostmanCenterRealPage({super.key});

  @override
  State<StatefulWidget> createState() => _PostmanCenterRealPageState();
}

class _PostmanCenterRealPageState extends State<PostmanCenterRealPage> {
  late Future<Postman> postmanInfo;

  Map<String, double> dataMap = {
    "点赞": 10,
    "坏评": 3,
  };

  @override
  void initState() {
    super.initState();
    postmanInfo = UserServices().getPostmanInfo();
    // userInfo = UserServices().getPostmanById(id)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("快递员中心"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: postmanInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var postman = snapshot.data!;
            dataMap['点赞'] = postman.likeNum.toDouble();
            dataMap['坏评'] = postman.dislikeNum.toDouble();
            dataMap['无评价'] =
                (postman.taskFinishedNum - postman.likeNum - postman.dislikeNum)
                    .toDouble();
            return Container(
                margin: EdgeInsets.all(ScreenAdapter().width(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("快递员ID ${postman.id}"),
                    Text("联系电话: ${postman.phone}"),
                    Text("完成任务数量: ${postman.taskFinishedNum}"),

                    /// TODO
                    const Text("个人信用状态： 良好"),
                    SizedBox(
                      height: ScreenAdapter().height(20),
                    ),
                    PieChart(
                      dataMap: dataMap,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      // colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 24,
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: false,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 0,
                      ),
                      // gradientList: ---To add gradient colors---
                      // emptyColorGradient: ---Empty Color gradient---
                    ),
                    SizedBox(
                      height: ScreenAdapter().height(50),
                    ),
                    Center(
                        child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        height: ScreenAdapter().height(50),
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "查看历史记录",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      onTap: () {
                        Provider.of<TaskStateModel>(context, listen: false)
                            .refresh();
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return Builder(
                            builder: (context) {
                              return const TaskStatusPage(
                                  statusType: TaskStatusPageType.Postman);
                            },
                          );
                        }));
                      },
                    ))
                  ],
                ));
          } else {
            return Center(
              child: Text("加载中"),
            );
          }
        },
      ),
    );
  }
}
