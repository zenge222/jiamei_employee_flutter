// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dateVO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateVO _$DateVOFromJson(Map<String, dynamic> json) {
  return DateVO()
    ..state = json['state'] as int
    ..date = json['date'] as int
    ..select = json['select'] as bool;
}

Map<String, dynamic> _$DateVOToJson(DateVO instance) => <String, dynamic>{
      'state': instance.state,
      'date': instance.date,
      'select': instance.select
    };
