import 'package:express_delivery/services/screenAdapter.dart';
import 'package:flutter/material.dart';

class PostmanRegisterPage extends StatefulWidget {
  const PostmanRegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _PostmanRegisterPageState();
}

class _PostmanRegisterPageState extends State<PostmanRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("快递员中心"),
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.all(ScreenAdapter().width(20)),
          child: Column(
            children: [],
          )),
    );
  }
}
