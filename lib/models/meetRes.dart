import 'package:json_annotation/json_annotation.dart';
import "meetListVO.dart";
part 'meetRes.g.dart';

@JsonSerializable()
class MeetRes {
    MeetRes();

    @JsonKey(name:'code') int code;
    String message;
    List<MeetListVO> data;
    
    factory MeetRes.fromJson(Map<String,dynamic> json) => _$MeetResFromJson(json);
    Map<String, dynamic> toJson() => _$MeetResToJson(this);
}
