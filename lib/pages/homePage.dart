import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/models/homeCount.dart';
import 'package:jiamei_employee_flutter/models/index.dart';
import 'package:jiamei_employee_flutter/models/meetVo.dart';
import 'package:jiamei_employee_flutter/models/meetingRes.dart';
import 'package:jiamei_employee_flutter/models/orderListRes.dart';
import 'package:jiamei_employee_flutter/pages/serviceDetail.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ComPageWidget {
  List<String> subTabs = ['面试订单', '服务任务', '历史任务'];
  List<int> subCount = [0, 0, 0];
  int subTabsIndex = 0;
  List resList = [];
  bool isLoading = false; // 是否首次数据加载 不关闭-->请求错误或数据返回问题
  bool isGetAll = false; // 数据是否全部获取
  ScrollController _scrollController = ScrollController();
  int pageNum = 1;
  int pageSize = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '首页',
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
        child: RefreshIndicator(
          color: ColorUtil.color('#F87E20'),
          onRefresh: () async {
            setState(() {
              pageNum = 1;
              resList = [];
              isGetAll = false;
            });
            if (subTabsIndex == 0) {
              _getMeetData();
            } else {
              _taskListByStatus();
            }
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
                      ScreenUtil().setHeight(0)),
                  child: Row(
                    children: _items(context),
                  ),
                ),
              ),

              /// 列表
              Expanded(
                  child: Container(
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(24),
                    ScreenUtil().setHeight(0),
                    ScreenUtil().setWidth(24),
                    ScreenUtil().setHeight(0)),
                child: _buildList(),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
      isGetAll = false;
      resList = [];
    });
    _getCount();
    _getMeetData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isGetAll) {
          if (subTabsIndex == 0) {
            _getMeetData();
          } else {
            _taskListByStatus();
          }
        }
      }
    });
  }

  void _tabsCheck(int i) {
    setState(() {
      subTabsIndex = i;
      pageNum = 1;
      resList = [];
      isGetAll = false;
    });
    if (i == 0) {
      _getMeetData();
    } else {
      _taskListByStatus();
    }
  }

  Future _getCount() async {
    await getRequest("indexCount", context).then((res) {
      HomeCount resp = HomeCount.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          subCount[0] = resp.data.waitMeetCount;
          subCount[1] = resp.data.taskCount;
        });
      } else {
        showToast(resp.message);
      }
    });
  }

  Future _getMeetData() async {
    await getRequest("meetList", context,
            joint: '?pageSize=${pageSize}&pageNo=${pageNum}')
        .then((res) {
      MeetingRes resp = MeetingRes.fromJson(json.decode(res.toString()));
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

  Future _taskListByStatus() async {
    int state = subTabsIndex == 1 ? 0 : 1;
    await getRequest("taskListByStatus", context,
            joint: '?pageSize=${pageSize}&pageNo=${pageNum}&status=${state}')
        .then((res) {
      OrderListRes resp = OrderListRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        pageNum++;
        setState(() {
          isLoading = false;
          resList.addAll(resp.data);
        });
        if (resp.data.length < pageSize) {
          isGetAll = true;
        }
      } else {
        showToast(resp.message);
      }
    });
  }

  Future<bool> requestPermission() async {
    var permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      return true;
    } else {
      showToast('需要定位权限');
      return false;
    }
  }

  _getLocation() async {
    if (await requestPermission()) {
//      final location = await AmapLocation.instance.fetchLocation();
//      print(location.latLng.latitude.toString() +
//          '---' +
//          location.latLng.longitude.toString());
      Location loc = await AmapLocation.fetchLocation();
      loc.address.then((val) {
        print(val);
      });
      loc.latLng.then((val) {
        print('longitude:' + val.longitude.toString());
        print('latitude:' + val.latitude.toString());
//        SharedPreferencesUtil.setLongitude(val.longitude);
//        SharedPreferencesUtil.setLatitude(val.latitude);
      });
    }
  }

  void _launchURL(String longitude, String latitude, String address) async {
    String url =
        'androidamap://keywordNavi?sourceApplication=softname&keyword=' +
            address.toString() +
            '&style=2';
//    String url =
//        'androidamap://navi?sourceApplication=appname&poiname=fangheng&lat=26.57&lon=106.71&dev=1&style=2';
    print(address);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //iOS
      String url = 'http://maps.apple.com/?ll=' +
          longitude.toString() +
          ',' +
          latitude.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
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
      if (subTabsIndex == 0) {
        /// 面试订单
        return ListView.builder(
          //+1 for progressbar
          itemCount: resList.length + 1,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == resList.length) {
              return dataMoreLoading(isGetAll);
            } else {
              return Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(8))),
                ),
                child: Column(
                  children: <Widget>[
                    /// 头部
                    Container(
                      padding: EdgeInsets.all(
                        ScreenUtil().setWidth(24),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: ScreenUtil().setWidth(1),
                                  color: ColorUtil.color('#EAEAEA')))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '面试客户：',
                                style: TextStyle(
                                  color: ColorUtil.color('#333333'),
                                  fontSize: ScreenUtil().setSp(30),
                                )),
                            TextSpan(
                                text: '${resList[index].contactName}',
                                style: TextStyle(
                                  color: ColorUtil.color('#333333'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(30),
                                )),
                          ])),
                          GestureDetector(
                            /// 打电话
                            onTap: () async {
                              if (await canLaunch(
                                  'tel:${resList[index].managerMobile}')) {
                                await launch(
                                    'tel:${resList[index].managerMobile}');
                              } else {
                                showToast('拨号失败！');
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(8)),
                                  width: ScreenUtil().setWidth(28),
                                  child: Image.asset(
                                      'lib/images/icons/call_phone_icon.png'),
                                ),
                                Text('联系区域经理',
                                    style: TextStyle(
                                      color: ColorUtil.color('#F87E20'),
                                      fontSize: ScreenUtil().setSp(28),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    /// 内容
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(36)),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'lib/images/icons/time_icon.png',
                            width: ScreenUtil().setWidth(48),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(12)),
                            child: Text('${resList[index].periodBegin}',
                                style: TextStyle(
                                  color: ColorUtil.color('#333333'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(40),
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorUtil.color('#F7F8FA'),
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(8))),
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(40),
                          left: ScreenUtil().setHeight(24),
                          right: ScreenUtil().setHeight(24)),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${resList[index].address}',
                              style: TextStyle(
                                color: ColorUtil.color('#666666'),
                                fontSize: ScreenUtil().setSp(28),
                              )),
//                          Padding(
//                            padding:
//                                EdgeInsets.only(top: ScreenUtil().setHeight(8)),
//                            child: Text('鄞州区金融大厦-B座3层308室',
//                                style: TextStyle(
//                                  color: ColorUtil.color('#333333'),
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: ScreenUtil().setSp(28),
//                                )),
//                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setHeight(24)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(24)),
                                child: FlatButton(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(0),
                                      ScreenUtil().setHeight(0),
                                      ScreenUtil().setWidth(0),
                                      ScreenUtil().setHeight(0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(60)),
                                    side: BorderSide(
                                      color: ColorUtil.color('#F87E20'),
                                      width: ScreenUtil().setWidth(2),
                                    ),
                                  ),
                                  color: ColorUtil.color('#ffffff'),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'lib/images/icons/to_navigate_icon.png',
                                        width: ScreenUtil().setWidth(28),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(10)),
                                        child: Text('导航',
                                            style: TextStyle(
                                              color: ColorUtil.color('#F87E20'),
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(28),
                                            )),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    _launchURL(
                                        '${resList[index].longitude}',
                                        '${resList[index].latitude}',
                                        '${resList[index].address}');
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      } else {
        /// 非面试订单
        return ListView.builder(
          //+1 for progressbar
          itemCount: resList.length + 1,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == resList.length) {
              return dataMoreLoading(isGetAll);
            } else {
              return Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(8))),
                ),
                child: Column(
                  children: <Widget>[
                    /// 头部
                    Container(
                      padding: EdgeInsets.all(
                        ScreenUtil().setWidth(24),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: ScreenUtil().setWidth(1),
                                  color: ColorUtil.color('#EAEAEA')))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '客户：',
                                style: TextStyle(
                                  color: ColorUtil.color('#333333'),
                                  fontSize: ScreenUtil().setSp(30),
                                )),
                            TextSpan(
                                text: '${resList[index].contactName}',
                                style: TextStyle(
                                  color: ColorUtil.color('#333333'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(30),
                                )),
//                            TextSpan(
//                                text: subTabsIndex == 1 ? ' 18888888888' : '',
//                                style: TextStyle(
//                                  color: ColorUtil.color('#999999'),
//                                  fontSize: ScreenUtil().setSp(28),
//                                )),
                          ])),
                          subTabsIndex != 2
                              ? GestureDetector(
                                  /// 打电话
                                  onTap: () async {
                                    if (await canLaunch(
                                        'tel:${resList[index].managerMobile}')) {
                                      await launch(
                                          'tel:${resList[index].managerMobile}');
                                    } else {
                                      showToast('拨号失败！');
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(8)),
                                        width: ScreenUtil().setWidth(28),
                                        child: Image.asset(
                                            'lib/images/icons/call_phone_icon.png'),
                                      ),
                                      Text('联系区域经理',
                                          style: TextStyle(
                                            color: ColorUtil.color('#F87E20'),
                                            fontSize: ScreenUtil().setSp(28),
                                          ))
                                    ],
                                  ),
                                )
                              : RichText(
                                  text: TextSpan(children: [
                                  TextSpan(
                                      text: '服务时长：',
                                      style: TextStyle(
                                        color: ColorUtil.color('#999999'),
                                        fontSize: ScreenUtil().setSp(28),
                                      )),
                                  TextSpan(
                                      text: '${resList[index].realMinutes}分',
                                      style: TextStyle(
                                        color: ColorUtil.color('#F87E20'),
                                        fontSize: ScreenUtil().setSp(28),
                                      )),
                                ]))
                        ],
                      ),
                    ),

                    /// 内容
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(36)),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            subTabsIndex == 1
                                ? 'lib/images/icons/time_icon2.png'
                                : 'lib/images/icons/time_icon3.png',
                            width: ScreenUtil().setWidth(48),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(12)),
                            child: Text('${resList[index].taskBegin}',
                                style: TextStyle(
                                  color: ColorUtil.color('#333333'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(40),
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorUtil.color('#F7F8FA'),
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(8))),
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(40),
                          left: ScreenUtil().setHeight(24),
                          right: ScreenUtil().setHeight(24)),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${resList[index].address}',
                              style: TextStyle(
                                color: ColorUtil.color('#666666'),
                                fontSize: ScreenUtil().setSp(28),
                              )),
//                          Padding(
//                            padding:
//                                EdgeInsets.only(top: ScreenUtil().setHeight(8)),
//                            child: Text('鄞州区金融大厦-B座3层308室',
//                                style: TextStyle(
//                                  color: ColorUtil.color('#333333'),
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: ScreenUtil().setSp(28),
//                                )),
//                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setHeight(24)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Offstage(
                                offstage: subTabsIndex != 1,
                                child: resList[index].status == 2
                                    ? RichText(
                                        text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                '${resList[index].realBegin} ',
                                            style: TextStyle(
                                              color: ColorUtil.color('#F87E20'),
                                              fontSize: ScreenUtil().setSp(28),
                                            )),
                                        TextSpan(
                                            text: '已开始服务',
                                            style: TextStyle(
                                              color: ColorUtil.color('#aaaaaa'),
                                              fontSize: ScreenUtil().setSp(28),
                                            )),
                                      ]))
                                    : Text('')
//                              FlatButton(
//                                      padding: EdgeInsets.fromLTRB(
//                                          ScreenUtil().setWidth(00),
//                                          ScreenUtil().setHeight(0),
//                                          ScreenUtil().setWidth(00),
//                                          ScreenUtil().setHeight(0)),
//                                      shape: RoundedRectangleBorder(
//                                        borderRadius: BorderRadius.circular(
//                                            ScreenUtil().setWidth(60)),
//                                        side: BorderSide(
//                                          color: ColorUtil.color('#F87E20'),
//                                          width: ScreenUtil().setWidth(2),
//                                        ),
//                                      ),
//                                      color: ColorUtil.color('#F87E20'),
//                                      child: Row(
//                                        children: <Widget>[
//                                          Padding(
//                                            padding: EdgeInsets.only(
//                                                left: ScreenUtil().setWidth(0)),
//                                            child: Text('开始服务',
//                                                textAlign: TextAlign.center,
//                                                style: TextStyle(
//                                                  color: ColorUtil.color(
//                                                      '#ffffff'),
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize:
//                                                      ScreenUtil().setSp(28),
//                                                )),
//                                          )
//                                        ],
//                                      ),
//                                      onPressed: () {
//                                        showCustomDialog(context, '确定开始服务?',
//                                            () {
//                                          /// 刷新
//                                        });
//                                      },
//                                    ),
                                ),
                          ),
                          Row(
                            children: <Widget>[
                              Offstage(
                                offstage: subTabsIndex == 0,
                                child: FlatButton(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(0),
                                      ScreenUtil().setHeight(0),
                                      ScreenUtil().setWidth(0),
                                      ScreenUtil().setHeight(0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(60)),
                                    side: BorderSide(
                                      color: ColorUtil.color('#cccccc'),
                                      width: ScreenUtil().setWidth(2),
                                    ),
                                  ),
                                  color: ColorUtil.color('#ffffff'),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(0)),
                                        child: Text('详情',
                                            style: TextStyle(
                                              color: ColorUtil.color('#333333'),
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(28),
                                            )),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ServiceDetail(
                                              id: resList[index].id,
                                              type: subTabsIndex,orderType:resList[index].orderType),
                                        )).then((data) {
                                      setState(() {
                                        isGetAll = false;
                                        pageNum = 1;
                                        resList = [];
                                      });
                                      _taskListByStatus();
                                    });
                                  },
                                ),
                              ),
                              Offstage(
                                offstage: subTabsIndex == 2,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(24)),
                                  child: FlatButton(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(0),
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(0)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(60)),
                                      side: BorderSide(
                                        color: ColorUtil.color('#F87E20'),
                                        width: ScreenUtil().setWidth(2),
                                      ),
                                    ),
                                    color: ColorUtil.color('#ffffff'),
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'lib/images/icons/to_navigate_icon.png',
                                          width: ScreenUtil().setWidth(28),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(10)),
                                          child: Text('导航',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#F87E20'),
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    ScreenUtil().setSp(28),
                                              )),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      _launchURL(
                                          '${resList[index].longitude}',
                                          '${resList[index].latitude}',
                                          '${resList[index].address}');
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      }
    } else {
      return Center(
        child: Image.asset(
          'lib/images/no_list.png',
          width: ScreenUtil().setWidth(400),
        ),
      );
    }
  }
}
