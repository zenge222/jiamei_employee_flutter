//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:jmyg_app/model/home_list_model.dart';
//import 'package:jmyg_app/model/user_info_model.dart';
//import 'package:jmyg_app/services/service_method.dart';
//
//class UserInfoProvide with ChangeNotifier {
//  String baseUrl;
//  String shopName;
//  String levelName;
//  String headImg;
//  String phone;
//  String nickname;
//  String truename;
////  List<ListItem> lists;
//
//  // 改变状态用于获取数据
//  changeHeadImg(String pic) {
//    headImg = pic;
//    notifyListeners();
//  }
//  changeTrueName(String name) {
//    nickname = name;
//    notifyListeners();
//  }
//  getUserInfoData() async {
//    await getRequest("employeeInfo").then((val) {
//      UserInfoModel userInfoModel =
//          UserInfoModel.fromJson(json.decode(val.toString()));
////      print(val);
//      if (userInfoModel.success) {
//        baseUrl = userInfoModel.data.filePath;
//        shopName = userInfoModel.data.shopName;
//        truename = userInfoModel.data.truename;
//        nickname = userInfoModel.data.nickname;
//        phone = userInfoModel.data.phone;
//        levelName = userInfoModel.data.levelName;
//        headImg = userInfoModel.data.filePath + userInfoModel.data.headImg;
//      }
//      notifyListeners();
//    });
//  }
//
////  getHomeList({int pageSize = 20, int pageNumber = 1}) async {
////    await getRequest("homeList",
////            joint: '?pageSize=${pageSize}&pageNumber=${pageNumber}')
////        .then((val) {
////      HomeList homeList =
////          HomeList.fromJson(json.decode(val.toString()));
////      if(homeList.success){
////        lists = homeList.data.list;
////      }
////    });
////  }
//}
