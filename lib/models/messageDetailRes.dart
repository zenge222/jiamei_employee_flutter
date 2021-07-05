class MessageDetailRes {
  int code;
  String message;
  MessageItem data;

  MessageDetailRes({this.code, this.message, this.data});

  MessageDetailRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new MessageItem.fromJson(json['data']) : null;
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

class MessageItem {
  int id;
  int createId;
  String createName;
  String createTime;
  int updateId;
  String updateName;
  String updateTime;
  int employeeId;
  String employeeName;
  String content;
  int status;
  int storeId;
  String storeName;

  MessageItem(
      {this.id,
        this.createId,
        this.createName,
        this.createTime,
        this.updateId,
        this.updateName,
        this.updateTime,
        this.employeeId,
        this.employeeName,
        this.content,
        this.status,
        this.storeId,
        this.storeName});

  MessageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createId = json['createId'];
    createName = json['createName'];
    createTime = json['createTime'];
    updateId = json['updateId'];
    updateName = json['updateName'];
    updateTime = json['updateTime'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    content = json['content'];
    status = json['status'];
    storeId = json['storeId'];
    storeName = json['storeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createId'] = this.createId;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['updateId'] = this.updateId;
    data['updateName'] = this.updateName;
    data['updateTime'] = this.updateTime;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['content'] = this.content;
    data['status'] = this.status;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    return data;
  }
}