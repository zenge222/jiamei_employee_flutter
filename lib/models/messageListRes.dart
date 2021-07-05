class MessageListRes {
  int code;
  List<MessageItem> data;
  String message;

  MessageListRes({this.code, this.data, this.message});

  MessageListRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<MessageItem>();
      json['data'].forEach((v) {
        data.add(new MessageItem.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class MessageItem {
  String content;
  int createId;
  String createName;
  String createTime;
  int employeeId;
  String employeeName;
  int id;
  int status;
  int storeId;
  String storeName;
  int updateId;
  String updateName;
  String updateTime;

  MessageItem(
      {this.content,
        this.createId,
        this.createName,
        this.createTime,
        this.employeeId,
        this.employeeName,
        this.id,
        this.status,
        this.storeId,
        this.storeName,
        this.updateId,
        this.updateName,
        this.updateTime});

  MessageItem.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    createId = json['createId'];
    createName = json['createName'];
    createTime = json['createTime'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    id = json['id'];
    status = json['status'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    updateId = json['updateId'];
    updateName = json['updateName'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['createId'] = this.createId;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['id'] = this.id;
    data['status'] = this.status;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['updateId'] = this.updateId;
    data['updateName'] = this.updateName;
    data['updateTime'] = this.updateTime;
    return data;
  }
}