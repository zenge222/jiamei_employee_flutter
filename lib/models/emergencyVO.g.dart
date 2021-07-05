// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergencyVO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencyVO _$EmergencyVOFromJson(Map<String, dynamic> json) {
  return EmergencyVO()
    ..cleanerName = json['cleanerName'] as String
    ..content = json['content'] as String
    ..createTime = json['createTime'] as String
    ..id = json['id'] as int
    ..images = json['images'] as String
    ..organizationBranchName = json['organizationBranchName'] as String
    ..title = json['title'] as String;
}

Map<String, dynamic> _$EmergencyVOToJson(EmergencyVO instance) =>
    <String, dynamic>{
      'cleanerName': instance.cleanerName,
      'content': instance.content,
      'createTime': instance.createTime,
      'id': instance.id,
      'images': instance.images,
      'organizationBranchName': instance.organizationBranchName,
      'title': instance.title
    };
