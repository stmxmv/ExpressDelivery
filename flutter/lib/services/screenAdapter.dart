import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter {
  static final ScreenAdapter _screenAdapter = ScreenAdapter._internal();

  ScreenAdapter._internal();

  factory ScreenAdapter() {
    return _screenAdapter;
  }

  double size(double value) {
    return ScreenUtil().setSp(value);
  }

  /// default size is 360 x 690
  static void init(context) {
    ScreenUtil.init(context);
  }

  static Future<void> ensureScreenSize() async {
    return ScreenUtil.ensureScreenSize();
  }

  double height(double value) {
    return ScreenUtil().setHeight(value);
  }

  double width(double value) {
    return ScreenUtil().setWidth(value);
  }

  double getScreenHeight() {
    return ScreenUtil().screenHeight;
  }

  double getScreenWidth() {
    return ScreenUtil().screenWidth;
  }
// ScreenUtil.screenHeight
}
