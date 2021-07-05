class MessageCountRes {
  int code;
  String message;
  int count;

  MessageCountRes({this.code, this.message, this.count});

  MessageCountRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['count'] = this.count;
    return data;
  }
}