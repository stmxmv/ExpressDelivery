import 'package:express_delivery/pages/HomePage.dart';
import 'package:express_delivery/pages/personal_page.dart';
import 'package:express_delivery/pages/task/task_status.dart';
import 'package:flutter/material.dart';

import 'pages/task/task_gallery.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  static const TaskGallery task = TaskGallery();

  final List<Widget> _pages = [
    const HomePage(),
    const TaskStatus(),
    const ErrorPage(),
    const PersonalPage()
  ];

  @override
  Widget build(BuildContext context) {
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '任务',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }
}
