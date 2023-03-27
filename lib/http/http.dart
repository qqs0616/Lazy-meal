import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../common/index.dart';
import '../untils/index.dart';
import 'index.dart';

class HttpService {
  Dio? dio;
  Response<dynamic>? response;
  static final instance = HttpService._internal();

  factory HttpService.getInstance() => instance;

  HttpService._internal() {
    if (dio == null) {
      BaseOptions baseOptions = BaseOptions(
          baseUrl: baseUrl,
          //连接服务器超时时间
          connectTimeout: 10000,
          //距离上次接收到数据间隔时间
          receiveTimeout: 5000,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json);
      dio ??= Dio(baseOptions);
      //拦截器
      dio!.interceptors.add(InterceptorsWrapper(
          // onRequest: (RequestOptions options, _) => options,
          // onResponse: (Response response, _) => response,
          onError: (DioError e, _) {
        //根据dio错误，拿到错误
        ErrorEntity errorEntity = ErrorEntity.createErrorEntity(e);
        //错误提示
        toastInfo(msg: errorEntity.message ?? "");
        return;
      }));
    }
  }

  Future get({String? path, dynamic queryParameters}) async {
    EasyLoading.show(status: "Loading...");
    Options? options = setToken();
    response = await dio?.get(path!,
        options: options, queryParameters: queryParameters);
    debugPrint(response!.data.toString());
    EasyLoading.dismiss();
    return response!.data;
  }

  Future post({required String path, Options? options, var data}) async {
    Options? options = setToken();
    response = await dio?.post(path, data: data, options: options);
    debugPrint(response!.data.toString());
    return response!.data;
  }

  Future put(
      {required String path,
      Options? options,
      Map<String, dynamic>? data}) async {
    Options? options = setToken();
    response = await dio?.put(path, data: data, options: options);
    debugPrint(response!.data.toString());
    return response!.data;
  }

  Future delete(
      {required String path,
      Options? options,
      Map<String, dynamic>? data}) async {
    Options? options = setToken();
    response = await dio?.delete(path, data: data, options: options);
    debugPrint(response!.data.toString());
    return response!.data;
  }

  Options? setToken() {
    Options? options = Options();
    // if (UserService.to.hasToken) {
    //   options.headers = {"Authorization": UserService.to.token.value};
    // }
    return options;
  }
}
