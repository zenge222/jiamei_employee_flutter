import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/models/claimListRes.dart';
import 'package:jiamei_employee_flutter/models/claimParams.dart';
import 'package:jiamei_employee_flutter/models/claimRecordRes.dart';
import 'package:jiamei_employee_flutter/models/codeRes.dart';
import 'package:jiamei_employee_flutter/models/leaveRes.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';

class GoodsApply extends StatefulWidget {
  @override
  _GoodsApplyState createState() => _GoodsApplyState();
}

class _GoodsApplyState extends State<GoodsApply> with ComPageWidget {
  List<String> subTabs = ['申领申请', '申领记录'];
  int subTabsIndex = 0;
  List resList = [];
  List claimList = [];
  List popList = [];
  bool isLoading = false; // 是否首次数据加载 不关闭-->请求错误或数据返回问题
  bool isGetAll = false; // 数据是否全部获取
  ClaimParams paramsData = new ClaimParams();
  ScrollController _scrollController = ScrollController();
  int pageNum = 1;
  int pageSize = 10;
  String reason = "";
  List<Widget> _list = <Widget>[
    ClipRRect(
      child: Image.asset(
        'lib/images/icons/my.png',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'lib/images/icons/my.png',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '物品申领',
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
              child: subTabsIndex == 0
                  ? ListView(
                      children: _leaveFrom(context),
                    )
                  : _buildList(),
            )),

            /// 底部按钮
            Offstage(
              offstage: subTabsIndex != 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(32),
                    ScreenUtil().setHeight(12),
                    ScreenUtil().setWidth(32),
                    ScreenUtil().setHeight(12)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    //阴影效果
                    BoxShadow(
                      offset: Offset(0.0, 0.0),
                      // 阴影在X轴和Y轴上的偏移
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      // 阴影颜色
                      blurRadius: 10.0,
                      // 阴影程度
                      spreadRadius: 0.0, // 阴影扩散的程度 取值可以正数,也可以是负数
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (popList.length > 0) {
                              _btnSheet(context);
                            }
                          },
                          child: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Image.asset(
                                'lib/images/icons/cart_icon.png',
                                width: ScreenUtil().setWidth(60),
                              ),
                              Positioned(
                                  left: ScreenUtil().setWidth(44),
                                  top: ScreenUtil().setHeight(-16),
                                  child: Offstage(
                                    offstage: popList.length == 0,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenUtil().setWidth(8),
                                          ScreenUtil().setHeight(2),
                                          ScreenUtil().setWidth(8),
                                          ScreenUtil().setHeight(2)),
                                      decoration: BoxDecoration(
                                        color: ColorUtil.color('#FF382D'),
                                        border: Border.all(
                                            width: ScreenUtil().setWidth(6),
                                            color: ColorUtil.color('#ffffff')),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(100))),
                                      ),
                                      child: Center(
                                        child: Text('${popList.length}',
                                            style: TextStyle(
                                              color: ColorUtil.color('#ffffff'),
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(24),
                                            )),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(42)),
                          child: Text('您申领的物品',
                              style: TextStyle(
                                color: ColorUtil.color('#333333'),
                                fontSize: ScreenUtil().setSp(28),
                              )),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _showPop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(0),
                            ScreenUtil().setHeight(24),
                            ScreenUtil().setWidth(0),
                            ScreenUtil().setHeight(24)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            ColorUtil.color('#FFA412'),
                            ColorUtil.color('#F87E20')
                          ]),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        width: ScreenUtil().setWidth(200),
                        child: Text('申请',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorUtil.color('#ffffff'),
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(28),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading= true;
    });
    _getClaimList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isGetAll) {
          if (subTabsIndex == 1) {
            _getClaimRecord();
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
      claimList = [];
      popList = [];
      isGetAll = false;
    });
    print(i);
    if (i == 0) {
      _getClaimList();
    } else {
      _getClaimRecord();
    }
  }

  Future _getClaimList() async {
    await getRequest("storeMaterialStockList", context,
            joint: '?pageSize=${999}&pageNumber=${1}')
        .then((res) {
      ClaimListRes resp = ClaimListRes.fromJson(json.decode(res.toString()));
      paramsData.itemList = [];
      paramsData.reason = "";
      resp.data.forEach((val) {
        ItemList item = new ItemList();
        item.claimNumber = 0;
        item.amount = val.amount;
        item.picture = val.picture;
        item.name = val.name;
        item.brand = val.brand;
        item.model = val.model;
        item.stockId = val.id;
        paramsData.itemList.add(item);
      });
      if (resp.code == 0) {
        pageNum++;
        setState(() {
          isLoading = false;
          resList.addAll(paramsData.itemList);
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

  Future _getClaimRecord() async {
    await getRequest("selfMaterialClaimList", context,
            joint: '?pageSize=${pageSize}&pageNumber=${pageNum}')
        .then((res) {
      ClaimRecordRes resp =
          ClaimRecordRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        pageNum++;
        setState(() {
          isLoading = false;
          claimList.addAll(resp.data);
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

  List<Widget> _leaveFrom(BuildContext context) {
    List<Widget> widgets = [];
    if (resList != null) {
      if (resList.length != 0) {
        for (int i = 0; i < resList.length; i++) {
          widgets.add(Container(
            width: double.infinity,
            padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(16))),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.network(
                            '${resList[i].picture}',
                            width: ScreenUtil().setWidth(140),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${resList[i].name}',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(32),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(8)),
                                  child: Text('库存：${resList[i].amount}',
                                      style: TextStyle(
                                        color: ColorUtil.color('#666666'),
                                        fontSize: ScreenUtil().setSp(28),
                                      )),
                                ),
//                                Padding(
//                                  padding: EdgeInsets.only(
//                                      top: ScreenUtil().setHeight(8)),
//                                  child: Text('单价：¥45',
//                                      style: TextStyle(
//                                        color: ColorUtil.color('#666666'),
//                                        fontSize: ScreenUtil().setSp(28),
//                                      )),
//                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: ScreenUtil().setHeight(56),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          border: Border.all(
                              color: ColorUtil.color('#d1d1d1'), width: 0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _minusNum(resList[i], i);
                              },
                              child: Container(
                                width: 32.0,
                                color: Color(0xfff5f5f5),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/images/icons/icon-minus.png',
                                  width: ScreenUtil().setWidth(24),
                                ), // 设计图
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(1),
                              color: ColorUtil.color('#d1d1d1'),
                            ),
                            Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(
                                '${resList[i].claimNumber}',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black),
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(1),
                              color: ColorUtil.color('#d1d1d1'),
                            ),
                            GestureDetector(
                              onTap: () {
                                _addNum(resList[i], i);
                              },
                              child: Container(
                                color: Color(0xfff5f5f5),
                                width: 32.0,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/images/icons/icon-plus.png',
                                  width: ScreenUtil().setWidth(24),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
        }
      }
    }
    return widgets;
  }

  void _btnSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenUtil().setWidth(16)),
            topRight: Radius.circular(ScreenUtil().setWidth(16)),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: ScreenUtil().setHeight(600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(440),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(32),
                      top: ScreenUtil().setWidth(40)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(24)),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: ScreenUtil().setWidth(1),
                                  color: ColorUtil.color('#EAEAEA'))),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('申领单',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(36),
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    Application.router.pop(context);
                                  },
                                  child: Image.asset(
                                    'lib/images/icons/close_icon.png',
                                    width: ScreenUtil().setWidth(32),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(20),
                                  bottom: ScreenUtil().setHeight(20)),
                              child: Text('物品损坏丢失需要赔付，请小心保管',
                                  style: TextStyle(
                                    color: ColorUtil.color('#aaaaaa'),
                                    fontSize: ScreenUtil().setSp(28),
                                  )),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildSelected(),
                        ),
                      ))),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(32),
                      ScreenUtil().setHeight(12),
                      ScreenUtil().setWidth(32),
                      ScreenUtil().setHeight(12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      //阴影效果
                      BoxShadow(
                        offset: Offset(0.0, 0.0),
                        // 阴影在X轴和Y轴上的偏移
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        // 阴影颜色
                        blurRadius: 10.0,
                        // 阴影程度
                        spreadRadius: 0.0, // 阴影扩散的程度 取值可以正数,也可以是负数
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //
                      Row(
                        children: <Widget>[
                          Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Image.asset(
                                'lib/images/icons/cart_icon.png',
                                width: ScreenUtil().setWidth(60),
                              ),
                              Positioned(
                                  left: ScreenUtil().setWidth(44),
                                  top: ScreenUtil().setHeight(-16),
                                  child: Offstage(
                                    offstage: popList.length == 0,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenUtil().setWidth(8),
                                          ScreenUtil().setHeight(2),
                                          ScreenUtil().setWidth(8),
                                          ScreenUtil().setHeight(2)),
                                      decoration: BoxDecoration(
                                        color: ColorUtil.color('#FF382D'),
                                        border: Border.all(
                                            width: ScreenUtil().setWidth(6),
                                            color: ColorUtil.color('#ffffff')),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(100))),
                                      ),
                                      child: Center(
                                        child: Text('${popList.length}',
                                            style: TextStyle(
                                              color: ColorUtil.color('#ffffff'),
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(24),
                                            )),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(42)),
                            child: Text('您申领的物品',
                                style: TextStyle(
                                  color: ColorUtil.color('#333333'),
                                  fontSize: ScreenUtil().setSp(28),
                                )),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _showPop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(0),
                              ScreenUtil().setHeight(24),
                              ScreenUtil().setWidth(0),
                              ScreenUtil().setHeight(24)),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              ColorUtil.color('#FFA412'),
                              ColorUtil.color('#F87E20')
                            ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          width: ScreenUtil().setWidth(200),
                          child: Text('申请',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorUtil.color('#ffffff'),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(28),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildList() {
    if (claimList.length != 0) {
      return ListView.builder(
        //+1 for progressbar
        itemCount: claimList.length + 1,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index == claimList.length) {
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
                              text: '申领日期：',
                              style: TextStyle(
                                color: ColorUtil.color('#333333'),
                                fontSize: ScreenUtil().setSp(30),
                              )),
                          TextSpan(
                              text: '${claimList[index].createTime}',
                              style: TextStyle(
                                color: ColorUtil.color('#333333'),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(30),
                              )),
                        ])),
                        Text(
                            '${claimList[index].status == -1 ? '待审核' : (claimList[index] == 0 ? '不同意' : (claimList[index] == 1 ? '同意' : '已发放'))}',
                            style: TextStyle(
                              color: ColorUtil.color('#F87E20'),
                              fontWeight: FontWeight.bold,
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
                                child: Text('申领物品',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontSize: ScreenUtil().setSp(28),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children:
                              _buildClaimItemList(claimList[index].itemList),
                        ),
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

  void _minusNum(item, int i) {
    if (item.claimNumber != 0) {
      setState(() {
        popList = [];
        item.claimNumber -= 1;
      });
      List list = [];
      resList.forEach((val) {
        if (val.claimNumber > 0) {
          list.add(val);
        }
      });
      setState(() {
        popList = list;
      });
    }
  }

  void _addNum(item, int i) {
    if (item.claimNumber < item.amount) {
      setState(() {
        item.claimNumber += 1;
      });
      List list = [];
      resList.forEach((val) {
        if (val.claimNumber > 0) {
          list.add(val);
        }
      });
      setState(() {
        popList = list;
      });
    }
  }

  List<Widget> _buildSelected() {
    List<Widget> list = [];
    popList.forEach((val) {
      list.add(Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        child: Text('${val.name}  x${val.claimNumber}',
            style: TextStyle(
              color: ColorUtil.color('#333333'),
              fontSize: ScreenUtil().setSp(32),
            )),
      ));
    });
    return list;
  }

  void _showPop(BuildContext context) {
    if (popList.length == 0) return showToast('请选择物品');
    showDialog<Null>(
        context: context,
        // 点击背景区域是否可以关闭
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: ScreenUtil().setWidth(600),
                  decoration: BoxDecoration(
                    color: ColorUtil.color('#FDFAFE'),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(30),
                            bottom: ScreenUtil().setHeight(20)),
                        child: Text(
                          '申请理由',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              fontSize: ScreenUtil().setSp(36),
                              color: Color.fromRGBO(0, 0, 0, 0.8)),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(24),
                            ScreenUtil().setHeight(24),
                            ScreenUtil().setWidth(24),
                            ScreenUtil().setHeight(0)),
                        decoration: BoxDecoration(
                          color: ColorUtil.color('#F5F6F9'),
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(8))),
                        ),
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(32),
                            ScreenUtil().setHeight(20),
                            ScreenUtil().setWidth(32),
                            ScreenUtil().setHeight(20)),
                        child: Row(
                          children: <Widget>[
                            Material(
                              child: Container(
                                width: ScreenUtil().setWidth(480),
                                child: TextField(
//                                    key: _newContentKey2,
//                                    controller: _contentController,
                                    onChanged: (text) {
                                      setState(() {
                                        reason = text;
                                      });
                                    },
                                    inputFormatters: <TextInputFormatter>[
//                                    WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                      LengthLimitingTextInputFormatter(300)
                                      //限制长度
                                    ],
                                    maxLines: 5,
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(32),
                                        textBaseline: TextBaseline.alphabetic),
                                    decoration: InputDecoration(
                                      fillColor: ColorUtil.color('#F5F6F9'),
                                      filled: true,
                                      contentPadding: EdgeInsets.all(
                                        ScreenUtil().setSp(20),
                                      ),
                                      hintText: "请输入详情描述",
                                      border: InputBorder.none,
                                      hasFloatingPlaceholder: false,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),

                      /// 底部操作
                      Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: ColorUtil.color('#ededed'))),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorUtil.color('#EAEAEA'),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          ScreenUtil().setWidth(14))),
                                ),
                                child: OutlineButton(
                                  onPressed: () async {
                                    Application.router.pop(context);
                                  },
                                  borderSide: BorderSide.none,
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(32),
                                        color: ColorUtil.color('#333333')),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorUtil.color('#CF241C'),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          ScreenUtil().setWidth(14))),
                                ),
                                child: OutlineButton(
                                  onPressed: () async {
                                    _submitClaim(context);
                                  },
                                  borderSide: BorderSide.none,
                                  child: Text(
                                    '确定',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(32),
                                        color: ColorUtil.color('#ffffff')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future _submitClaim(BuildContext context) async {
    if (reason == "") return showToast('请填写申请原因');
    paramsData.reason = reason;
    print(paramsData.reason);
    print(paramsData.itemList[0].claimNumber);
    print(paramsData.itemList[0].stockId);
    await postRequest('claimClaim', context, formData: paramsData).then((res) {
      CodeRes resp = CodeRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        Application.router.pop(context);
        setState(() {
          pageNum = 1;
          claimList = [];
          isGetAll = false;
          isGetAll = false;
          subTabsIndex = 1;
        });
        _getClaimRecord();
      }
      showToast(resp.message);
    });
  }

  _buildClaimItemList(itemList) {
    List<Widget> list = [];
    itemList.forEach((val) {
      list.add(Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${val.stockName}  x${val.claimNumber}',
                style: TextStyle(
                  color: ColorUtil.color('#333333'),
                  fontSize: ScreenUtil().setSp(28),
                )),
//                              Text('单价：¥1345',
//                                  style: TextStyle(
//                                    color: ColorUtil.color('#666666'),
//                                    fontSize: ScreenUtil().setSp(28),
//                                  ))
          ],
        ),
      ));
    });

    return list;
  }
}
