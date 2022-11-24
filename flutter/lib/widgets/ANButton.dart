import 'package:flutter/material.dart';

import '../services/screenAdapter.dart';

class ANButton extends StatelessWidget {
  final Color color;
  final String text;
  final void Function()? onTap;
  final double height;

  const ANButton(
      {super.key,
      this.color = Colors.black,
      this.text = "按钮",
      this.onTap,
      this.height = 68});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        height: ScreenAdapter().height(height),
        width: double.infinity,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            "$text",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
