import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/router/Routers.dart';
import 'package:jiamei_employee_flutter/utils/SharedPreferencesUtil.dart';

class SetUpPage extends StatefulWidget {
  @override
  _SetUpPageState createState() => _SetUpPageState();
}

class _SetUpPageState extends State<SetUpPage> with ComPageWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '设置',
          style: TextStyle(color: ColorUtil.color('#333333')),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        // 设置状态栏字体颜色 一般有Brightness.dark,和Brightness.light两种模式
        elevation: 0,
        // 默认是4， 设置成0 就是没有阴影了
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(8))),
                    ),
                    margin: EdgeInsets.all(
                      ScreenUtil().setWidth(24),
                    ),
                    padding: EdgeInsets.all(
                      ScreenUtil().setWidth(32),
                    ),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Application.router.navigateTo(context, Routers.userAgreementPage,
                                transition: TransitionType.inFromRight);
                          },
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text('用户协议',style: TextStyle(
                                color: ColorUtil.color('#333333'),
                                fontSize: ScreenUtil().setSp(32),
                              ))),
                              Image.asset(
                                'lib/images/icons/my_right_icon.png',
                                width: ScreenUtil().setWidth(28),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Application.router.navigateTo(context, Routers.aboutUsPage,
                                transition: TransitionType.inFromRight);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Text('关于',style: TextStyle(
                                  color: ColorUtil.color('#333333'),
                                  fontSize: ScreenUtil().setSp(32),
                                ))),
                                Image.asset(
                                  'lib/images/icons/my_right_icon.png',
                                  width: ScreenUtil().setWidth(28),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(24),
                  ScreenUtil().setHeight(24),
                  ScreenUtil().setWidth(24),
                  ScreenUtil().setHeight(24)),
              child: FlatButton(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(0),
                    ScreenUtil().setHeight(20),
                    ScreenUtil().setWidth(0),
                    ScreenUtil().setHeight(20)),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(8))),
                color: ColorUtil.color('#ffffff'),
                child: Text('退出登录',
                    style: TextStyle(
                      color: ColorUtil.color('#F87E20'),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(32),
                    )),
                onPressed: () {
                  showCustomDialog(context, '确定退出', () {
                    SharedPreferencesUtil.clear();
                    Application.router.navigateTo(context, '/login',
                        transition: TransitionType.inFromLeft,
                        clearStack: true);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
