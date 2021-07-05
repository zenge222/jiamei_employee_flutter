import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/models/codeRes.dart';
import 'package:jiamei_employee_flutter/models/messageListRes.dart';
import 'package:jiamei_employee_flutter/pages/messageDetail.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> with ComPageWidget {
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
        actions: <Widget>[
          FlatButton(
            child: Text("清除未读",
                style: TextStyle(
                  color: ColorUtil.color('#333333'),
                  fontSize: ScreenUtil().setSp(32),
                )),
            onPressed: () {
              showCustomDialog(context, "确定清除未读?", () {
                _readAll();
              });
            },
          ),
        ],
        title: Text(
          '消息',
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
        child: Container(
          margin: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(24),
              ScreenUtil().setHeight(0),
              ScreenUtil().setWidth(24),
              ScreenUtil().setHeight(40)),
          child: _buildList(),
        ),
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
    _getList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isGetAll) {
          _getList();
        }
      }
    });
  }

  Future _getList() async {
//
    await getRequest("selfNotifyList", context,
            joint: '?pageSize=${pageSize}&pageNumber=${pageNum}')
        .then((res) {
      MessageListRes resp =
          MessageListRes.fromJson(json.decode(res.toString()));
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

  Future _readAll() async {
    await putRequest("readAllNotify", context).then((res) {
      CodeRes resp = CodeRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          pageNum = 1;
          resList = [];
          isGetAll = false;
        });
        Application.router.pop(context);
        _getList();
      }
      showToast(resp.message);
    });
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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MessageDetail(id: resList[index].id),
                    )).then((data) {
                  setState(() {
                    pageNum = 1;
                    resList = [];
                    isGetAll = false;
                  });
                  _getList();
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
                decoration: BoxDecoration(
                  color: ColorUtil.color('#ffffff'),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(8))),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(88),
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                      child: Image.asset(
                        'lib/images/message_icon1.png',
                      ),
                    ),
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('系统通知'),
                            Text('${resList[index].createTime}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(450),
                              child: Text('${resList[index].content}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle()),
                            ),
                            Offstage(
                              offstage: resList[index].status == 1,
                              child: Container(
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setHeight(20),
                                decoration: BoxDecoration(
                                  color: ColorUtil.color('#F96158'),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(100))),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
            );
          }
        },
      );
    } else {
      return Center(
        child: Image.asset(
          'lib/images/no_message_list.png',
          width: ScreenUtil().setWidth(400),
        ),
      );
    }
  }
}
