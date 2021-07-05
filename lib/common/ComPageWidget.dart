import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';

///统一存放每个页面需要用到的widget
class ComPageWidget {
  bool loading = false;
  ///整个页面加载进度条
  Widget renderPageProgress(bool loading) {
    if (loading) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorUtil.color('#22000000'),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      );
    } else {
      return Container(height: 0.0, width: 0.0);
    }
  }

  /// 数据加载
  Widget dataLoading() {
    return SpinKitCircle(
      color:ColorUtil.color('#F87E20'),
      size: 50.0,
    );
  }

  /// 加载更多
  Widget dataMoreLoading(bool isGetAll) {
    if (!isGetAll) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Opacity(
//            opacity: isGetMore ? 1.0 : 00,
            opacity:1.0,
            child: dataLoading(),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(
          ScreenUtil().setWidth(60),
        ),
        child: Center(
            child:
//          Opacity(
//              opacity: isLoadedAll ? 1.0 : 00,
//              child:
                Text(
          '没有更多了～',
          style: TextStyle(color: Color(0xff999999)),
        )
//          ),
            ),
      );
    }
  }

  ///吐司
  void showToast(String msg) async {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 15,
      gravity: ToastGravity.CENTER,
//        backgroundColor: Colors.red[600],
    );
  }

  /// ios风格Dialog
  void showCustomDialog(BuildContext context,String title,Function confirm){
    showDialog(
        context: context,
        // 点击背景区域是否可以关闭
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: ScreenUtil().setWidth(550),
                    decoration: BoxDecoration(
                      color: ColorUtil.color('#FDFAFE'),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(30),
                              bottom:
                              ScreenUtil().setHeight(20)),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration:
                                TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize:
                                ScreenUtil().setSp(36),
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.8)),
                          ),
                        ),
//                                          CleanerApplyDialog(response: applyData, itemIndex: changeIndex),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              top:
                              ScreenUtil().setHeight(30)),
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: ColorUtil.color(
                                        '#ededed'))),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorUtil.color(
                                        '#EAEAEA'),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(ScreenUtil().setWidth(14))),
                                  ),
                                  child: OutlineButton(
                                    onPressed: () async {
                                      Application.router.pop(context);
                                    },
                                    borderSide:
                                    BorderSide.none,
                                    child: Text(
                                      '取消',
                                      style: TextStyle(
                                          fontSize:
                                          ScreenUtil()
                                              .setSp(32),
                                          color:
                                          ColorUtil.color(
                                              '#333333')),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorUtil.color(
                                        '#F87E20'),
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(ScreenUtil().setWidth(14))),
                                  ),
                                  child: OutlineButton(
                                    onPressed: () async {
                                      confirm();
                                      },
                                    borderSide:
                                    BorderSide.none,
                                    child: Text(
                                      '确定',
                                      style: TextStyle(
                                          fontSize:
                                          ScreenUtil()
                                              .setSp(32),
                                          color:
                                          ColorUtil.color(
                                              '#ffffff')),
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
              ),
            ),
          );
        });
  }
}
