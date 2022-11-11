import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdaper {
  static size(double value) {
    return ScreenUtil().setSp(value);
  }

  static init(context) {
    ScreenUtil.init(context);
  }

  static height(double value) {
    return ScreenUtil().setHeight(value);
  }

  static width(double value) {
    return ScreenUtil().setWidth(value);
  }

  static getScreenHeight() {
    return ScreenUtil().screenHeight;
  }

  static getScreenWidth() {
    return ScreenUtil().screenWidth;
  }
// ScreenUtil.screenHeight
}
