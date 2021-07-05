import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/PickerLocalizationsDelegate.dart';
import 'package:jiamei_employee_flutter/common/splash.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/router/Routers.dart';
import 'package:provide/provide.dart';

void main() async {
  // unApp()调用之前,手动调用 models
  WidgetsFlutterBinding.ensureInitialized();
  AmapCore.init('fa832e17c782e44541dc780aca9a69d7');
  var providers = Providers();
  runApp(ProviderNode(child: MyApp(), providers: providers));
  ///状态栏透明
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,

    ///这是设置状态栏的图标和字体的颜色
    ///Brightness.light  一般都是显示为白色
    ///Brightness.dark 一般都是显示为黑色
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///初始化路由
    final router = FluroRouter();

    ///注册各个路由
    Routers.configureRouters(router);

    ///赋值到静态对象方便调用
    Application.router = router;
    return MaterialApp(
      /* debug的图标 */
      debugShowCheckedModeBanner: false,
      title: '嘉美员工端',
      /* 多语言代理 */
      localizationsDelegates: [
        PickerLocalizationsDelegate.delegate, // 如果要使用本地化，请添加此行，则可以显示中文按钮
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        /* 当键盘显示 是否重新布局来避免底部被覆盖 默认值为 true */
        resizeToAvoidBottomPadding: false,
        body: SplashPage(),
      ),
    );
  }
}
