import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/PhotoViewGalleryScreen.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/config/time.dart';
import 'package:jiamei_employee_flutter/models/codeRes.dart';
import 'package:jiamei_employee_flutter/models/servicesDetailRes.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';
import 'package:spon_rating_bar/spon_rating_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetail extends StatefulWidget {
  final int id;
  final int type; // 0 服务未开始 1 开始服务  2 已完成
  final int orderType; // 1标准服务 2定制服务

  const ServiceDetail({Key key, this.id, this.type, this.orderType})
      : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail>
    with ComPageWidget, WidgetsBindingObserver {
  bool isLoading = false;
  String countContent; // 倒计时内容
  Timer _timer;
  int seconds = 0;
  ServicesDetailData resData;

  @override
  Widget build(BuildContext context) {
    countContent = TimerUtils.constructTime(seconds);
    return Scaffold(
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '服务订单详情',
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
        child: resData != null
            ? Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(256),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/images/service_detail_bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(32),
                            bottom: ScreenUtil().setHeight(32)),
                        child: Text(
                            resData.status == 0
                                ? '订单已关闭'
                                : (resData.status == 1
                                    ? '尚未开始服务'
                                    : (resData.status == 2
                                        ? '开始时间  ${resData.realBegin}'
                                        : '订单已完成')),
                            style: TextStyle(
                              color: ColorUtil.color('#ffffff'),
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(32),
                            )),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(24),
                              ScreenUtil().setHeight(0),
                              ScreenUtil().setWidth(24),
                              ScreenUtil().setHeight(40)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              /// 客户信息
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(0)),
                                decoration: BoxDecoration(
                                  color: ColorUtil.color('#ffffff'),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(8))),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(24),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width:
                                                      ScreenUtil().setWidth(1),
                                                  color: ColorUtil.color(
                                                      '#EAEAEA')))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: '客户：',
                                                style: TextStyle(
                                                  color: ColorUtil.color(
                                                      '#333333'),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                )),
                                            TextSpan(
                                                text: '${resData.contactName}',
                                                style: TextStyle(
                                                  color: ColorUtil.color(
                                                      '#333333'),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                )),
//                                            TextSpan(
//                                                text: ' 18888888888',
//                                                style: TextStyle(
//                                                  color: ColorUtil.color(
//                                                      '#999999'),
//                                                  fontSize:
//                                                      ScreenUtil().setSp(28),
//                                                )),
                                          ])),
                                          GestureDetector(
                                            /// 打电话
                                            onTap: () async {
                                              print(resData.managerMobile);
                                              if (await canLaunch(
                                                  'tel:${resData.managerMobile}')) {
                                                await launch(
                                                    'tel:${resData.managerMobile}');
                                              } else {
                                                showToast('拨号失败！');
                                              }
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: ScreenUtil()
                                                          .setWidth(8)),
                                                  width:
                                                      ScreenUtil().setWidth(28),
                                                  child: Image.asset(
                                                      'lib/images/icons/call_phone_icon.png'),
                                                ),
                                                Text('联系区域经理',
                                                    style: TextStyle(
                                                      color: ColorUtil.color(
                                                          '#F87E20'),
                                                      fontSize: ScreenUtil()
                                                          .setSp(28),
                                                    ))
                                              ],
                                            ),
                                          )

//                                          RichText(
//                                                  text: TextSpan(children: [
//                                                  TextSpan(
//                                                      text: '服务时长：',
//                                                      style: TextStyle(
//                                                        color: ColorUtil.color(
//                                                            '#999999'),
//                                                        fontSize: ScreenUtil()
//                                                            .setSp(28),
//                                                      )),
//                                                  TextSpan(
//                                                      text: '2小时58分56秒',
//                                                      style: TextStyle(
//                                                        color: ColorUtil.color(
//                                                            '#F87E20'),
//                                                        fontSize: ScreenUtil()
//                                                            .setSp(28),
//                                                      )),
//                                                ]))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(36)),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            resData.status == 1 ||
                                                    resData.status == 2
                                                ? 'lib/images/icons/time_icon2.png'
                                                : 'lib/images/icons/time_icon3.png',
                                            width: ScreenUtil().setWidth(48),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    ScreenUtil().setWidth(12)),
                                            child: Text('${resData.taskBegin}',
                                                style: TextStyle(
                                                  color: ColorUtil.color(
                                                      '#333333'),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      ScreenUtil().setSp(40),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: ColorUtil.color('#F7F8FA'),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(8))),
                                      ),
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(40),
                                          left: ScreenUtil().setHeight(24),
                                          right: ScreenUtil().setHeight(24),
                                          bottom: ScreenUtil().setHeight(32)),
                                      padding: EdgeInsets.all(
                                          ScreenUtil().setWidth(24)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('${resData.address}',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#666666'),
                                                fontSize:
                                                    ScreenUtil().setSp(28),
                                              )),
//                                          Padding(
//                                            padding: EdgeInsets.only(
//                                                top: ScreenUtil().setHeight(8)),
//                                            child: Text('鄞州区金融大厦-B座3层308室',
//                                                style: TextStyle(
//                                                  color: ColorUtil.color(
//                                                      '#333333'),
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize:
//                                                      ScreenUtil().setSp(28),
//                                                )),
//                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// 服务时长
                              Offstage(
                                offstage: resData.status > 2,
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setWidth(24)),
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(24)),
                                  decoration: BoxDecoration(
                                    color: ColorUtil.color('#ffffff'),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(8))),
                                  ),
                                  child: Text(
                                      '本次服务时长：${resData.serviceHours * 60}分钟',
                                      style: TextStyle(
                                        color: ColorUtil.color('#333333'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(32),
                                      )),
                                ),
                              ),

                              /// 区域经理
//                              Offstage(
//                                offstage: resData.status != 3,
//                                child: Container(
//                                  padding:
//                                      EdgeInsets.all(ScreenUtil().setWidth(24)),
//                                  width: double.infinity,
//                                  margin: EdgeInsets.only(
//                                      top: ScreenUtil().setHeight(24)),
//                                  decoration: BoxDecoration(
//                                    color: ColorUtil.color('#ffffff'),
//                                    borderRadius: BorderRadius.all(
//                                        Radius.circular(
//                                            ScreenUtil().setWidth(8))),
//                                  ),
//                                  child: Row(
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Row(
//                                        children: <Widget>[
//                                          Image.asset(
//                                            'lib/images/icons/home_active.png',
//                                            width: ScreenUtil().setWidth(64),
//                                          ),
//                                          Padding(
//                                            padding: EdgeInsets.only(
//                                                left:
//                                                    ScreenUtil().setWidth(12)),
//                                            child: Text(
//                                                '区域经理：${resData.managerName}',
//                                                style: TextStyle(
//                                                  color: ColorUtil.color(
//                                                      '#333333'),
//                                                  fontSize:
//                                                      ScreenUtil().setSp(28),
//                                                )),
//                                          )
//                                        ],
//                                      ),
//                                      GestureDetector(
//                                        /// 打电话
//                                        onTap: () async {
//                                          print(resData.managerMobile);
//                                          if (await canLaunch(
//                                              'tel:${resData.managerMobile}')) {
//                                            await launch(
//                                                'tel:${resData.managerMobile}');
//                                          } else {
//                                            showToast('拨号失败！');
//                                          }
//                                        },
//                                        child: Row(
//                                          children: <Widget>[
//                                            Text('${resData.managerMobile}',
//                                                style: TextStyle(
//                                                  color: ColorUtil.color(
//                                                      '#F87E20'),
//                                                  fontSize:
//                                                      ScreenUtil().setSp(28),
//                                                )),
//                                            Container(
//                                              margin: EdgeInsets.only(
//                                                  left:
//                                                      ScreenUtil().setWidth(8)),
//                                              width: ScreenUtil().setWidth(28),
//                                              child: Image.asset(
//                                                  'lib/images/icons/call_phone_icon.png'),
//                                            ),
//                                          ],
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
                              Container(
                                width: ScreenUtil().setWidth(208),
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(24)),
                                child:
                                    Image.asset('lib/images/work_detail.png'),
                              ),

                              /// 工作内容描述
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(0),
                                    ScreenUtil().setHeight(0),
                                    ScreenUtil().setWidth(0),
                                    ScreenUtil().setHeight(30)),
                                decoration: BoxDecoration(
                                  color: ColorUtil.color('#ffffff'),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(8))),
                                ),
                                child: widget.orderType != 1
                                    ? Column(
                                        children: <Widget>[
                                          /// 家庭人数
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(32),
                                                ScreenUtil().setHeight(30),
                                                ScreenUtil().setWidth(32),
                                                ScreenUtil().setHeight(0)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: ScreenUtil()
                                                      .setWidth(121),
                                                  child: Text('家庭人数:',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: ColorUtil.color(
                                                            '#666666'),
                                                        fontSize: ScreenUtil()
                                                            .setSp(28),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: ScreenUtil()
                                                            .setWidth(24)),
                                                    child: Text(
                                                        '${resData.peoples}人',
                                                        style: TextStyle(
                                                          color:
                                                              ColorUtil.color(
                                                                  '#333333'),
                                                          fontSize: ScreenUtil()
                                                              .setSp(28),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          /// 房间面积
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(32),
                                                ScreenUtil().setHeight(30),
                                                ScreenUtil().setWidth(32),
                                                ScreenUtil().setHeight(0)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: ScreenUtil()
                                                      .setWidth(121),
                                                  child: Text('房间面积:',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: ColorUtil.color(
                                                            '#666666'),
                                                        fontSize: ScreenUtil()
                                                            .setSp(28),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: ScreenUtil()
                                                            .setWidth(24)),
                                                    child: Text(
                                                        '${resData.houseAcreage}',
                                                        style: TextStyle(
                                                          color:
                                                              ColorUtil.color(
                                                                  '#333333'),
                                                          fontSize: ScreenUtil()
                                                              .setSp(28),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          /// 宠物
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(32),
                                                ScreenUtil().setHeight(30),
                                                ScreenUtil().setWidth(32),
                                                ScreenUtil().setHeight(0)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: ScreenUtil()
                                                      .setWidth(121),
                                                  child: Text('宠物:',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: ColorUtil.color(
                                                            '#666666'),
                                                        fontSize: ScreenUtil()
                                                            .setSp(28),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: ScreenUtil()
                                                            .setWidth(24)),
                                                    child: Text(
                                                        '${resData.petsName}',
                                                        style: TextStyle(
                                                          color:
                                                              ColorUtil.color(
                                                                  '#333333'),
                                                          fontSize: ScreenUtil()
                                                              .setSp(28),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          /// 户型
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(32),
                                                ScreenUtil().setHeight(30),
                                                ScreenUtil().setWidth(32),
                                                ScreenUtil().setHeight(0)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: ScreenUtil()
                                                      .setWidth(121),
                                                  child: Text('户型:',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: ColorUtil.color(
                                                            '#666666'),
                                                        fontSize: ScreenUtil()
                                                            .setSp(28),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: ScreenUtil()
                                                            .setWidth(24)),
                                                    child: Text(
                                                        '${resData.content}',
                                                        style: TextStyle(
                                                          color:
                                                              ColorUtil.color(
                                                                  '#333333'),
                                                          fontSize: ScreenUtil()
                                                              .setSp(28),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(20),
                                            top: ScreenUtil().setHeight(20)),
                                        child: Text('${resData.content}',
                                            style: TextStyle(
                                              color: ColorUtil.color('#666666'),
                                              fontSize: ScreenUtil().setSp(28),
                                            )),
                                      ),
                              ),

                              Offstage(
                                offstage: false, //widget.orderType == 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /// 工作项
                                    Column(
                                      children: _buildWorks(resData.items),
                                    ),

                                    /// 服务时间+服务时长
                                    Offstage(
                                      offstage: resData.status < 3,
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(
                                            ScreenUtil().setWidth(24)),
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(24)),
                                        decoration: BoxDecoration(
                                          color: ColorUtil.color('#ffffff'),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(8))),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                '本次服务时长：${resData.serviceHours * 60}分钟',
                                                style: TextStyle(
                                                  color: ColorUtil.color(
                                                      '#333333'),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      ScreenUtil().setSp(32),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: ScreenUtil()
                                                      .setHeight(16)),
                                              child: Text(
                                                  '实际服务时长：${resData.realMinutes}分钟',
                                                  style: TextStyle(
                                                    color: ColorUtil.color(
                                                        '#333333'),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        ScreenUtil().setSp(32),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// 评论信息
                              Offstage(
                                offstage: resData.status != 4,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(0),
                                      ScreenUtil().setHeight(24),
                                      ScreenUtil().setWidth(24),
                                      ScreenUtil().setHeight(24)),
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(24)),
                                  decoration: BoxDecoration(
                                    color: ColorUtil.color('#ffffff'),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(8))),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    ScreenUtil().setWidth(24)),
                                            width: ScreenUtil().setWidth(8),
                                            height: ScreenUtil().setHeight(36),
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorUtil.color('#F87E20'),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      ScreenUtil()
                                                          .setWidth(200)),
                                                  bottomRight: Radius.circular(
                                                      ScreenUtil()
                                                          .setWidth(200)),
                                                )),
                                          ),
                                          Text('评论信息',
                                              style: TextStyle(
                                                color:
                                                    ColorUtil.color('#333333'),
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    ScreenUtil().setSp(36),
                                              ))
                                        ],
                                      ),

                                      /// 评分
                                      resData.evaluateStar != null
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: ScreenUtil()
                                                      .setHeight(20),
                                                  left: ScreenUtil()
                                                      .setHeight(24)),
                                              child: Row(
                                                children: <Widget>[
                                                  Text('服务质量：',
                                                      style: TextStyle(
                                                        color: ColorUtil.color(
                                                            '#333333'),
                                                        fontSize: ScreenUtil()
                                                            .setSp(32),
                                                      )),
                                                  SponRatingWidget(
                                                    value: double.parse(resData
                                                                .evaluateStar
                                                                .toString()) ==
                                                            null
                                                        ? 0
                                                        : double.parse(resData
                                                            .evaluateStar
                                                            .toString()),
                                                    size: 20,
                                                    padding: 5,
                                                    nomalImage:
                                                        'lib/images/icons/star_nomal.png',
                                                    selectImage:
                                                        'lib/images/icons/star.png',
                                                    selectAble: false,
                                                    onRatingUpdate: (value) {
//                                  ratingValue = value;
                                                      setState(() {});
                                                    },
                                                    maxRating: 5,
                                                    count: 5,
                                                  ),
                                                  Text(
                                                      '  ${resData.evaluateStar == 5 ? '非常好' : (resData.evaluateStar < 4 ? '好' : '一般')}',
                                                      style: TextStyle(
                                                        color: ColorUtil.color(
                                                            '#F87E20'),
                                                        fontSize: ScreenUtil()
                                                            .setSp(28),
                                                      )),
                                                ],
                                              ),
                                            )
                                          : Text(''),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(20),
                                            left: ScreenUtil().setHeight(24)),
                                        child: Text(
                                            '${resData.evaluateContent}',
                                            style: TextStyle(
                                              color: ColorUtil.color('#333333'),
                                              fontSize: ScreenUtil().setSp(28),
                                            )),
                                      ),

                                      /// 服务图片
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(20),
                                            left: ScreenUtil().setHeight(24)),
                                        child: Wrap(
                                          spacing: ScreenUtil().setWidth(20),
                                          //主轴上子控件的间距
                                          runSpacing:
                                              ScreenUtil().setHeight(20),
                                          //交叉轴上子控件之间的间距
                                          children: _imgList(resData.pictures),
                                        ),
                                      ),

                                      /// 服务分列表
//                                      Container(
//                                        margin: EdgeInsets.only(
//                                            top: ScreenUtil().setHeight(20),
//                                            left: ScreenUtil().setHeight(24)),
//                                        width: double.infinity,
//                                        child: Column(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
//                                          children: <Widget>[
//                                            Container(
//                                              margin: EdgeInsets.only(
//                                                  top: ScreenUtil()
//                                                      .setHeight(20)),
//                                              child: RichText(
//                                                  text: TextSpan(children: [
//                                                TextSpan(
//                                                    text: '1.厨房',
//                                                    style: TextStyle(
//                                                      color: ColorUtil.color(
//                                                          '#333333'),
//                                                      fontSize: ScreenUtil()
//                                                          .setSp(28),
//                                                    )),
//                                                TextSpan(
//                                                    text: '    1分',
//                                                    style: TextStyle(
//                                                      color: ColorUtil.color(
//                                                          '#666666'),
//                                                      fontSize: ScreenUtil()
//                                                          .setSp(28),
//                                                    )),
//                                              ])),
//                                            ),
//                                            Container(
//                                              margin: EdgeInsets.only(
//                                                  top: ScreenUtil()
//                                                      .setHeight(20)),
//                                              child: RichText(
//                                                  text: TextSpan(children: [
//                                                TextSpan(
//                                                    text: '2.客厅',
//                                                    style: TextStyle(
//                                                      color: ColorUtil.color(
//                                                          '#333333'),
//                                                      fontSize: ScreenUtil()
//                                                          .setSp(28),
//                                                    )),
//                                                TextSpan(
//                                                    text: '    1分',
//                                                    style: TextStyle(
//                                                      color: ColorUtil.color(
//                                                          '#666666'),
//                                                      fontSize: ScreenUtil()
//                                                          .setSp(28),
//                                                    )),
//                                              ])),
//                                            )
//                                          ],
//                                        ),
//                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                      Offstage(
                        offstage: resData.status == 0 ||
                            resData.status == 3 ||
                            resData.status == 4,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(32),
                              ScreenUtil().setHeight(14),
                              ScreenUtil().setWidth(32),
                              ScreenUtil().setHeight(14)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              resData.status == 2
                                  ? RichText(
                                      text: TextSpan(children: [
                                      TextSpan(
                                          text: '已服务时长：',
                                          style: TextStyle(
                                            color: ColorUtil.color('#999999'),
                                            fontSize: ScreenUtil().setSp(28),
                                          )),
                                      TextSpan(
                                          text: '${countContent}',
                                          style: TextStyle(
                                            color: ColorUtil.color('#F87E20'),
                                            fontSize: ScreenUtil().setSp(28),
                                          )),
                                    ]))
                                  : Text('',
                                      style: TextStyle(
                                        color: ColorUtil.color('#999999'),
                                        fontSize: ScreenUtil().setSp(28),
                                      )),
                              resData.status == 1
                                  ? Container(
                                      width: ScreenUtil().setWidth(200),
                                      child: FlatButton(
                                        padding: EdgeInsets.fromLTRB(
                                            ScreenUtil().setWidth(0),
                                            ScreenUtil().setHeight(20),
                                            ScreenUtil().setWidth(0),
                                            ScreenUtil().setHeight(20)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setWidth(60))),
                                        color: ColorUtil.color('#F87E20'),
                                        child: Text('开始服务',
                                            style: TextStyle(
                                              color: ColorUtil.color('#ffffff'),
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(32),
                                            )),
                                        onPressed: () {
                                          _startService();
                                        },
                                      ),
                                    )
                                  : resData.status == 2
                                      ? Container(
                                          width: ScreenUtil().setWidth(200),
                                          child: FlatButton(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(40),
                                                ScreenUtil().setHeight(20),
                                                ScreenUtil().setWidth(40),
                                                ScreenUtil().setHeight(20)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(60)),
                                              side: BorderSide(
                                                color:
                                                    ColorUtil.color('#F87E20'),
                                                width: ScreenUtil().setWidth(2),
                                              ),
                                            ),
                                            color: ColorUtil.color('#ffffff'),
                                            child: Text('完成',
                                                style: TextStyle(
                                                  color: ColorUtil.color(
                                                      '#F87E20'),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                )),
                                            onPressed: () {
                                              showCustomDialog(context, '确定完成?',
                                                  () {
                                                Application.router.pop(context);
                                                _submitOrder();
                                              });
                                            },
                                          ),
                                        )
                                      : Text('')
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            : Text(''),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
//    print(widget.type);
//    print(widget.id);
    print('orderType:' + widget.orderType.toString());
    WidgetsBinding.instance.addObserver(this);
    _getDetailData();
  }

  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
//    print("lifeChanged $state");
    switch (state) {
    // App进去前台
      case AppLifecycleState.resumed:
        _getDetailData();
//        startTimer();
//        print('App进去前台');
        break;
    // 不常用：应用程序处于非活动状态，并且未接收用户输入时调用，比如：来了个电话
      case AppLifecycleState.inactive:
//        print('应用程序处于非活动状态，并且未接收用户输入');
        break;
    // App进入后台 例 息屏
      case AppLifecycleState.paused:
        cancelTimer();
//        print('用户当前看不到应用程序，没有响应');
        break;
//      // 不常用：应用程序被挂起是调用，它不会在iOS上触发
      default:
//      case AppLifecycleState.suspending:
//        print('应用程序将暂停。');
//        break;
    }
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);//销毁
    cancelTimer();
  }

    Future _getDetailData() async {
    await getRequest("orderTaskInfo", context, joint: '/${widget.id}')
        .then((res) {
      ServicesDetailRes resp =
          ServicesDetailRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          isLoading = false;
          resData = resp.data;
        });
        if (resData.status == 2) {
          // 把".010Z"删除, 加上"-0800", ("-"代表向东边偏移,"+"代表向西边偏移,"08"代表8个小时,"00"代表分钟)
          //          var d1 = DateTime.parse(resData.realBegin);
//          var d1 = DateTime.parse(resData.realBegin).toUtc();
//          var d2 = DateTime.parse("${DateTime.now().toString().substring(0,19)}-0800");

          var d1 = DateTime.parse(resData.realBegin);
          var d2 = DateTime.now();
          print(d1);
          print(d2);
          var difference = d2.difference(d1);
          print([
            difference.inDays,
            difference.inHours,
            difference.inMinutes,
            difference.inSeconds
          ]);
          setState(() {
            seconds = difference.inSeconds < 0 ? 0 : difference.inSeconds;
            countContent = TimerUtils.constructTime(seconds);
          });
          startTimer();
        }
      } else {
        showToast(resp.message);
      }
    });
  }

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        //秒数加一，因为一秒回调一次
        seconds++;
//        print('我在更新界面>>>>>>>>>>>>>> $seconds');
      });
      if (seconds == 0) {
        //倒计时秒数为0，取消定时器
        print('我被取消了  ');
        cancelTimer();
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }


//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    print('AppLifecycleState state');
//    print(AppLifecycleState);
//    switch (state) {
//      // App进去前台
//      case AppLifecycleState.resumed:
//        break;
//      // 不常用：应用程序处于非活动状态，并且未接收用户输入时调用，比如：来了个电话
//      case AppLifecycleState.inactive:
//        print('应用程序处于非活动状态，并且未接收用户输入');
//        break;
//      // App进入后台
//      case AppLifecycleState.paused:
//        print('用户当前看不到应用程序，没有响应');
//        break;
////      // 不常用：应用程序被挂起是调用，它不会在iOS上触发
//      default:
////      case AppLifecycleState.suspending:
////        print('应用程序将暂停。');
////        break;
//    }
//  }

//  void _getData() async {
//    await DioUtil.request("xxx",
//      method: DioUtil.GET,
//    ).then((res) {
//      var time = res.orderExprieTime;
//      if(time !=null){
//        try{
//          var _diffDate = DateTime.parse(time.toString());
//          //获取当期时间
//          var now = DateTime.now();
//          var twoHours = _diffDate.difference(now);
//          //获取总秒数，2 分钟为 120 秒
//          seconds = twoHours.inSeconds;
//          startTimer();
//        }catch(e){
//          seconds = 0;
//        }
//      }
//    }
//        loading = true;
//        if(!mounted)return;
//    setState(() {
//    });
//  }).catchError((e){
//  });
//  }

  List<Widget> _imgList(String imagesStr) {
    List<Widget> list = [];
    List imagesList = [];
    if (imagesStr != null && imagesStr != "") {
      imagesList = imagesStr.split(',');
      for (int i = 0; i < imagesList.length; i++) {
        list.add(
          GestureDetector(
            onTap: () {
              //FadeRoute是自定义的切换过度动画（渐隐渐现） 如果不需要 可以使用默认的MaterialPageRoute
              /* Navigator.of(context).push(new MaterialPageRoute(page: PhotoViewGalleryScreen(
              images: newImgArr,//传入图片list
              index: i,//传入当前点击的图片的index
              heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
            )));*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoViewGalleryScreen(
                      images: imagesList, index: i, heroTag: 'simple'),
                ),
              );
            },
            child: Container(
              child: ClipRRect(
                child: Image.network(
                  '${imagesList[i]}',
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setHeight(200),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      }
    }

    return list;
  }

  _buildWorks(List<SubItems> items) {
    List<Widget> list = [];
    if (items != null) {
      if (items.length != 0) {
        for (int i = 0; i < items.length; i++) {
          list.add(Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
            decoration: BoxDecoration(
              color: ColorUtil.color('#ffffff'),
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: ColorUtil.color('#EAEAEA'))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(24)),
                            width: ScreenUtil().setWidth(8),
                            height: ScreenUtil().setHeight(36),
                            decoration: BoxDecoration(
                                color: ColorUtil.color('#F87E20'),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                      ScreenUtil().setWidth(200)),
                                  bottomRight: Radius.circular(
                                      ScreenUtil().setWidth(200)),
                                )),
                          ),
                          Text(
                              '${items[i].structureName}' +
                                  (items[i].position != null &&
                                          items[i].position != ""
                                      ? ' (${items[i].position})'
                                      : ''),
                              style: TextStyle(
                                color: ColorUtil.color('#333333'),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(36),
                              ))
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(32)),
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildSub(items[i].structureItems),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
        }
      }
    }

    return list;
  }

  _buildSub(List<StructureItems> structureItems) {
    List<Widget> list = [];
    if (structureItems.length != 0) {
      for (int i = 0; i < structureItems.length; i++) {
        list.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              width: ScreenUtil().setWidth(194),
              child: Text('${i + 1}.${structureItems[i].name}',
                  style: TextStyle(
                    color: ColorUtil.color('#333333'),
                    fontSize: ScreenUtil().setSp(28),
                  )),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(24),
                  ScreenUtil().setHeight(16),
                  ScreenUtil().setWidth(24),
                  ScreenUtil().setHeight(24)),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
              decoration: BoxDecoration(
                color: ColorUtil.color('#F7F8FA'),
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                    child: Text(
                      '清洁程度：${structureItems[i].cleanLevel}',
                      style: TextStyle(
                          color: ColorUtil.color('#666666'),
                          fontSize: ScreenUtil().setSp(26)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                    child: Text(
                      '清洁工具： ${structureItems[i].cleanTools}',
                      style: TextStyle(
                          color: ColorUtil.color('#666666'),
                          fontSize: ScreenUtil().setSp(26)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                    child: Text(
                      '验收标准： ${structureItems[i].acceptNormal}',
                      style: TextStyle(
                          color: ColorUtil.color('#666666'),
                          fontSize: ScreenUtil().setSp(26)),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
      }
    } else {
      list.add(Text(
        '系统任务正在生成中...请稍后查看',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(26),
            color: ColorUtil.color('#666666')),
      ));
    }

    return list;
  }

  Future _submitOrder() async {
    setState(() {
      isLoading = true;
    });
    putRequest('finishTask', context, joint: '/${widget.id}').then((res) {
      CodeRes resp = CodeRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        Application.router.pop(context);
      } else {
        showToast(resp.message);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future _startService() async {
    setState(() {
      isLoading = true;
    });
    putRequest('beginTask', context, joint: '/${widget.id}').then((res) {
      CodeRes resp = CodeRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        _getDetailData();
      } else {
        showToast(resp.message);
      }
    });
  }
}
