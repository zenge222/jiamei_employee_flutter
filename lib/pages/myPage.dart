import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/models/userInfoRes.dart';
import 'package:jiamei_employee_flutter/pages/feedbackPage.dart';
import 'package:jiamei_employee_flutter/pages/feedbackPage.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/router/Routers.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with ComPageWidget {
  UserInfo resData;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '我的',
          style: TextStyle(color: ColorUtil.color('#333333')),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        // 设置状态栏字体颜色 一般有Brightness.dark,和Brightness.light两种模式
        elevation: 0,
        // 默认是4， 设置成0 就是没有阴影了
        backgroundColor: Colors.white,
      ),
      body: LoadingPage(
        isLoading: isLoading,
        child: Column(
          children: <Widget>[
            /// 头部信息
            resData != null
                ? Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(0),
                        ScreenUtil().setHeight(68),
                        ScreenUtil().setWidth(0),
                        ScreenUtil().setHeight(70)),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/images/my_bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            '${resData.avatar}',
                            width: ScreenUtil().setWidth(140),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30)),
                            child: Text('${resData.name}',
                                style: TextStyle(
                                  color: ColorUtil.color('#ffffff'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(40),
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(16),
                                ScreenUtil().setHeight(3),
                                ScreenUtil().setWidth(16),
                                ScreenUtil().setHeight(3)),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.29),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(20))),
                            ),
                            width: ScreenUtil().setWidth(208),
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(16)),
                            child: Text('${resData.mobile}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorUtil.color('#ffffff'),
                                  fontSize: ScreenUtil().setSp(28),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(16)),
                            child: Text('${resData.storeName}',
                                style: TextStyle(
                                  color: ColorUtil.color('#ffffff'),
                                  fontSize: ScreenUtil().setSp(28),
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                : Text(''),

            /// cards
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(24),
                  ScreenUtil().setHeight(40),
                  ScreenUtil().setWidth(24),
                  ScreenUtil().setHeight(40)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
              ),
              child: Column(
                children: <Widget>[
                  /// 意见反馈
                  GestureDetector(
                    // FeedbackPage
                    onTap: () {
                      Application.router.navigateTo(
                          context, Routers.feedbackPage,
                          transition: TransitionType.inFromRight);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(32),
                          ScreenUtil().setHeight(40),
                          ScreenUtil().setWidth(32),
                          ScreenUtil().setHeight(40)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10)),
                            child: Image.asset(
                              'lib/images/icons/feedback_icon.png',
                              width: ScreenUtil().setWidth(40),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16)),
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(40)),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: ScreenUtil().setWidth(1),
                                        color: ColorUtil.color('#EEEEEE')))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('意见反馈',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontSize: ScreenUtil().setSp(36),
                                    )),
                                Image.asset(
                                  'lib/images/icons/my_right_icon.png',
                                  width: ScreenUtil().setWidth(32),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),

                  /// 设置
                  GestureDetector(
                    onTap: () {
                      Application.router.navigateTo(context, Routers.setUpPage,
                          transition: TransitionType.inFromRight);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(32),
                          ScreenUtil().setHeight(0),
                          ScreenUtil().setWidth(32),
                          ScreenUtil().setHeight(0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10)),
                            child: Image.asset(
                              'lib/images/icons/set_up_icon.png',
                              width: ScreenUtil().setWidth(40),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16)),
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(40)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('设置',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontSize: ScreenUtil().setSp(36),
                                    )),
                                Image.asset(
                                  'lib/images/icons/my_right_icon.png',
                                  width: ScreenUtil().setWidth(32),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    _getUserInfo();
  }

  Future _getUserInfo() async {
    await getRequest("userInfo", context).then((res) {
      UserInfoRes resp = UserInfoRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          isLoading = false;
          resData = resp.data;
        });
      } else {
        showToast(resp.message);
      }
    });
  }
}
