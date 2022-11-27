import 'package:dio/dio.dart';
import 'dart:convert';

class User {
  final int id;
  final int? postmanId;
  final String username;

  final String nickname;
  final String email;
  final String phone;

  final int likeNum;
  final int dislikeNum;

  const User(
      {required this.id,
      required this.username,
      required this.nickname,
      required this.email,
      required this.phone,
      this.postmanId,
      this.likeNum = 0,
      this.dislikeNum = 0});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['name'],
        nickname: json['nickname'],
        email: json['email'],
        phone: json['phone'],
        id: json['id'],
        postmanId: json['courierId'],
        likeNum: json['likeNum'],
        dislikeNum: json['dislikeNum']);
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
