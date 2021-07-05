import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiamei_employee_flutter/common/ComPageWidget.dart';
import 'package:jiamei_employee_flutter/models/codeRes.dart';
import 'package:jiamei_employee_flutter/models/opinionParams.dart';
import 'package:jiamei_employee_flutter/models/uploadPicRes.dart';
import 'package:jiamei_employee_flutter/router/Application.dart';
import 'package:jiamei_employee_flutter/services/service_method.dart';
import 'package:permission_handler/permission_handler.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> with ComPageWidget {
  FocusNode blankNode = FocusNode();
  List _images = [];
  bool isLoading = false;
  OpinionParams fromParams = new OpinionParams();
  TextEditingController _contentController = new TextEditingController();
  List<String> _photo = ['拍照', '相册'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorUtil.color('#F3F4F5'),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorUtil.color('#333333')),
        title: Text(
          '意见反馈',
          style: TextStyle(color: ColorUtil.color('#333333')),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        // 设置状态栏字体颜色 一般有Brightness.dark,和Brightness.light两种模式
        elevation: 0,
        // 默认是4， 设置成0 就是没有阴影了
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () {
          // 点击空白页面关闭键盘
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(24),
                          ScreenUtil().setHeight(24),
                          ScreenUtil().setWidth(24),
                          ScreenUtil().setHeight(40)),
                      child: Column(
                        children: <Widget>[
                          /// 问题描述
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(8))),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /// 请假事由
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(8))),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: '问题描述',
                                                  style: TextStyle(
                                                    color: ColorUtil.color('#333333'),
                                                    fontSize: ScreenUtil().setSp(32),
                                                  )),
                                            ])),
                                      ),
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(28)),
                                          child: TextField(
                                              controller: _contentController,
                                              onChanged: (text) {
//                                              setState(() {
//                                                fromParams.opinion = text;
//                                              });
//                                              _contentController.text = text;
                                              },
                                              maxLines: 5,
                                              textInputAction:
                                              TextInputAction.done,
                                              style: TextStyle(
                                                  fontSize:
                                                  ScreenUtil().setSp(32),
                                                  textBaseline:
                                                  TextBaseline.alphabetic),
                                              decoration: InputDecoration(
                                                fillColor:
                                                ColorUtil.color('#ffffff'),
                                                filled: true,
                                                contentPadding: EdgeInsets.all(
                                                  ScreenUtil().setSp(20),
                                                ),
                                                hintText: "请详细描述问题",
                                                border: InputBorder.none,
                                                hasFloatingPlaceholder: false,
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          /// 上传 图片
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                            width: double.infinity,
                            padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(8))),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /// 照片
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(8))),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: '照片',
                                                  style: TextStyle(
                                                    color: ColorUtil.color('#333333'),
                                                    fontSize: ScreenUtil().setSp(32),
                                                  )),
                                            ])),
                                      ),

                                      /// images
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(50)),
                                        child: Wrap(
                                            spacing: ScreenUtil().setWidth(22),
                                            //主轴上子控件的间距
                                            runSpacing:
                                            ScreenUtil().setHeight(22),
                                            //交叉轴上子控件之间的间距
                                            children: _buildImages(context)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                )),
            Container(
              width: double.infinity,
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
                      fontSize: ScreenUtil().setSp(28),
                    )),
                onPressed: () {
                  _submitOpinion();
                },
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
      fromParams.opinion = "";
      fromParams.pictures = "";
    });
  }

  Future _submitOpinion() async {
    print(_contentController.text);
    if (_contentController.text == "") return showToast('请填写描述');
    if (_images.length == 0) return showToast('请上传图片');
    fromParams.opinion = _contentController.text;
    fromParams.pictures = _images.join(',');
    await postRequest('addOpinion', context, formData: fromParams).then((res) {
      CodeRes resp = CodeRes.fromJson(json.decode(res.toString()));
      if (resp.code == 0) {
        showToast('意见反馈成功');
        Application.router.pop(context);
      } else {
        showToast(resp.message);
      }
    });
  }

  List<Widget> _buildImages(BuildContext context) {
    List<Widget> widgets = [];
    _images.forEach((val) {});
    for (int i = 0; i < _images.length; i++) {
      widgets.add(Stack(
        alignment: AlignmentDirectional.topEnd,
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(22),
                right: ScreenUtil().setHeight(22)),
            child: Image.network(
              _images[i],
              width: ScreenUtil().setWidth(170),
              height: ScreenUtil().setHeight(170),
            ),
          ),
          Positioned(
              right: ScreenUtil().setWidth(0),
              top: ScreenUtil().setHeight(0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showCustomDialog(context, '确定删除', () {
                    setState(() {
                      _images.remove(_images[i]);
                    });
                    Application.router.pop(context);
                  });
                },
                child: Container(
                  width: ScreenUtil().setWidth(44),
                  height: ScreenUtil().setHeight(44),
                  child: Image.asset(
                    'lib/images/icons/del_photo_icon.png',
                  ),
                ),
              ))
        ],
      ));
    }
    widgets.add(GestureDetector(
      onTap: () {
//        _photoClick(0);
        _showModalBottomSheet(context);
      },
      child: Image.asset(
        'lib/images/photo_img.png',
        width: ScreenUtil().setWidth(192),
        height: ScreenUtil().setHeight(192),
      ),
    ));
    return widgets;
  }

  /* 拍照 */
  Future _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: 70, maxWidth: 800);
    if (pickedFile != null) {
      uploadFilePic('uploadImage', context, pickedFile.path).then((res) {
        UploadPicRes resp = UploadPicRes.fromJson(json.decode(res.toString()));
        if (resp.code == 0) {
          setState(() {
            _images.add(resp.data);
          });
        } else {
          showToast(resp.message);
        }
      });
    } else {
      showToast('上传失败，请重新上传');
    }
  }

  /* 相册 */
  _openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 800);
    if (pickedFile != null) {
      uploadFilePic('uploadImage', context, pickedFile.path).then((res) {
        UploadPicRes resp = UploadPicRes.fromJson(json.decode(res.toString()));
        if (resp.code == 0) {
          setState(() {
            _images.add(resp.data);
          });
        } else {
          showToast(resp.message);
        }
      });
    } else {
      showToast('上传失败，请重新上传');
    }
  }

  void _photoClick(int index) async {
    //请求权限
    if (Platform.isIOS) {
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.camera);
      if (status.value == 1) {
        if (index == 0) {
          _takePhoto();
        } else {
          _openGallery();
        }
      } else {
        //有可能是的第一次请求
        if (index == 0) {
          _takePhoto();
        } else {
          _openGallery();
        }
        showToast("请授予权限");
      }
    } else if (Platform.isAndroid) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.camera]);
      if (permissions[PermissionGroup.camera] != PermissionStatus.granted) {
        showToast("请到设置中授予权限");
      } else {
        if (index == 0) {
          _takePhoto();
        } else {
          _openGallery();
        }
      }
    }
    return;
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: ListView(
            children: List.generate(
          2,
          (index) => InkWell(
              child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: Text(_photo[index])),
              onTap: () {
                Application.router.pop(context);
                _photoClick(index);
              }),
        )),
        height: 120,
      ),
    );
  }
}
