import 'package:dio/dio.dart';
export 'package:dio/dio.dart';

/// global singleton request
class Request {
  static final Request _request = Request._internal();

  factory Request() {
    return _request;
  }

  Request._internal();

  final String serverAddress = "http://43.138.133.96:8080";
  // final String serverAddress = "http://120.79.207.158:8080";
  // final String serverAddress = "http://10.0.2.2:8080";

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) {
    return Dio().get<T>(serverAddress + path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  /// post request
  Future<Response<T>> post<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) {
    return Dio().post<T>(serverAddress + path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }
}
