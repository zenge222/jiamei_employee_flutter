import 'package:json_annotation/json_annotation.dart';

part 'dateVO.g.dart';

@JsonSerializable()
class DateVO {
    DateVO();

    @JsonKey(name:'state') int state;
    @JsonKey(name:'date') int date;
    bool select;
    
    factory DateVO.fromJson(Map<String,dynamic> json) => _$DateVOFromJson(json);
    Map<String, dynamic> toJson() => _$DateVOToJson(this);
}
