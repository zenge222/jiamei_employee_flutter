import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/common/resetPicker.dart';
import 'package:jiamei_employee_flutter/models/codeMsgRes.dart';
import 'package:jiamei_employee_flutter/models/leaveParams.dart';
import 'package:jiamei_employee_flutter/models/leaveRes.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';

class LeaveApplication extends StatefulWidget {
  @override
  _LeaveApplicationState createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication>
    with ComPageWidget {
  FocusNode blankNode = FocusNode();
  List<String> subTabs = ['发起提交', '请假记录'];
  List<int> subCount = [0, 0];
  int subTabsIndex = 0;
  List resList = [];
  bool isLoading = false; // 是否首次数据加载 不关闭-->请求错误或数据返回问题
  bool isGetAll = false; // 数据是否全部获取
  ScrollController _scrollController = ScrollController();
  int pageNum = 1;
  int pageSize = 10;
  LeaveParams fromParams = new LeaveParams();
  String typeStr = '';
  int typeIndex = 0;
  DateTime startDate = new DateTime.now();
  DateTime endDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '请假',
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
        isLoading: false,
        child: GestureDetector(
          onTap: () {
            // 点击空白页面关闭键盘
            FocusScope.of(context).requestFocus(blankNode);
          },
          child: Column(
            children: <Widget>[
              /// tabs
              Container(
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(8))),
                  ),
                  margin: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(24),
                      ScreenUtil().setHeight(28),
                      ScreenUtil().setWidth(24),
                      ScreenUtil().setHeight(8)),
                  child: Row(
                    children: _items(context),
                  ),
                ),
              ),

              /// 列表
              Expanded(
                  child: Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(24),
                    ScreenUtil().setHeight(0),
                    ScreenUtil().setWidth(24),
                    ScreenUtil().setHeight(40)),
                child: subTabsIndex == 0 ? _leaveFrom() : _buildList(),
              )),
              Offstage(
                offstage: subTabsIndex != 0,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(80),
                      ScreenUtil().setHeight(16),
                      ScreenUtil().setWidth(80),
                      ScreenUtil().setHeight(16)),
                  child: FlatButton(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(0),
                        ScreenUtil().setHeight(20),
                        ScreenUtil().setWidth(0),
                        ScreenUtil().setHeight(20)),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(60))),
                    color: ColorUtil.color('#F87E20'),
                    child: Text('提交',
                        style: TextStyle(
                          color: ColorUtil.color('#ffffff'),
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(32),
                        )),
                    onPressed: () {
                      _submitReport();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pageNum = 1;
      isGetAll = false;
      resList = [];
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isGetAll) {
          if (subTabsIndex == 1) {
            _getLeaveData();
          }
        }
      }
    });
    _initParams();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
    // App进去前台
      case AppLifecycleState.resumed:
        print('App进去前台');
        break;
    // 不常用：应用程序处于非活动状态，并且未接收用户输入时调用，比如：来了个电话
      case AppLifecycleState.inactive:
        print('应用程序处于非活动状态，并且未接收用户输入');
        break;
    // App进入后台
      case AppLifecycleState.paused:
        print('用户当前看不到应用程序，没有响应');
        break;
//      // 不常用：应用程序被挂起是调用，它不会在iOS上触发
      default:
//      case AppLifecycleState.suspending:
//        print('应用程序将暂停。');
//        break;
    }
  }

  Future _getLeaveData() async {
    await getRequest("selfVacationList", context,
            joint: '?pageSize=${pageSize}&pageNumber=${pageNum}')
        .then((res) {
      LeaveRes resp = LeaveRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        pageNum++;
        setState(() {
          isLoading = false;
          resList.addAll(resp.data);
        });
        if (resp.data.length < pageSize) {
          setState(() {
            isGetAll = true;
          });
        }
      } else {
        showToast(resp.message);
      }
    });
  }

  void _initParams() {
    LeaveParams initPrams = new LeaveParams();
    initPrams.beginTime = "";
    initPrams.endTime = "";
    initPrams.type = 0;
    initPrams.reason = "";
    setState(() {
      fromParams = initPrams;
      typeStr = "";
    });
  }

  Future _submitReport() async {
    if (typeStr == '') return showToast('请选择请假类型');
    if (fromParams.beginTime == '') return showToast('请选择开始时间');
    if (fromParams.endTime == '') return showToast('请选择结束时间');
    if (fromParams.reason == '') return showToast('请填写请假事由');
    setState(() {
      fromParams.type = typeStr == "事假" ? 1 : 2;
//      fromParams.beginTime += ':00';
//      fromParams.endTime += ':00';
    });
    await postRequest('vacationAdd', context, formData: fromParams).then((res) {
      CodeMsgRes resp = CodeMsgRes.fromJson(json.decode(res.toString()));
      print(resp.code);
      if (resp.code == 0) {
        setState(() {
          pageNum = 1;
          isGetAll = false;
          resList = [];
          subTabsIndex = 1;
        });
        _getLeaveData();
      }
      showToast(resp.message);
    });
  }

  void _tabsCheck(int i) {
    _initParams();
    if (i == 0) {
      setState(() {
        subTabsIndex = i;
      });
    } else {
      setState(() {
        subTabsIndex = i;
        pageNum = 1;
        resList = [];
        isGetAll = false;
      });
      _getLeaveData();
    }
  }

  List<Widget> _items(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < subTabs.length; i++) {
      widgets.add(Expanded(
          child: GestureDetector(
        onTap: () {
          _tabsCheck(i);
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Text(
                    subTabs[i],
                    style: TextStyle(
                        color: ColorUtil.color('#666666'),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(32)),
                    textAlign: TextAlign.center,
                  ),
                  Positioned(
                    left: ScreenUtil().setWidth(120),
                    top: ScreenUtil().setHeight(-16),
                    child: Offstage(
                      offstage: subCount[i] == 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(12),
                            ScreenUtil().setHeight(4),
                            ScreenUtil().setWidth(12),
                            ScreenUtil().setHeight(4)),
                        decoration: BoxDecoration(
                          color: ColorUtil.color('#F96158'),
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(100))),
                        ),
                        child: Center(
                          child: Text('${subCount[i]}',
                              style: TextStyle(
                                color: ColorUtil.color('#ffffff'),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(24),
                              )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                width: ScreenUtil().setWidth(60),
                height: ScreenUtil().setHeight(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      subTabsIndex == i
                          ? ColorUtil.color('#F87E20')
                          : Colors.white,
                      subTabsIndex == i
                          ? ColorUtil.color('#FFEBCB')
                          : Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(4))),
                ),
              )
            ],
          ),
        ),
      )));
    }
    return widgets;
  }

  Widget _buildList() {
    if (resList.length != 0) {
      return ListView.builder(
        //+1 for progressbar
        itemCount: resList.length + 1,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index == resList.length) {
            return dataMoreLoading(isGetAll);
          } else {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
              decoration: BoxDecoration(
                color: ColorUtil.color('#ffffff'),
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
              ),
              child: Column(
                children: <Widget>[
                  /// 列表头
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: ScreenUtil().setWidth(1),
                              color: ColorUtil.color('#EAEAEA'))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '提交时间：',
                              style: TextStyle(
                                color: ColorUtil.color('#333333'),
                                fontSize: ScreenUtil().setSp(30),
                              )),
                          TextSpan(
                              text: '${resList[index].createTime}',
                              style: TextStyle(
                                color: ColorUtil.color('#333333'),
                                fontSize: ScreenUtil().setSp(30),
                              )),
                        ])),
                        Text(
                            resList[index].status == -1
                                ? '待审批'
                                : (resList[index].status == 0 ? "不同意" : "同意"),
                            style: TextStyle(
                              color: ColorUtil.color('#F87E20'),
                              fontSize: ScreenUtil().setSp(30),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(24),
                        ScreenUtil().setHeight(0),
                        ScreenUtil().setWidth(24),
                        ScreenUtil().setHeight(24)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(24)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(152),
                                child: Text('请假类型',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontSize: ScreenUtil().setSp(28),
                                    )),
                              ),
                              Expanded(
                                  child: Text('${resList[index].type==1?"事假":"病假"}',
                                      style: TextStyle(
                                        color: ColorUtil.color('#666666'),
                                        fontSize: ScreenUtil().setSp(28),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(24)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(152),
                                child: Text('开始时间',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontSize: ScreenUtil().setSp(28),
                                    )),
                              ),
                              Expanded(
                                  child: Text('${resList[index].beginTime}',
                                      style: TextStyle(
                                        color: ColorUtil.color('#666666'),
                                        fontSize: ScreenUtil().setSp(28),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(24)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(152),
                                child: Text('结束时间',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontSize: ScreenUtil().setSp(28),
                                    )),
                              ),
                              Expanded(
                                  child: Text('${resList[index].endTime}',
                                      style: TextStyle(
                                        color: ColorUtil.color('#666666'),
                                        fontSize: ScreenUtil().setSp(28),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(24)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(152),
                                child: Text('请假原因',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontSize: ScreenUtil().setSp(28),
                                    )),
                              ),
                              Expanded(
                                  child: Text(
                                      '${resList[index].reason}',
                                      style: TextStyle(
                                        color: ColorUtil.color('#666666'),
                                        fontSize: ScreenUtil().setSp(28),
                                      )))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      );
    } else {
      return Center(
        child: Image.asset(
          'lib/images/no_leave.png',
          width: ScreenUtil().setWidth(400),
        ),
      );
    }
  }

  Widget _leaveFrom() {
    Widget widget;
    widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// 请假类型
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
          padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: ColorUtil.color('#F96158'),
                        fontSize: ScreenUtil().setSp(32),
                      )),
                  TextSpan(
                      text: '请假类型',
                      style: TextStyle(
                        color: ColorUtil.color('#333333'),
                        fontSize: ScreenUtil().setSp(32),
                      )),
                ])),
              ),
              GestureDetector(
                onTap: () {
                  List aa = [
                    '病假',
                    '事假',
                  ];
                  ResetPicker.showStringPicker(context,
                      data: aa,
                      normalIndex: typeIndex,
                      title: "选择原因", clickCallBack: (int index, var str) {
                    setState(() {
                      typeStr = str;
                      typeIndex = index;
                    });
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text(typeStr == "" ? '请选择' : typeStr,
                        style: TextStyle(
                          color: ColorUtil.color('#333333'),
                          fontSize: ScreenUtil().setSp(32),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                      child: Image.asset(
                        'lib/images/icons/sel_right_icon.png',
                        width: ScreenUtil().setWidth(28),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
          padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
          ),
          child: Column(
            children: <Widget>[
              /// 开始时间
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: ColorUtil.color('#F96158'),
                            fontSize: ScreenUtil().setSp(32),
                          )),
                      TextSpan(
                          text: '开始时间',
                          style: TextStyle(
                            color: ColorUtil.color('#333333'),
                            fontSize: ScreenUtil().setSp(32),
                          )),
                    ])),
                  ),
                  GestureDetector(
                    onTap: () {
                      ResetPicker.showDatePicker(context,
                          value: startDate,
                          dateType: DateType.YMD_HM,
//                            minValue: DateTime(today.year - 1),
//                            maxValue: DateTime(today.year + 1,today.month,today.day),
                          title: '选择日期', clickCallback: (timeStr, time) async {
                        setState(() {
                          fromParams.beginTime = timeStr + ':00';
                          startDate = DateTime.parse(time);
                        });
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                            fromParams.beginTime == ""
                                ? '请选择'
                                : fromParams.beginTime,
                            style: TextStyle(
                              color: ColorUtil.color('#333333'),
                              fontSize: ScreenUtil().setSp(32),
                            )),
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                          child: Image.asset(
                            'lib/images/icons/sel_right_icon.png',
                            width: ScreenUtil().setWidth(28),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              /// 结束时间
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: ColorUtil.color('#F96158'),
                              fontSize: ScreenUtil().setSp(32),
                            )),
                        TextSpan(
                            text: '结束时间',
                            style: TextStyle(
                              color: ColorUtil.color('#333333'),
                              fontSize: ScreenUtil().setSp(32),
                            )),
                      ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (fromParams.beginTime == "")
                          return showToast('请选择开始时间');
                        ResetPicker.showDatePicker(context,
                            value: endDate,
                            dateType: DateType.YMD_HM,
                            minValue: startDate,
//                            maxValue: DateTime(today.year + 1,today.month,today.day),
                            title: '选择日期',
                            clickCallback: (timeStr, time) async {
                          setState(() {
                            fromParams.endTime = timeStr + ':00';
                            endDate = DateTime.parse(time);
                          });
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                              fromParams.endTime == ""
                                  ? '请选择'
                                  : fromParams.endTime,
                              style: TextStyle(
                                color: ColorUtil.color('#333333'),
                                fontSize: ScreenUtil().setSp(32),
                              )),
                          Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16)),
                            child: Image.asset(
                              'lib/images/icons/sel_right_icon.png',
                              width: ScreenUtil().setWidth(28),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        /// 请假事由
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
          padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: ColorUtil.color('#F96158'),
                        fontSize: ScreenUtil().setSp(32),
                      )),
                  TextSpan(
                      text: '请假事由',
                      style: TextStyle(
                        color: ColorUtil.color('#333333'),
                        fontSize: ScreenUtil().setSp(32),
                      )),
                ])),
              ),
              Material(
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(28)),
                  child: TextField(
                      onChanged: (text) {
                        setState(() {
                          fromParams.reason = text;
                        });
                      },
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          fontSize: 14, textBaseline: TextBaseline.alphabetic),
                      decoration: InputDecoration(
                        fillColor: ColorUtil.color('#ffffff'),
                        filled: true,
                        contentPadding: EdgeInsets.all(
                          ScreenUtil().setSp(20),
                        ),
                        hintText: "请输入请假事由",
                        border: InputBorder.none,
                        hasFloatingPlaceholder: false,
                      )),
                ),
              )
            ],
          ),
        )
      ],
    );
    return widget;
  }
}
