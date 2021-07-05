import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/models/messageCountRes.dart';
import 'package:jiamei_employee_flutter/pages/massageList.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/router/Routers.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';

class WorkbenchPage extends StatefulWidget {
  @override
  _WorkbenchPageState createState() => _WorkbenchPageState();
}

class _WorkbenchPageState extends State<WorkbenchPage> with ComPageWidget {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.color('#ffffff'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '工作台',
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
        isLoading: false,
        child: Column(
          children: <Widget>[
            Image.asset('lib/images/work_banner.png'),
            Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(100),
                  ScreenUtil().setHeight(120),
                  ScreenUtil().setWidth(100),
                  ScreenUtil().setHeight(0)),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// 工时统计
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Application.router.navigateTo(
                                context, Routers.workingHours,
                                transition: TransitionType.inFromRight);
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  'lib/images/icons/work_icon1.png',
                                  width: ScreenUtil().setWidth(120),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(16)),
                                  child: Text('工时统计',
                                      style: TextStyle(
                                          color: ColorUtil.color('#666666'),
                                          fontSize: ScreenUtil().setSp(32),
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// 消息
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
//                            Application.router.navigateTo(
//                                context, Routers.messageList,
//                                transition: TransitionType.inFromRight);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessageList(),
                                )).then((data) {
                             _getCount();
                            });
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Image.asset(
                                      'lib/images/icons/work_icon2.png',
                                      width: ScreenUtil().setWidth(120),
                                    ),
                                    count!=null?Positioned(
                                        left: ScreenUtil().setWidth(90),
                                        top: ScreenUtil().setHeight(-30),
                                        child: Offstage(
                                          offstage: count == 0,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(12),
                                                ScreenUtil().setHeight(2),
                                                ScreenUtil().setWidth(12),
                                                ScreenUtil().setHeight(2)),
                                            decoration: BoxDecoration(
                                              color: ColorUtil.color('#FF382D'),
                                              border: Border.all(
                                                  width:
                                                      ScreenUtil().setWidth(6),
                                                  color: ColorUtil.color(
                                                      '#ffffff')),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(100))),
                                            ),
                                            child: Center(
                                              child: Text('${count}',
                                                  style: TextStyle(
                                                    color: ColorUtil.color(
                                                        '#ffffff'),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        ScreenUtil().setSp(36),
                                                  )),
                                            ),
                                          ),
                                        )):Text('')
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(16)),
                                  child: Text('消息',
                                      style: TextStyle(
                                          color: ColorUtil.color('#666666'),
                                          fontSize: ScreenUtil().setSp(32),
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(120)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /// 请假
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Application.router.navigateTo(
                                  context, Routers.leaveApplication,
                                  transition: TransitionType.inFromRight);
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'lib/images/icons/work_icon3.png',
                                    width: ScreenUtil().setWidth(120),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(16)),
                                    child: Text('请假',
                                        style: TextStyle(
                                            color: ColorUtil.color('#666666'),
                                            fontSize: ScreenUtil().setSp(32),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// 物品申领
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Application.router.navigateTo(
                                  context, Routers.goodsApply,
                                  transition: TransitionType.inFromRight);
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'lib/images/icons/work_icon4.png',
                                    width: ScreenUtil().setWidth(120),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(16)),
                                    child: Text('物品申领',
                                        style: TextStyle(
                                            color: ColorUtil.color('#666666'),
                                            fontSize: ScreenUtil().setSp(32),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
    _getCount();
  }

  Future _getCount() async {
    await getRequest("unreadNotifyCount", context).then((res) {
      MessageCountRes resp =
          MessageCountRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          count = resp.count;
        });
      } else {
        showToast(resp.message);
      }
    });
  }
}
