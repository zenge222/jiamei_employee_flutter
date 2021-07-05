import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:jiamei_employee_flutter/common/login.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/router/Routers.dart';
import 'package:jiamei_employee_flutter/utils/SharedPreferencesUtil.dart';
class SplashPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage>{

  bool showIndex = false;
  int _countdownTime = 2;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(750, 1334));
    return     Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorUtil.color('#CF241C'),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/images/splash_bg.png'),
        ),
      ),
      child: Column(
        children: <Widget>[
          Expanded(child: Text('')),
          Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
            child: Text(
              '嘉美美家 · 您家庭生活的伙伴',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(24), color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
    /// 延时任务
    Future.delayed(Duration(seconds: 1), () {
      SharedPreferencesUtil.getToken().then((token) {
        if (token != null && token != '') {
          Application.router.navigateTo(
              context, Routers.indexPage,
              transition: TransitionType.inFromRight, clearStack: true);
        } else {
          Application.router.navigateTo(context, '/login',
              clearStack: true, transition: TransitionType.inFromRight);
        }
      });
    });
  }


  void _startCountdownTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownTime == 0) {
        setState(() {
          showIndex = true;
        });
        _timer.cancel();
        return;
      }
      _countdownTime--;
      setState(() {
        _countdownTime = _countdownTime;
      });
    });

  }
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

}