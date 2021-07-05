import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.color('#ffffff'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '关于',
          style: TextStyle(color: ColorUtil.color('#333333')),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        // 设置状态栏字体颜色 一般有Brightness.dark,和Brightness.light两种模式
        elevation: 0,
        // 默认是4， 设置成0 就是没有阴影了
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(108)),
                child: Column(
                  children: <Widget>[
                    Image.asset('lib/images/login_logo.png',width: ScreenUtil().setWidth(144),),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(0),
                          ScreenUtil().setHeight(60),
                          ScreenUtil().setWidth(0),
                          ScreenUtil().setHeight(28)),
                      child: Image.asset('lib/images/login_text.png',width: ScreenUtil().setWidth(262),),
                    ),
                    Text('V1.0.0', style: TextStyle(
                      color: ColorUtil.color('#333333'),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(32),
                    ))
                  ],
                ),
              )),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('官方网站',
                    style: TextStyle(
                      color: ColorUtil.color('#aaaaaa'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(12),
                      bottom: ScreenUtil().setHeight(16)),
                  child: Text('www.jiameirl.com',
                      style: TextStyle(
                        color: ColorUtil.color('#F87E20'),
                        fontSize: ScreenUtil().setSp(32),
                      )),
                ),
                Text('嘉美美家 版权所有',
                    style: TextStyle(
                      color: ColorUtil.color('#666666'),
                      fontSize: ScreenUtil().setSp(24),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
