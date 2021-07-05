// 底部导航当前位置
import 'package:flutter/material.dart';

class SmsTokenProvide with ChangeNotifier {
  String smstoken = "";
  changeToken(String newToken) {
    smstoken = newToken;
    notifyListeners();
  }
}
