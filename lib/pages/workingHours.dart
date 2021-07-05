import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/common/dottedLine.dart';
import 'package:jiamei_employee_flutter/common/resetPicker.dart';
import 'package:jiamei_employee_flutter/models/dateVO.dart';
import 'package:jiamei_employee_flutter/models/oneDayRes.dart';
import 'package:jiamei_employee_flutter/models/userInfoRes.dart';
import 'package:jiamei_employee_flutter/models/workDaysRes.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';

class WorkingHours extends StatefulWidget {
  @override
  _WorkingHoursState createState() => _WorkingHoursState();
}

class _WorkingHoursState extends State<WorkingHours> with ComPageWidget {
  List weeks = ["一", "二", "三", "四", "五", "六", "日"];
  String dateStr = '';
  DateTime currentDate = DateTime.now();
  List<DateVO> dateList = [];
  String currentDay = '';
  bool isLoading = false;
  WorkDate resData;
  UserInfo resUserData;
  List<OneDayListItem> resList = [];
  int serviceHours = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '工时统计',
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
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(24),
                ScreenUtil().setHeight(0),
                ScreenUtil().setWidth(24),
                ScreenUtil().setHeight(40)),
            child: Column(
              children: <Widget>[
                /// 头部
                resUserData != null
                    ? Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(24)),
                        padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(8))),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                              '${resUserData.avatar}',
                              width: ScreenUtil().setWidth(160),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(16),
                                  top: ScreenUtil().setWidth(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('${resUserData.name}',
                                      style: TextStyle(
                                        color: ColorUtil.color('#333333'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(36),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Text('${resUserData.storeName}',
                                        style: TextStyle(
                                          color: ColorUtil.color('#666666'),
                                          fontSize: ScreenUtil().setSp(28),
                                        )),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Text(''),

                /// sel
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: ScreenUtil().setWidth(180),
                          height: ScreenUtil().setHeight(2),
                          color: ColorUtil.color('#D5D5D5'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(22),
                            right: ScreenUtil().setWidth(22)),
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(28),
                            ScreenUtil().setHeight(7),
                            ScreenUtil().setWidth(16),
                            ScreenUtil().setHeight(7)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(100))),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            ResetPicker.showDatePicker(context,
                                dateType: DateType.YM,
                                clickCallback: (var str, var time) {
                              setState(() {
                                dateStr = str;
                                currentDate = DateTime.parse(time);
                              });
                              _getData();
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(4)),
                                child: Text('${dateStr}',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(40),
                                    )),
                              ),
                              Image.asset(
                                'lib/images/icons/sel_icon.png',
                                width: ScreenUtil().setWidth(40),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: ScreenUtil().setWidth(180),
                          height: ScreenUtil().setHeight(2),
                          color: ColorUtil.color('#D5D5D5'),
                        ),
                      )
                    ],
                  ),
                ),

                resData != null
                    ? Column(
                        children: <Widget>[
                          /// 工时
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(36)),
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(24),
                                ScreenUtil().setHeight(40),
                                ScreenUtil().setWidth(24),
                                ScreenUtil().setHeight(40)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(8))),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Column(
                                  children: <Widget>[
                                    Text('${resData.sumHour}',
                                        style: TextStyle(
                                            color: ColorUtil.color('#F87E20'),
                                            fontSize: ScreenUtil().setSp(48),
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(12)),
                                      child: Text('累计工时(小时)',
                                          style: TextStyle(
                                            color: ColorUtil.color('#666666'),
                                            fontSize: ScreenUtil().setSp(28),
                                          )),
                                    ),
                                  ],
                                )),
                                Container(
                                  width: ScreenUtil().setWidth(2),
                                  height: ScreenUtil().setHeight(60),
                                  color: ColorUtil.color('#D5D5D5'),
                                ),
                                Expanded(
                                    child: Column(
                                  children: <Widget>[
                                    Text('${resData.sumDay}',
                                        style: TextStyle(
                                            color: ColorUtil.color('#333333'),
                                            fontSize: ScreenUtil().setSp(48),
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(12)),
                                      child: Text('出勤天数',
                                          style: TextStyle(
                                            color: ColorUtil.color('#666666'),
                                            fontSize: ScreenUtil().setSp(28),
                                          )),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),

                          /// 日历
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(24)),
                            padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(8))),
                            ),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(8))),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(20)),
                                      child: Wrap(
                                          spacing: ScreenUtil().setWidth(38),
                                          //主轴上子控件的间距
                                          runSpacing:
                                              ScreenUtil().setHeight(38),
                                          //交叉轴上子控件之间的间距
                                          children: _buildWeeks(context)),
                                    ),
                                    Wrap(
                                        spacing: ScreenUtil().setWidth(38),
                                        //主轴上子控件的间距
                                        runSpacing: ScreenUtil().setHeight(38),
                                        //交叉轴上子控件之间的间距
                                        children: _buildDays(context))
                                  ],
                                )),
                          ),

                          /// 服务统计
                          resList.length > 0
                              ? Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(24)),
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setWidth(24)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(8))),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScreenUtil().setHeight(50)),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: '服务统计：今日时长  ',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#333333'),
                                                fontSize:
                                                    ScreenUtil().setSp(36),
                                              )),
                                          TextSpan(
                                              text: '${serviceHours}',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#F87E20'),
                                                fontSize:
                                                    ScreenUtil().setSp(36),
                                              )),
                                          TextSpan(
                                              text: '小时',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#333333'),
                                                fontSize:
                                                    ScreenUtil().setSp(36),
                                              )),
                                        ])),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: _workList(),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(24)),
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setWidth(24)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(8))),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScreenUtil().setHeight(50)),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: '服务统计：今日时长  ',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#333333'),
                                                fontSize:
                                                    ScreenUtil().setSp(36),
                                              )),
                                          TextSpan(
                                              text: '0',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#F87E20'),
                                                fontSize:
                                                    ScreenUtil().setSp(36),
                                              )),
                                          TextSpan(
                                              text: '小时',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#333333'),
                                                fontSize:
                                                    ScreenUtil().setSp(36),
                                              )),
                                        ])),
                                      ),
                                      Text('今日没有工作记录～',
                                          style: TextStyle(
                                            color: ColorUtil.color('#333333'),
                                            fontSize: ScreenUtil().setSp(28),
                                          ))
                                    ],
                                  ),
                                ),
                        ],
                      )
                    : Text('')
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dateTime = new DateTime.now();
    setState(() {
      isLoading = true;
      dateStr =
          '${dateTime.year}-${dateTime.month > 10 ? dateTime.month : '0${dateTime.month}'}';
    });
    _getUserInfo();
    _getData();
  }

  Future _getUserInfo() async {
    await getRequest("userInfo", context).then((res) {
      UserInfoRes resp = UserInfoRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          isLoading = false;
          resUserData = resp.data;
        });
      } else {
        showToast(resp.message);
      }
    });
  }

  Future _getData() async {
    await getRequest("monthTaskSum", context, joint: '?yearMonth=${dateStr}')
        .then((res) {
      print(res);
      WorkDaysRes resp = WorkDaysRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          isLoading = false;
          resData = resp.data;
        });
        _getDateTimeList();
      } else {
        showToast(resp.message);
      }
    });
  }

  void _changeDay(String day) async {
    setState(() {
      isLoading = true;
    });
    int count = 0;
    String date = dateStr + '-' + day;
    await getRequest("getTaskByDate", context, joint: '?yearMonthDay=${date}')
        .then((res) {
      OneDayRes resp = OneDayRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          isLoading = false;
          resList = resp.data;
        });
        resList.forEach((val) {
          if (val.status >= 3) {
            count += val.serviceHours;
          }
        });
        setState(() {
          serviceHours = count;
        });
      } else {
        showToast(resp.message);
      }
    });
  }

  _getDateTimeList() {
    List<DateVO> list = [];
    // 年份，随便哪一年
    int year = DateTime.now().year;
    int month = DateTime.now().month;

    /// 获取当月第一天星期
    int weekDay = DateTime(int.parse(dateStr.split('-')[0]), int.parse(dateStr.split('-')[1]), 1).weekday;
    for (int i = 1; i < weekDay; i++) {
      DateVO dateItem = new DateVO();
      dateItem.select = false;
      dateItem.date = 0;
      dateItem.state = -1;
      list.add(dateItem);
    }
    // 获取当月最后一天
    var dayCount = DateTime(year, month + 1, 0).day;
    print('$year' '年' '$month' '月:$dayCount' '天');
    for (int i = 0; i < dayCount; i++) {
      DateVO dateItem = new DateVO();
      dateItem.select = false;
      dateItem.date = i + 1;
      dateItem.state = 0;
      list.add(dateItem);
    }
    if (resData.serviceDateList.length > 0) {
      resData.serviceDateList.forEach((val) {
        List dateList = val.taskBegin.split('-');
        int day = int.parse(dateList[dateList.length - 1]);
        list.forEach((item) {
          if (item.date == day) {
            item.state = val.status;
          }
        });
      });
    }
    setState(() {
      dateList = list;
    });
  }

  List<Widget> _buildDays(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < dateList.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          if (dateList[i].state == -1) return;
          dateList.forEach((val) {
            val.select = false;
          });
          setState(() {
            dateList[i].select = true;
            currentDay = dateList[i].date >= 10
                ? dateList[i].date.toString()
                : '0${dateList[i].date}';
          });
          _changeDay(currentDay);
        },
        child: Container(
          width: ScreenUtil().setWidth(56),
          height: ScreenUtil().setHeight(56),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,  // 将会尽可能的伸展来达到组件的边缘
              image: AssetImage(dateList[i].select
                  ? 'lib/images/date3.png'
                  : (dateList[i].state != 0
                      ? 'lib/images/date2.png'
                      : 'lib/images/date1.png')),
            ),
          ),
          child: Center(
            child: Text(
              '${dateList[i].date == 0 ? '' : dateList[i].date}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(30),
                  color: ColorUtil.color(dateList[i].select
                      ? '#ffffff'
                      : (dateList[i].state != 0 ? '#CF241C' : '#333333'))),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  List<Widget> _buildWeeks(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < weeks.length; i++) {
      list.add(GestureDetector(
        child: Container(
          width: ScreenUtil().setWidth(56),
          height: ScreenUtil().setHeight(60),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('lib/images/date1.png'),
            ),
          ),
          child: Center(
            child: Text(
              '${weeks[i]}',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  color: ColorUtil.color('#666666')),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  List<Widget> _workList() {
    List<Widget> list = [];
    for (int i = 0; i < resList.length; i++) {
      list.add(
          /// 开始时间
          Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(18),
                  height: ScreenUtil().setWidth(18),
                  decoration: BoxDecoration(
                    color: ColorUtil.color('#F87E20'),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(100))),
                  ),
                ),
                Expanded(
                    child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('开始时间  ${resList[i].taskBegin}',
                            style: TextStyle(
                              color: ColorUtil.color('#F87E20'),
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(32),
                            )),
                        Text(resList[i].status == 1
                            ? '待开始'
                            : (resList[i].status == 2 ? '进行中' : '已完成'),style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: ColorUtil.color('#999999'),
                        ),)
                      ],
                    ),
                  ),
                ))
              ],
            ),

            /// 服务内容
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(28)),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        width: ScreenUtil().setWidth(2),
                        color: ColorUtil.color('#F87E20'))),
              ),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    bottom: ScreenUtil().setHeight(20)),
                padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                decoration: BoxDecoration(
                  color: ColorUtil.color('#F7F8FA'),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(8))),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(resList[i].orderType==1?'标准服务':'定制服务',
                        style: TextStyle(
                          color: ColorUtil.color('#333333'),
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(28),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text('${resList[i].contactName} ${resList[i].contactPhone}',
                          style: TextStyle(
                            color: ColorUtil.color('#333333'),
                            fontSize: ScreenUtil().setSp(28),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
                      child: Text('${resList[i].address}',
                          style: TextStyle(
                            color: ColorUtil.color('#666666'),
                            fontSize: ScreenUtil().setSp(28),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                      child: Text('服务时长  ${resList[i].serviceHours}小时',
                          style: TextStyle(
                            color: ColorUtil.color('#333333'),
                            fontSize: ScreenUtil().setSp(28),
                          )),
                    ),
                  ],
                ),
              ),
            ),

            /// 结束时间
            Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(18),
                  height: ScreenUtil().setWidth(18),
                  decoration: BoxDecoration(
                    color: ColorUtil.color('#999999'),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(100))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  child: Text('结束时间  ${resList[i].taskEnd}',
                      style: TextStyle(
                        color: ColorUtil.color('#999999'),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(32),
                      )),
                )
              ],
            ),

            /// 多个时间段
            Offstage(
              offstage: i == resList.length - 1,
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                height: ScreenUtil().setHeight(68),
                child: DottedLine(
                    color: ColorUtil.color('#999999'),
                    strokeWidth: ScreenUtil().setWidth(2),
                    gap: 4),
              ),
            ),
          ],
        ),
      ));
    }
    return list;
  }
}
