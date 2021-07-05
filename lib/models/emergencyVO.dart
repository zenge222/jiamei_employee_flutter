import 'package:json_annotation/json_annotation.dart';

part 'emergencyVO.g.dart';

@JsonSerializable()
class EmergencyVO {
    EmergencyVO();

    String cleanerName;
    String content;
    String createTime;
    @JsonKey(name:'id') int id;
    String images;
    String organizationBranchName;
    String title;
    
    factory EmergencyVO.fromJson(Map<String,dynamic> json) => _$EmergencyVOFromJson(json);
    Map<String, dynamic> toJson() => _$EmergencyVOToJson(this);
}
