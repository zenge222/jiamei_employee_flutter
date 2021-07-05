import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAgreementPage extends StatefulWidget {
  @override
  _UserAgreementPageState createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends State<UserAgreementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.color('#ffffff'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '用户协议',
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
        margin: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(32),
            ScreenUtil().setHeight(80),
            ScreenUtil().setWidth(32),
            ScreenUtil().setHeight(0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: Text('用户协议',
                      style: TextStyle(
                        color: ColorUtil.color('#333333'),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(36),
                      ))),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('发布时间：2020年10月21日',
                        style: TextStyle(
                          color: ColorUtil.color('#333333'),
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(28),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child: Text('提示条款',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Text(
                    '为了您能更好的使用嘉美美家服务（以下简称：本服务），您应当阅读并遵守《嘉美美家服务协议》（以下简称:本协议）等相关协议、规则。',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              /// 条款
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child: Text('一、总则',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Text(
                    '1.1 嘉美美家的所有权和运营权归嘉美人力资源有限公司所有。',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Text(
                    '1.2 用户在注册之前，应当仔细阅读本协议，并同意遵守本协议后方可成为注册用户。一旦注册成功，则用户与嘉美美家之间自动形成协议关系，用户应当受本协议的约束。用户在使用特殊的服务或产品时，应当同意接受相关协议后方能使用。',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Text(
                    '1.3 本协议由嘉美美家随时更新，用户应当及时关注并同意本站不承担通知义务。本站的通知、公告、声明或其它类似内容是本协议的一部分。',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child: Text('二、定义条款',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Text(
                    '家庭服务：以家庭为主要服务对象，以家庭日常生活事务为主要服务内容，由家庭服务经营者提供的营利性服务活动。',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Text(
                    '嘉美美家：嘉美人力资源有限公司运营和管理的网络交易平台；本协议中，嘉美美家既指网络交易平台，亦包括嘉美人力资源有限公司。',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Text(
                    '用户：接受并同意本协议全部条款且具有完全民事行为能力的“嘉美美家”各项服务的使用者，即签订本协议并完成注册流程的会员。',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Text(
                    '商家：通过嘉美美家从事商业活动（发布商品、信息）的个人或其他组织。',
                    style: TextStyle(
                      color: ColorUtil.color('#555555'),
                      fontSize: ScreenUtil().setSp(28),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
