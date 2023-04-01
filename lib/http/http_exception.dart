import 'package:dio/dio.dart';

enum ErrorType { connectTimeOut, sendTimeOut, response }

class HttpException implements Exception {
  final int code;
  final String msg;

  HttpException({this.code = 500, this.msg = "未知异常，请联系管理员"});

  @override
  String toString() {
    return 'HttpException{code: $code, msg: $msg}';
  }

  factory HttpException.create(ErrorType errorType,
      {required int code, String? msg}) {
    switch (errorType) {
      case ErrorType.connectTimeOut:
        return HttpException(code: code, msg: "连接超时");
      case ErrorType.sendTimeOut:
        return HttpException(code: code, msg: "请求超时");
      case ErrorType.response:
        switch (code) {
          case 400:
            return HttpException(code: code, msg: "请求语法错误");
          case 401:
            return HttpException(code: code, msg: "没有权限");
          case 403:
            return HttpException(code: code, msg: "服务器拒绝访问");
          case 404:
            return HttpException(code: code, msg: "无法连接服务器");
          case 500:
            return HttpException(code: code, msg: "服务器内部错误");
          case 502:
            return HttpException(code: code, msg: "无效的请求");
          case 503:
            return HttpException(code: code, msg: "服务器挂了");
          case 505:
            return HttpException(code: code, msg: "不支持HTTP协议请求");
          default:
            return HttpException(code: code, msg: "网络出现异常,请重试");
        }
      default:
        return HttpException(code: -1, msg: "未知异常，请联系管理员");
    }
  }
}

// 异常处理
class ErrorEntity implements Exception {
  int? code;
  String? message;

  ErrorEntity({this.code, this.message});

  String toString() {
    if (message == null) return "Exception";
    return "Exception: code $code, $message";
  }

  /*
   * error统一处理
   */
  // 错误信息
  factory ErrorEntity.createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return ErrorEntity(code: -1, message: "请求取消");
        }
        break;
      case DioErrorType.connectTimeout:
        {
          // return ErrorEntity(code: -1, message: "连接超时");
          return ErrorEntity(code: -1, message: "服务器停机更新中...");
        }
        break;
      case DioErrorType.sendTimeout:
        {
          return ErrorEntity(code: -1, message: "请求超时");
        }
        break;
      case DioErrorType.receiveTimeout:
        {
          return ErrorEntity(code: -1, message: "响应超时");
        }
        break;
      case DioErrorType.response:
        {
          try {
            int? errCode = error.response?.statusCode;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                {
                  return ErrorEntity(code: errCode, message: "请求语法错误");
                }
                break;
              case 401:
                {
                  return ErrorEntity(code: errCode, message: "没有权限");
                }
                break;
              case 403:
                {
                  return ErrorEntity(code: errCode, message: "服务器拒绝执行");
                }
                break;
              case 404:
                {
                  return ErrorEntity(code: errCode, message: "无法连接服务器");
                }
                break;
              case 405:
                {
                  return ErrorEntity(code: errCode, message: "请求方法被禁止");
                }
                break;
              case 500:
                {
                  // return ErrorEntity(code: errCode, message: "服务器内部错误");
                  return ErrorEntity(code: errCode, message: "服务器停机更新中...");
                }
                break;
              case 502:
                {
                  return ErrorEntity(code: errCode, message: "无效的请求");
                }
                break;
              case 503:
                {
                  return ErrorEntity(code: errCode, message: "服务器挂了");
                }
                break;
              case 505:
                {
                  return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
                }
                break;
              default:
                {
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  // return ErrorEntity(
                  //     code: errCode, message: error.response?.statusMessage);
                  return ErrorEntity(
                      code: errCode, message: "网络出小差了~,请检查网络后重试");
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "未知错误");
          }
        }
        break;
      default:
        {
          // return ErrorEntity(code: -1, message: error.message);
          return ErrorEntity(code: -1, message: "网络出小差了~,请检查网络后重试");
        }
    }
  }
}
