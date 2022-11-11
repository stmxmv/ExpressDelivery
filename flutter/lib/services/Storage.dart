import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Storage._internal();

  static final Storage _storage = Storage._internal();

  factory Storage() {
    return _storage;
  }

  Future<void> setString(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  Future<String?> getString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<void> remove(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  Future<void> clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
