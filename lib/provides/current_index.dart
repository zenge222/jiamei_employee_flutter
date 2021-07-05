// 底部导航当前位置
import 'package:flutter/material.dart';

class CurrentIndexProvide with ChangeNotifier{
  int currentIndex=0;
  changeIndex(int newIndex){
    currentIndex=newIndex;
    notifyListeners();
  }
}