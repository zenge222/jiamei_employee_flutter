import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/models/codeRes.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/router/Routers.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ComPageWidget {
  RegExp reg = new RegExp(
      '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
  String phoneNumber = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true
        resizeToAvoidBottomPadding: false,
        backgroundColor: ColorUtil.color('#ffffff'),
        body: LoadingPage(
          isLoading: isLoading,
          child: Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(120),
                  ScreenUtil().setHeight(236),
                  ScreenUtil().setWidth(120),
                  ScreenUtil().setHeight(72)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Image.asset(
                        'lib/images/login_logo.png',
                        width: ScreenUtil().setWidth(144),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(262),
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(60),
                            bottom: ScreenUtil().setHeight(100)),
                        child: Image.asset(
                          'lib/images/login_text.png',
                        ),
                      ),

                      /// 手机号码
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(0),
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(0)),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorUtil.color('#EAEAEA'),
                              width: ScreenUtil().setWidth(1)),
                          color: ColorUtil.color('#F4F4F5'),
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(44))),
                        ),
                        child: TextField(
                          onChanged: (text) {
                            phoneNumber = text;
                          },
                          keyboardType:  TextInputType.number,// 只能弹出数字键盘
                          inputFormatters: <TextInputFormatter>[
//                            WhitelistingTextInputFormatter.digitsOnly,  // 可以输入特殊字符等
                            LengthLimitingTextInputFormatter(11) //限制长度
                          ],
                          decoration: InputDecoration(
                            icon: Container(
                                padding: EdgeInsets.all(0),
                                child: Image.asset(
                                  'lib/images/icons/home_icon.png',
                                  width: ScreenUtil().setWidth(40),
                                )),
                            contentPadding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(0),
                                ScreenUtil().setHeight(0),
                                ScreenUtil().setWidth(0),
                                ScreenUtil().setHeight(0)),
                            hintText: "请输入手机号",
                            hintStyle: TextStyle(
                                color: ColorUtil.color('#999999'),
                                fontSize: ScreenUtil().setSp(28)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: ColorUtil.color('#EAEAEA'),
                              width: ScreenUtil().setWidth(0),
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: ColorUtil.color('#F4F4F5'),
                              width: ScreenUtil().setWidth(2),
                            )),
                          ),
                        ),
                      ),

                      /// 获取验证码
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(500)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0.0, 6.0),
                                color: Color.fromRGBO(255, 114, 5, 0.23),
                                //阴影默认颜色,不能与父容器同时设置color
                                blurRadius:
                                    ScreenUtil().setHeight(20.0), //延伸距离,会有模糊效果
                              )
                            ]),
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(0),
                              ScreenUtil().setHeight(20),
                              ScreenUtil().setWidth(0),
                              ScreenUtil().setHeight(20)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(60))),
                          color: ColorUtil.color('#F87E20'),
                          child: Text('获取短信验证码',
                              style: TextStyle(
                                color: ColorUtil.color('#ffffff'),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(32),
                              )),
                          onPressed: () {
                            _getCode();
                          },
                        ),
                      )
                    ],
                  )),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '登录代表您已同意嘉美美家',
                        style: TextStyle(
                          color: ColorUtil.color('#666666'),
                          fontSize: ScreenUtil().setSp(24),
                        )),
                    TextSpan(
                        text: '用户协议、隐私协议',
                        style: TextStyle(
                          color: ColorUtil.color('#F87E20'),
                          fontSize: ScreenUtil().setSp(24),
                        )),
                  ])),
                ],
              ),
            ),
          ),
        ));
  }

  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  Future _getCode() async {
    if (phoneNumber == "") {
      return showToast("请输入手机号");
    }
    if (!isChinaPhoneLegal(phoneNumber)) {
      return showToast("请输入正确的手机号");
    }
    setState(() {
      isLoading = true;
    });
    await getRequest("getPhoneCode", context, joint: '/${phoneNumber}')
        .then((res) {
      print(res);
      CodeRes resp = CodeRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          isLoading = false;
        });
        showToast('验证码发送成功');
        Application.router.navigateTo(
            context, Routers.codePage + '?phone=${phoneNumber}',
            transition: TransitionType.inFromRight);
      } else {
        setState(() {
          isLoading = false;
        });
        showToast(resp.message);
      }
    });
  }
}
