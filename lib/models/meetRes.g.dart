// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetRes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetRes _$MeetResFromJson(Map<String, dynamic> json) {
  return MeetRes()
    ..code = json['code'] as int
    ..message = json['message'] as String
    ..data = (json['data'] as List)
        ?.map((e) =>
            e == null ? null : MeetListVO.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$MeetResToJson(MeetRes instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data
    };
