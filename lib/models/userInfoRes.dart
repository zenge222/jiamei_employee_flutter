class UserInfoRes {
  int code;
  String message;
  UserInfo data;

  UserInfoRes({this.code, this.message, this.data});

  UserInfoRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new UserInfo.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class UserInfo {
  String name;
  String mobile;
  String storeName;
  String avatar;
  int storeId;

  UserInfo({this.name, this.mobile, this.storeName, this.avatar, this.storeId});

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    storeName = json['storeName'];
    avatar = json['avatar'];
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['storeName'] = this.storeName;
    data['avatar'] = this.avatar;
    data['storeId'] = this.storeId;
    return data;
  }
}