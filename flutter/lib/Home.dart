import 'package:badges/badges.dart';
import 'package:express_delivery/models/task_state_model.dart';
import 'package:express_delivery/pages/HomePage.dart';
import 'package:express_delivery/pages/message_page.dart';
import 'package:express_delivery/pages/personal_page.dart';
import 'package:express_delivery/pages/task/task_status.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/message_model.dart';
import 'pages/task/task_gallery.dart';
import 'services/screenAdapter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Error Page"),
    );
  }
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int pressedNum = 0;

  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 1) {
      // 刷新任务
      Provider.of<TaskStateModel>(context, listen: false).refresh();
    } else if (index == 2) {
      Provider.of<MessageModel>(context, listen: false).refresh();
    }
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  static const TaskGallery task = TaskGallery();

  final List<Widget> _pages = [
    const HomePage(),
    const TaskStatusPage(
      statusType: TaskStatusPageType.User,
    ),
    const MessagePage(),
    const PersonalPage()
  ];

  void showErrorAlertDialog(BuildContext context, String error) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: const Text("确定"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("提示"),
      content: Text(error),
      actions: [
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
    ScreenAdapter.init(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: ((value) {
          setState(() {
            _selectedIndex = value;
          });
        }),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主页',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: '任务',
              activeIcon: GestureDetector(
                onDoubleTap: () {
                  Provider.of<TaskStateModel>(context, listen: false).refresh();
                },
                child: Icon(Icons.business),
              )),
          BottomNavigationBarItem(
            icon: Badge(
                showBadge: context.watch<MessageModel>().unreadCount > 0,
                badgeContent: Text(
                  "${context.watch<MessageModel>().unreadCount}",
                  style: const TextStyle(color: Colors.white),
                ),
                child: const Icon(Icons.message)),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: (value) {
          _onItemTapped(context, value);
        },
      ),
    );
  }
}
