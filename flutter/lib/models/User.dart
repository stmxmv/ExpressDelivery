import 'package:dio/dio.dart';
import 'dart:convert';

class User {
  final int id;
  final String username;

  final String nickname;
  final String email;
  final String phone;
  final String address;

  const User(
    this.username,
    this.nickname,
    this.email,
    this.phone,
    this.address, {
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['username'], json['nickname'], json['email'],
        json['phone'], json['address'],
        id: json['id']);
  }
}

Future<List<User>> fetchUser() async {
  var dio = Dio();

  try {
    final response = await dio.get("http://10.0.2.2:8080/user/page",
        queryParameters: {"page": 1, "size": 10},
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status == 200;
            }));

    // final response = await http
    // .get(Uri.parse('http://10.0.2.2:8080/user/page?page=1&size=10'));

    // If the server did return a 200 OK response,
    // then parse the JSON.

    final List<dynamic> records = response.data['records'];

    List<User> ret = [];

    for (var record in records) {
      User user = User.fromJson(record);
      ret.add(user);
    }

    return ret;
  } on DioError catch (error) {
    if (error.response?.statusCode == 404) {
      return Future.error("404");
    } else {
      return Future.error(error.message);
    }
  }
}
