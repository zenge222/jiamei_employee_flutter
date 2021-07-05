import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:jiamei_employee_flutter/common/code.dart';
import 'package:jiamei_employee_flutter/common/login.dart';
import 'package:jiamei_employee_flutter/common/splash.dart';
import 'package:jiamei_employee_flutter/pages/aboutUsPage.dart';
import 'package:jiamei_employee_flutter/pages/feedbackPage.dart';
import 'package:jiamei_employee_flutter/pages/goodsApply.dart';
import 'package:jiamei_employee_flutter/pages/homePage.dart';
import 'package:jiamei_employee_flutter/pages/indexPage.dart';
import 'package:jiamei_employee_flutter/pages/leaveApplication.dart';
import 'package:jiamei_employee_flutter/pages/massageList.dart';
import 'package:jiamei_employee_flutter/pages/messageDetail.dart';
import 'package:jiamei_employee_flutter/pages/myPage.dart';
import 'package:jiamei_employee_flutter/pages/serviceDetail.dart';
import 'package:jiamei_employee_flutter/pages/setUpPage.dart';
import 'package:jiamei_employee_flutter/pages/userAgreementPage.dart';
import 'package:jiamei_employee_flutter/pages/workingHours.dart';

///路由表
class Routers {
  static String root = "/";

  /// 入口
  static String indexPage = "/indexPage";

  /// 登录页
  static String loginPage = "/login";

  /// 验证码
  static String codePage = "/codePage";

  /// 首页
  static String homePage = "/homePage";

  /// 启动页
  static String splashPage = "/splash";

  /// 启动页
  static String serviceDetail = "/serviceDetail";

  /// 工时统计
  static String workingHours = "/WorkingHours";

  /// 请假
  static String leaveApplication = "/leaveApplication";

  /// 消息列表
  static String messageList = "/messageList";

  /// 消息详情
  static String messageDetail = "/messageDetail";

  /// 物品申领+列表
  static String goodsApply = "/goodsApply";

  /// 我的
  static String myPage = "/myPage";

  /// 意见反馈
  static String feedbackPage = "/feedbackPage";

  /// 设置
  static String setUpPage = "/setUpPage";

  /// 关于
  static String aboutUsPage = "/aboutUsPage";

  /// 用户协议
  static String userAgreementPage = "/userAgreementPage";

  static void configureRouters(FluroRouter router) {
    router.define(indexPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return IndexPage();
    }));
    router.define(splashPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return SplashPage();
    }));

    router.define(loginPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return LoginPage();
    }));

    router.define(messageList, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MessageList();
    }));

    router.define(myPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MyPage();
    }));

    router.define(feedbackPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return FeedbackPage();
    }));

    router.define(setUpPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return SetUpPage();
    }));

    router.define(workingHours, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return WorkingHours();
    }));

    router.define(leaveApplication, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return LeaveApplication();
    }));

    router.define(userAgreementPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return UserAgreementPage();
    }));

    router.define(aboutUsPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return AboutUsPage();
    }));

    router.define(goodsApply, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return GoodsApply();
    }));

    router.define(codePage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String phone = params['phone'].first;
      return CodePage(phone: phone);
    }));

    router.define(messageDetail, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      int id = int.parse(params['id'].first);
      return MessageDetail(id: id);
    }));

    router.define(serviceDetail, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      int id = int.parse(params['id'].first);
      int type = int.parse(params['type'].first);
      int orderType = int.parse(params['orderType'].first);
      return ServiceDetail(id: id, type: type,orderType:orderType);
    }));

    router.define(homePage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return HomePage();
    }));
  }
}
