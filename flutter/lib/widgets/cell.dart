import 'dart:ui';

import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  final String? title;
  final String? imageName;
  final String? subTitle;
  final String? subImageName;
  final void Function()? onTap;

  const Cell(
      {super.key,
      required this.title,
      required this.imageName,
      this.subTitle,
      this.subImageName,
      this.onTap})
      : assert(title != null, "title 不能为空"),
        assert(imageName != null, "imageName 不能为空");

  @override
  State<StatefulWidget> createState() => _CellState();
}

class _CellState extends State<Cell> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            hover = false;
          });
          var onTap = widget.onTap;
          if (onTap != null) {
            onTap();
          }
        },
        onTapCancel: () {
          setState(() {
            hover = false;
          });
        },
        onTapDown: (TapDownDetails details) {
          setState(() {
            hover = true;
          });
        },
        child: Container(
          height: 55,
          color: hover ? Colors.black12 : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // left
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    //image
                    Image(
                      image: AssetImage(widget.imageName!),
                      width: 20,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    //title
                    Text(widget.title!),
                  ],
                ),
              ),
              // right
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      // subtitle
                      Text(widget.subTitle ?? ""),
                      // subimage
                      widget.subImageName != null
                          ? Image(
                              image: AssetImage(widget.subImageName!),
                              width: 12,
                            )
                          : Container(),
                      const Image(
                        image: AssetImage('assets/images/arrow_right.png'),
                        width: 15,
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
