import 'package:json_annotation/json_annotation.dart';

part 'meetListVO.g.dart';

@JsonSerializable()
class MeetListVO {
    MeetListVO();

    @JsonKey(name:'id') int id;
    
    factory MeetListVO.fromJson(Map<String,dynamic> json) => _$MeetListVOFromJson(json);
    Map<String, dynamic> toJson() => _$MeetListVOToJson(this);
}
