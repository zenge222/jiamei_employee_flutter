//// 用户登录判断
//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:jmyg_app/services/service_method.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//class LoginStateProvide with ChangeNotifier {
//  int isLogin = 0;
//  changeLogin(int loginState) {
//    isLogin = loginState;
//    notifyListeners();
//  }
//
//  getLoginState(BuildContext context) async {
//    SharedPreferences prfs = await SharedPreferences.getInstance();
//    String tokenStr = prfs.getString("token");
//    String phoneStr = prfs.getString("phone");
//    String pswStr = prfs.getString("password");
//
//    if (tokenStr != null &&
//        tokenStr != '' &&
//        phoneStr != null &&
//        pswStr != null &&
//        pswStr != '' &&
//        phoneStr != '') {
//      await postRequest("login",
//          formData: {'phone': phoneStr, 'password': pswStr}).then((val) {
//        var backdata = json.decode(val.toString());
//        if (backdata['success']) {
//          isLogin = 1;
//          prfs.setString("organizationId", backdata['data']['organizationId']);
//        } else {
//          isLogin = -1;
//        }
//        // print("登录数据判断=================>");
//        notifyListeners();
//      });
//    } else {
//      isLogin = -2;
//      notifyListeners();
//    }
//  }
//}
