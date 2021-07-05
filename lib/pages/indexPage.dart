import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/pages/homePage.dart';
import 'package:jiamei_employee_flutter/pages/myPage.dart';
import 'package:jiamei_employee_flutter/pages/workbenchPage.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomTabs = [];
  List<Widget> tabBodies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: ColorUtil.color('#333333'),
        unselectedFontSize: ScreenUtil().setSp(20.0),
        selectedItemColor: ColorUtil.color('#F87E20'),
        //Color(0xFFCF2519),
        selectedFontSize: ScreenUtil().setSp(20.0),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initBottomBar();
  }

  initBottomBar() {
    tabBodies = [HomePage(), WorkbenchPage(), MyPage()];
    bottomTabs = [
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Image.asset(
            'lib/images/icons/home.png',
            width: ScreenUtil().setWidth(48),
          ),
          activeIcon: Image.asset('lib/images/icons/home_active.png',
              width: ScreenUtil().setWidth(48)),
          title: Text("首页")),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Image.asset(
            'lib/images/icons/workbench.png',
            width: ScreenUtil().setWidth(48),
          ),
          activeIcon: Image.asset('lib/images/icons/workbench_active.png',
              width: ScreenUtil().setWidth(48)),
          title: Text("工作台")),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Image.asset(
            'lib/images/icons/my.png',
            width: ScreenUtil().setWidth(48),
          ),
          activeIcon: Image.asset('lib/images/icons/my_active.png',
              width: ScreenUtil().setWidth(48)),
          title: Text("我的")),
    ];
  }
}
