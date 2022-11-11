import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../services/screenAdaper.dart';

class ANText extends StatelessWidget {
  final String text;
  final bool password;
  final void Function(String)? onChanged;
  final int maxLines;
  final double height;

  final TextEditingController? controller;

  const ANText(
      {super.key,
      this.text = "输入内容",
      this.password = false,
      this.controller,
      this.onChanged,
      this.maxLines = 1,
      this.height = 68});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenAdaper.height(height),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        obscureText: password,
        decoration: InputDecoration(
            hintText: text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
        onChanged: onChanged,
      ),
    );
  }
}
