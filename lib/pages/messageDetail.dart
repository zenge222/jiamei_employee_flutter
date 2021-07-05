import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/common/loadingPage.dart';
import 'package:jiamei_employee_flutter/models/codeRes.dart';
import 'package:jiamei_employee_flutter/models/messageDetailRes.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';

class MessageDetail extends StatefulWidget {
  final int id;

  const MessageDetail({Key key, this.id}) : super(key: key);

  @override
  _MessageDetailState createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> with ComPageWidget {
  bool isLoading = false; // 是否首次数据加载 不关闭-->请求错误或数据返回问题
  MessageItem resData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '消息详情',
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
            ? Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(24),
                    right: ScreenUtil().setWidth(24),
                    bottom: ScreenUtil().setWidth(40)),
                child: SingleChildScrollView(
                    child:
//            Column(
//              children: _messagesBuild(),
//            ),
                        Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(40),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(88),
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(24)),
                        child: Image.asset(
                          'lib/images/message_icon1.png',
                        ),
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: ScreenUtil().setWidth(1),
                                    color: ColorUtil.color('#EAEAEA')))),
                        padding:
                            EdgeInsets.only(bottom: ScreenUtil().setHeight(28)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(24)),
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(24)),
                              decoration: BoxDecoration(
                                color: ColorUtil.color('#ffffff'),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(8))),
                              ),
                              child: Container(
                                width: double.infinity,
                                child: Text('${resData.content}',
                                    style: TextStyle(
                                      color: ColorUtil.color('#333333'),
                                      fontSize: ScreenUtil().setSp(32),
                                    )),
                              ),
                            ),
                            Text('${resData.createTime}',
                                style: TextStyle(
                                  color: ColorUtil.color('#999999'),
                                  fontSize: ScreenUtil().setSp(28),
                                ))
                          ],
                        ),
                      ))
                    ],
                  ),
                )),
              )
            : Text(""),
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
    print(widget.id);
    _getDetail();
  }

  Future _getDetail() async {
    await getRequest("notifyInfo", context, joint: '/${widget.id}').then((res) {
      MessageDetailRes resp =
          MessageDetailRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        setState(() {
          isLoading = false;
          resData = resp.data;
        });
        _readNotify();
      } else {
        showToast(resp.message);
      }
    });
  }

  Future _readNotify() async {
    await putRequest("readNotify", context, joint: '/${widget.id}').then((res) {
      CodeRes resp = CodeRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
      } else {
        showToast(resp.message);
      }
    });
  }
}
