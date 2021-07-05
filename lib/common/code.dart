import 'dart:async';
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_box/verification_box.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/models/codeRes.dart';
import 'package:jiamei_employee_flutter/models/index.dart';
import 'package:jiamei_employee_flutter/models/loginRes.dart';
import 'package:jiamei_employee_flutter/models/loginVo.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/router/Routers.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';
import 'package:jiamei_employee_flutter/utils/SharedPreferencesUtil.dart';

class CodePage extends StatefulWidget {
  final String phone;

  const CodePage({Key key, this.phone}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> with ComPageWidget {
  Timer _timer; // 计时
  int _countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: ColorUtil.color('#ffffff'),
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
          title: Text(
            '',
            style: TextStyle(color: ColorUtil.color('#333333')),
          ),
          centerTitle: true,
          // 设置状态栏字体颜色 一般有Brightness.dark,和Brightness.light两种模式
          brightness: Brightness.light,
          //默认是4， 设置成0 就是没有阴影了
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(56),
              ScreenUtil().setHeight(60),
              ScreenUtil().setWidth(56),
              ScreenUtil().setHeight(0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('请输入验证码',
                  style: TextStyle(
                      color: ColorUtil.color('#333333'),
                      fontSize: ScreenUtil().setSp(56),
                      fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: '验证码已发送至 ',
                      style: TextStyle(
                        color: ColorUtil.color('#999999'),
                        fontSize: ScreenUtil().setSp(28),
                      )),
                  TextSpan(
                      text: widget.phone,
                      style: TextStyle(
                        color: ColorUtil.color('#333333'),
                        fontSize: ScreenUtil().setSp(28),
                      )),
                ])),
              ),

              /// 验证码
              Container(
                height: ScreenUtil().setHeight(80),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(120)),
                child: VerificationBox(
                  type: VerificationBoxItemType.underline,
                  textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(48),
                      fontWeight: FontWeight.bold),
                  onSubmitted: (value) {
                    _toLogin('${widget.phone}', '$value');
                  },
                ),
              ),

              /// 倒计时
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                child: _countdownTime > 0
                    ? RichText(
                        text: TextSpan(children: [
                        TextSpan(
                            text: '${_countdownTime}',
                            style: TextStyle(
                              color: ColorUtil.color('#F87E20'),
                              fontSize: ScreenUtil().setSp(28),
                            )),
                        TextSpan(
                            text: '秒后重新发送验证码',
                            style: TextStyle(
                              color: ColorUtil.color('#999999'),
                              fontSize: ScreenUtil().setSp(28),
                            )),
                      ]))
                    : GestureDetector(
                        onTap: () async {
                          setState(() {
                            _countdownTime = 60;
                          });
                          await getRequest("getPhoneCode", context,
                                  joint: '/${widget.phone}')
                              .then((res) {
                            CodeRes resp = CodeRes.fromJson(json.decode(res.toString()));
                            if (resp.code == 0) {
                              showToast('验证码发送成功');
                              //      //开始倒计时
                              _startCountdownTimer();
                            } else {
                              showToast(resp.message);
                            }
                          });
                        },
                        child: Text('重新发送',
                            style: TextStyle(
                              color: ColorUtil.color('#F87E20'),
                              fontSize: ScreenUtil().setSp(28),
                            )),
                      ),
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.phone);
    setState(() {
      _countdownTime = 60;
    });
    _startCountdownTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  ///倒计时
  void _startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer.cancel();
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  Future _toLogin(String phone, String code) async {
    await postRequest('employeeLogin', context, joint: '/${phone}/${code}')
        .then((res) {
      LoginRes resp = LoginRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        SharedPreferencesUtil.setToken(resp.data.token);
        SharedPreferencesUtil.setRefreshToken(resp.data.refreshToken);
        Application.router.navigateTo(context, Routers.indexPage,
            transition: TransitionType.inFromRight, clearStack: true);
      } else {
        showToast(resp.message);
      }
    });
  }
}
