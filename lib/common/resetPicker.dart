import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// https://blog.csdn.net/iotjin/article/details/104362491?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1.control
const double kPickerHeight = 216.0;
const double kItemHeight = 40.0;
const Color kBtnColor = Color(0xFF323232);//50
const Color kTitleColor = Color(0xFF787878);//120
const double kTextFontSize = 17.0;

typedef StringClickCallback = void Function(int selectIndex,Object selectStr);
typedef ArrayClickCallback = void Function( List<int> selecteds,List<dynamic> strData);
typedef selectedCallback = void Function(Picker picker, int index, List<int> selecteds);
typedef DateClickCallback = void Function(dynamic selectDateStr,dynamic selectDate);

enum DateType {
  YMD,        // y, m, d
  YM,        // y ,m
  kY,        // y ,m
  YMD_HM,     // y, m, d, hh, mm
  YMD_AP_HM,  // y, m, d, ap, hh, mm
  kHM_AP,     // hh, mm, ap(AM/PM)
  kHM // hh, mm
}

class ResetPicker {

  /** 单列*/
  static void showStringPicker<T>(
      BuildContext context, {
        @required List<T> data,
        String title,
        int normalIndex,
        PickerDataAdapter adapter,
        @required StringClickCallback clickCallBack,
      }) {

    openModalPicker(context,
        adapter: adapter ??  PickerDataAdapter( pickerdata: data, isArray: false),
        clickCallBack:(Picker picker, List<int> selecteds){
          //          print(picker.adapter.text);
          clickCallBack(selecteds[0],data[selecteds[0]]);
        },
        selecteds : [normalIndex??0] ,
        title: title);
  }

  /** 多列 */
  static void showArrayPicker<T>(
      BuildContext context, {
        @required List<T> data,
        String title,
        List<int> normalIndex,
        PickerDataAdapter adapter,
        @required ArrayClickCallback clickCallBack,
        @required PickerSelectedCallback selectedCallback,
      }) {
    openModalPicker(context,
        adapter: adapter ??  PickerDataAdapter( pickerdata: data, isArray: true),
        clickCallBack:(Picker picker, List<int> selecteds){
          clickCallBack(selecteds,picker.getSelectedValues());
        },
        selectedCallback:(Picker picker, int index, List<int> selecteds){
          selectedCallback(picker,index,selecteds);
        },
        selecteds: normalIndex,
        title: title);

  }


  static void openModalPicker(
      BuildContext context, {
        @required PickerAdapter adapter,
        String title,
        List<int> selecteds,
        @required PickerConfirmCallback clickCallBack,
        @required PickerSelectedCallback selectedCallback,

      }) {
    new Picker(
      adapter: adapter,
      title: Text(title ?? "请选择",style:TextStyle(color: ColorUtil.color('#000000'),fontSize: ScreenUtil().setSp(34))),
      selecteds: selecteds,
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(color: ColorUtil.color('#CF241C'),fontSize: ScreenUtil().setSp(34)),
      confirmTextStyle: TextStyle(color: ColorUtil.color('#CF241C'),fontSize: ScreenUtil().setSp(34)),
      textAlign: TextAlign.right,
      itemExtent: kItemHeight,
      height: kPickerHeight,
      selectedTextStyle: TextStyle(color: Colors.black),
      onConfirm:clickCallBack,
      onSelect:selectedCallback,
    ).showModal(context);
  }


  /** 日期选择器*/
  static void showDatePicker(
      BuildContext context, {
        DateType dateType,
        String title,
        DateTime maxValue,
        DateTime minValue,
        DateTime value,
        DateTimePickerAdapter adapter,
        @required DateClickCallback clickCallback,
      }) {

    int timeType;
    if(dateType == DateType.YM){
      timeType =  PickerDateTimeType.kYM;
    }else if(dateType == DateType.YMD_HM){
      timeType =  PickerDateTimeType.kYMDHM;
    }else if(dateType == DateType.kY){
      timeType =  PickerDateTimeType.kY;
    }else if(dateType == DateType.YMD_AP_HM){
      timeType =  PickerDateTimeType.kYMD_AP_HM;
    }else if(dateType == DateType.kHM_AP){
      timeType =  PickerDateTimeType.kHM_AP;
    }else if(dateType == DateType.kHM){
      timeType =  PickerDateTimeType.kHM;
    }else{
      timeType =  PickerDateTimeType.kYMD;
    }

    openModalPicker(context,
        adapter: adapter ??
            DateTimePickerAdapter(
              type: timeType,
              isNumberMonth: true,
              yearSuffix: "年",  // 年
              monthSuffix: "月", // 月
              daySuffix: "日",   // 日
              strAMPM: const["上午", "下午"],
              maxValue: maxValue ,
              minValue: minValue,
              value: value ?? DateTime.now(),
            ),
        title: title,
        clickCallBack:(Picker picker, List<int> selecteds){

          var time = (picker.adapter as DateTimePickerAdapter).value;
          var timeStr;
          String getMonth = time.month>=10?'${time.month}':'0${time.month}';
          String getDay = time.day<10?'0${time.day}':'${time.day}';
          String hour =time.hour<10?'0${time.hour}':'${time.hour}';
          String minute =time.minute<10?'0${time.minute}':'${time.minute}';

          if(dateType == DateType.YM){ // YMD
//            timeStr =time.year.toString()+"年"+time.month.toString()+"月";
            timeStr =time.year.toString()+"-"+getMonth;
          }else if(dateType == DateType.YMD){
            timeStr =time.year.toString()+"-"+getMonth+"-"+getDay;
          }else if(dateType == DateType.kY){
            timeStr =time.year.toString();
          }else if(dateType == DateType.YMD_HM){
            timeStr =time.year.toString()+"-"+getMonth+"-"+getDay+" "+hour+":"+minute;
//            timeStr =time.year.toString()+"年"+getMonth+"月"+time.day.toString()+"日"+time.hour.toString()+"时"+time.minute.toString()+"分";
          }else if(dateType == DateType.YMD_AP_HM){
            var str = formatDate(time, [am])=="AM" ? "上午":"下午";
            timeStr =time.year.toString()+"年"+getMonth+"月"+time.day.toString()+"日"+str+time.hour.toString()+"时"+time.minute.toString()+"分";
          }else if(dateType == DateType.kHM){
            String hour = time.hour>=10?time.hour.toString():'0${time.hour}';
            String minute = time.minute>=10?time.minute.toString():'0${time.minute}';
            timeStr = hour+":"+ minute;
          }else{
//            timeStr =time.year.toString()+"年"+time.month.toString()+"月"+time.day.toString()+"日";
            timeStr =time.year.toString()+"-"+getMonth+"-"+time.day.toString();
          }
//          print(formatDate(DateTime(1989, 02, 21), [yyyy, '-', mm, '-', dd]));
          clickCallback(timeStr,picker.adapter.text);

        }

    );

  }



}