import 'dart:async';

import 'package:flutter/material.dart';

class SwiperView extends StatefulWidget {
  const SwiperView({super.key});

  @override
  State<SwiperView> createState() => _SwiperViewState();
}

class _SwiperViewState extends State<SwiperView> {
  // 声明一个list，存放image Widget
  List<Widget> imageList = [];

  final _pageController = PageController();

  int currentIndex = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    imageList
      ..add(Image.network(
        'https://m15.360buyimg.com/mobilecms/jfs/t1/178033/29/30286/92595/638f201aE0bdb3790/53908694417f7e40.jpg!cr_1125x449_0_166!q70.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://m15.360buyimg.com/mobilecms/jfs/t1/182981/28/30228/91886/638dcc6bE773dd83d/a939dacd8b46fcfe.jpg!cr_1053x420_4_0!q70.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://m15.360buyimg.com/mobilecms/s1062x420_jfs/t1/212225/6/11238/61871/61e50ff9E7f02c060/8d0f3065b0c27182.jpg!cr_1053x420_4_0!q70.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://m15.360buyimg.com/mobilecms/jfs/t1/92483/19/34213/69725/638da932E22ada59f/05a1c3c973c1dadf.jpg!cr_1053x420_4_0!q70.jpg',
        fit: BoxFit.fill,
      ));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return buildBanner();
  }

  void startTimer() {
    //间隔两秒时间
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (value) {
      currentIndex++;
      //触发轮播切换
      _pageController.animateToPage(currentIndex,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
      //刷新
      setState(() {});
    });
  }

  Widget buildPageViewItemWidget(int index) {
    return imageList[index % imageList.length];
  }

  Widget buildBanner() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          //轮播图片
          buildBannerWidget(),
          //指示器
          buildTipsWidget(),
        ],
      ),
    );
  }

  Widget buildBannerWidget() {
    //懒加载方式构建
    return PageView.builder(
      //构建每一个子Item的布局
      itemBuilder: (BuildContext context, int index) {
        return buildPageViewItemWidget(index);
      },
      //控制器
      controller: _pageController,
      //轮播个数 无限轮播 ??
      itemCount: imageList.length * 10000,
      //PageView滑动时回调
      onPageChanged: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  Widget buildTipsWidget() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        //内边距
        padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
        //圆角边框
        decoration: const BoxDecoration(
            //背景
            color: Colors.white,
            //边框圆角
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child:
            Text("${currentIndex % imageList.length + 1}/${imageList.length}"),
      ),
    );
  }
}
