import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:jiamei_employee_flutter/config/service_url.dart';
import 'package:jiamei_employee_flutter/provides/sms_token.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/router/Routers.dart';
import 'package:jiamei_employee_flutter/utils/SharedPreferencesUtil.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

// post请求
Future postRequest(url, BuildContext context,
    {formData, String joint = ''}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenStr = prefs.getString("token");
    if (tokenStr == null) tokenStr = "";

    Response response;

    Dio dio = new Dio();
    if (formData == null) {
      response = await dio.post(servicePath[url] + joint,
          // 通过传递一个 `options`来创建dio实例
          options: new Options(
              responseType: ResponseType.plain,
              contentType:
                  ContentType.parse("application/x-www-form-urlencoded")
                      .toString(),
              headers: {"Authorization": tokenStr, 'jsontype': 'jsontype'}));
    } else {
      print(servicePath[url] + joint);
      response = await dio.post(servicePath[url] + joint,
          data: formData,
          options: new Options(
              responseType: ResponseType.plain,
              contentType: ContentType.parse("application/json").toString(),
              headers: {"Authorization": tokenStr, 'jsontype': 'jsontype'}));
    }

    if (response.headers['Authorization'] != null &&
        response.headers['Authorization'].length > 0) {
      prefs.setString("token", response.headers['Authorization'][0]);
    }

    if (response.statusCode == 200) {
      /// 401 token失效
      if (json.decode(response.data)['code'] == 401) {
        SharedPreferencesUtil.clear();
        Application.router.navigateTo(context, Routers.loginPage,
            transition: TransitionType.inFromRight, clearStack: true);
      }
      return response.data;
    } else {
      throw Exception("后台接口异常");
    }
  } catch (e) {
    return print("发生错误：error:=======>${e}");
  }
}

// get请求
Future getRequest(url, BuildContext context, {String joint = ''}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenStr = prefs.getString("token");
    if (tokenStr == null) tokenStr = "";
    Response response;
    // https://www.jianshu.com/p/1352351c7d08
    // 请求参数也可以通过对象传递，esponse=await dio.get("/test?id=12&name=wendu") 等同于 response=await dio.get("/test",data:{"id":12,"name":"wendu"})
    Dio dio = new Dio(); // 使用默认配置
    // 配置dio实例
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded").toString();
    dio.options.connectTimeout = 5000; // 连接超时
    dio.options.receiveTimeout = 3000; // 接受超时
    var parse = ContentType.parse("application/x-www-form-urlencoded");
    print(servicePath[url] + joint);
    response = await dio.get(servicePath[url] + joint,
        options: new Options(
            responseType: ResponseType.plain,
            contentType: parse.toString(),
            headers: {"Authorization": tokenStr, 'jsontype': 'jsontype'}
            // contentType:ContentType.parse("application/x-www-form-urlencoded"),
            ));
//    print(response);

    if (response.statusCode == 200) {
      /// 401 token失效
      if (json.decode(response.data)['code'] == 401) {
        SharedPreferencesUtil.clear();
        Application.router.navigateTo(context, Routers.loginPage,
            transition: TransitionType.inFromRight, clearStack: true);
      }
      return response.data;
    } else {
      throw Exception("后台接口异常");
    }
  } catch (e) {
    return print("error:=======>${e}");
  }
}

// put请求
Future putRequest(url, BuildContext context, {String joint = ''}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenStr = prefs.getString("token");
    if (tokenStr == null) tokenStr = "";
    Response response;
    // https://www.jianshu.com/p/1352351c7d08
    // 请求参数也可以通过对象传递，esponse=await dio.get("/test?id=12&name=wendu") 等同于 response=await dio.get("/test",data:{"id":12,"name":"wendu"})
    Dio dio = new Dio(); // 使用默认配置
    // 配置dio实例
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded").toString();
    dio.options.connectTimeout = 5000; // 连接超时
    dio.options.receiveTimeout = 3000; // 接受超时
    var parse = ContentType.parse("application/x-www-form-urlencoded");
    print(servicePath[url] + joint);
    response = await dio.put(servicePath[url] + joint,
        options: new Options(
            method: "put",
            responseType: ResponseType.plain,
            contentType: parse.toString(),
            headers: {"Authorization": tokenStr, 'jsontype': 'jsontype'}
            // contentType:ContentType.parse("application/x-www-form-urlencoded"),
            ));

    if (response.statusCode == 200) {
      /// 401 token失效
      if (json.decode(response.data)['code'] == 401) {
        SharedPreferencesUtil.clear();
        Application.router.navigateTo(context, Routers.loginPage,
            transition: TransitionType.inFromRight, clearStack: true);
      }
      return response.data;
    } else {
      throw Exception("后台接口异常");
    }
  } catch (e) {
    return print("error:=======>${e}");
  }
}

// 发送短信
Future sendSms(
    {formData, String timestamp, String phone, BuildContext context}) async {
  try {
    Response response;
    Dio dio = new Dio();
    String lastNumber = phone.substring(phone.length - 4);

    print(lastNumber);

    String temp1 = md5.convert(utf8.encode("${timestamp}${phone}")).toString();
    String temp2 =
        md5.convert(utf8.encode("${timestamp}${lastNumber}")).toString();

    String cipher = md5
        .convert(utf8.encode("${temp1 + timestamp + temp2 + phone}"))
        .toString();
    response = await dio.post(servicePath['sendSms'],
        data: formData,
        options: new Options(
            contentType: ContentType.parse("application/x-www-form-urlencoded")
                .toString(),
            headers: {"cipher": cipher}));

    if (response.headers['smstoken'] != null &&
        response.headers['smstoken'].length > 0) {
      Provide.value<SmsTokenProvide>(context)
          .changeToken(response.headers['smstoken'][0].toString());
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("后台接口异常");
    }
  } catch (e) {
    return print("error:=======>${e}");
  }
}

// 注册
Future register({formData, BuildContext context}) async {
  try {
    Response response;
    Dio dio = new Dio();
    String smstoken = Provide.value<SmsTokenProvide>(context).smstoken;

    response = await dio.post(servicePath['register'],
        data: formData,
        options: new Options(
            contentType: ContentType.parse("application/x-www-form-urlencoded")
                .toString(),
            headers: {"smstoken": smstoken}));
    if (response.headers['Authorization'] != null &&
        response.headers['Authorization'].length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", response.headers['Authorization'][0]);
    }

    Provide.value<SmsTokenProvide>(context).changeToken("");
    if (response.statusCode == 200) {
      return json.decode(response.data);
    } else {
      throw Exception("后台接口异常");
    }
  } catch (e) {
    return print("error:=======>${e}");
  }
}

// 文件上传
Future uploadFile(url, BuildContext context, File file,
    {Function sendProgress}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenStr = prefs.getString("token");
    if (tokenStr == null) tokenStr = "";
    String path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap(
        {"multipartFile": await MultipartFile.fromFile(path, filename: name)});
    Dio dio = new Dio();
    var response = await dio.post<String>(servicePath[url],
        options: new Options(responseType: ResponseType.plain,
//        contentType:
//        ContentType.parse("application/x-www-form-urlencoded")
//            .toString(),
            headers: {"Authorization": tokenStr, 'jsontype': 'jsontype'}),
        data: formData, onSendProgress: (int sent, int total) {
      sendProgress(sent, total);
    });
    if (response.statusCode == 200) {
      if (json.decode(response.data)['code'] == 401) {
        SharedPreferencesUtil.clear();
        Application.router.navigateTo(context, Routers.loginPage,
            transition: TransitionType.inFromRight, clearStack: true);
      }
      return json.decode(response.data);
    } else {
      throw Exception("后台接口异常");
    }
  } catch (e) {
    return print("error:=======>${e}");
  }
}

// 图片上传
Future uploadFilePic(url, BuildContext context, String filePath) async {
  Dio dio = new Dio();

  ///请求option
  Map<String, dynamic> headerMap = new Map();
  String token = await SharedPreferencesUtil.getToken();
  headerMap['Authorization'] = token;
  Options option =
      new Options(responseType: ResponseType.plain, headers: headerMap);

  try {
    var name =
        filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
    FormData formData = FormData.fromMap({
      "multipartFile": await MultipartFile.fromFile(filePath, filename: name)
    });
    print(servicePath[url] + url);
    print('filePath:' + filePath);
    var response = await dio.post<String>(servicePath[url],
        data: formData, options: option);
    if (response.statusCode == 200) {
      if (json.decode(response.data)['code'] == 401) {
        SharedPreferencesUtil.clear();
        Application.router.navigateTo(context, Routers.loginPage,
            transition: TransitionType.inFromRight, clearStack: true);
      }
      return response.data;
    } else {
      throw Exception("后台接口异常");
    }
  } catch (e) {
    return print("error:=======>${e}");
  }
}

/*

  /// https://www.jianshu.com/p/1352351c7d08
  {
  /// Http method.
  String method;

  /// 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
  String baseUrl;

  /// Http请求头.
  Map<String, dynamic> headers;

  /// 连接服务器超时时间，单位是毫秒.
  int connectTimeout;

  ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
  ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
  ///  注意: 这并不是接收数据的总时限.
  int receiveTimeout;

  /// 请求数据,可以是任意类型.
  var data;

  /// 请求路径，如果 `path` 以 "http(s)"开始, 则 `baseURL` 会被忽略； 否则,
  /// 将会和baseUrl拼接出完整的的url.
  String path="";

  /// 请求的Content-Type，默认值是[ContentType.JSON].
  /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
  /// 可以设置此选项为 `ContentType.parse("application/x-www-form-urlencoded")`,  这样[Dio]
  /// 就会自动编码请求体.
  ContentType contentType;

  /// [responseType] 表示期望以那种格式(方式)接受响应数据。
  /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
  ///
  /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
  /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
  ///
  /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
  ResponseType responseType;

  /// `validateStatus` 决定http响应状态码是否被dio视为请求成功， 返回`validateStatus`
  ///  返回`true` , 请求结果就会按成功处理，否则会按失败处理.
  ValidateStatus validateStatus;

  /// 用户自定义字段，可以在 [Interceptor]、[Transformer] 和 [Response] 中取到.
  Map<String, dynamic> extra;
}

{
  /// 响应数据，可能已经被转换了类型, 详情请参考Options中的[ResponseType].
  var data;
  /// 响应头
  HttpHeaders headers;
  /// 本次请求信息
  Options request;
  /// Http status code.
  int statusCode;
  /// 响应对象的自定义字段（可以在拦截器中设置它），调用方可以在`then`中获取.
  Map<String, dynamic> extra;
}

 dio.interceptor.request.onSend = (Options options){
     // 在请求被发送之前做一些事情
     return options; //continue
     // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
     // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
     //
     // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
     // 这样请求将被中止并触发异常，上层catchError会被调用。
 }
 dio.interceptor.response.onSuccess = (Response response) {
     // 在返回响应数据之前做一些预处理
     return response; // continue
 };
 dio.interceptor.response.onError = (DioError e){
     // 当请求失败时做一些预处理
     return e;//continue
 }

  移除拦截器
  dio.interceptor.request.onSend=null;
  dio.interceptor.response.onSuccess=null;
  dio.interceptor.response.onError=null;


*/
