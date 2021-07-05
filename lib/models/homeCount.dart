class HomeCount {
  int code;
  String message;
  Data data;

  HomeCount({this.code, this.message, this.data});

  HomeCount.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int taskCount;
  int waitMeetCount;

  Data({this.taskCount, this.waitMeetCount});

  Data.fromJson(Map<String, dynamic> json) {
    taskCount = json['taskCount'];
    waitMeetCount = json['waitMeetCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskCount'] = this.taskCount;
    data['waitMeetCount'] = this.waitMeetCount;
    return data;
  }
}