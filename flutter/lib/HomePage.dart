import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("主页"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.all(0),
        children: const [
          UserAccountsDrawerHeader(
            accountName: Text("用户名"),
            accountEmail: Text("email"),
            currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://www.baidu.com/img/flexible/logo/pc/result@2.png")),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://i0.hdslb.com/bfs/feed-admin/276af9a950a93889be31c698a8fdfd5add8b2b82.jpg@336w_190h_1c.webp"))),
          ),
          ListTile(
            title: Text("用户反馈"),
            trailing: Icon(Icons.feedback),
          ),
          ListTile(
            title: Text("系统设置"),
            trailing: Icon(Icons.settings),
          ),
          Divider(),
          ListTile(
            title: Text("注销"),
            trailing: Icon(Icons.exit_to_app),
          ),
        ],
      )),
    );
  }
}
