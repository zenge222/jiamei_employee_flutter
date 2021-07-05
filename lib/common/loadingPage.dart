import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';

class LoadingPage extends StatelessWidget with ComPageWidget {
  @required
  Widget child;
  @required
  bool isLoading;
  String text;

  //这里的child就是ViewGroup里面的子View
  //isShow就是控制loading视图隐藏 or 出现的参数
  //text就是loading控件下方的文字
  LoadingPage({Key key, this.child, this.isLoading, this.text = "数据请求中..."})
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    // children是自定义ViewGroup用来装子View，这里把外部的子View先添加进来
    children.add(child);
    //isShow用来判断移除Loading图的时机。
    if (isLoading) {
      //这里就开始创建半透明遮罩的子View了。然后添加进children数组里。
      //SizedBox.expand控制宽高占满全屏
      children.add(SizedBox.expand(
          child: Container(
        decoration: ShapeDecoration(
          color: Colors.black54,
          shape: RoundedRectangleBorder(),
        ),
        child: Center(
          //保证控件居中效果
          child: SizedBox(
            width: ScreenUtil().setWidth(240),
            height: ScreenUtil().setHeight(240),
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(16)),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//                       CircularProgressIndicator(),
                  dataLoading(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(30),
                    ),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ) // 创建透明层
          ));
    }
    //当添加子View后，把children数组给Stack构建出View视图。
    return Stack(children: children);
  }
}
