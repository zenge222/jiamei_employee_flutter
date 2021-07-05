class OneDayRes {
  int code;
  String message;
  List<OneDayListItem> data;

  OneDayRes({this.code, this.message, this.data});

  OneDayRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<OneDayListItem>();
      json['data'].forEach((v) {
        data.add(new OneDayListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OneDayListItem {
  int id;
  int createId;
  String createName;
  String createTime;
  int updateId;
  String updateName;
  String updateTime;
  int employeeId;
  String employeeName;
  String contactName;
  String contactPhone;
  int orderId;
  int orderType;
  int payUserId;
  String address;
  String longitude;
  String latitude;
  String remark;
  int managerId;
  String managerName;
  String taskBegin;
  String realBegin;
  String taskEnd;
  String realEnd;
  int serviceHours;
  int realMinutes;
  String content;
  int storeId;
  String storeName;
  int status;

  OneDayListItem(
      {this.id,
        this.createId,
        this.createName,
        this.createTime,
        this.updateId,
        this.updateName,
        this.updateTime,
        this.employeeId,
        this.employeeName,
        this.contactName,
        this.contactPhone,
        this.orderId,
        this.orderType,
        this.payUserId,
        this.address,
        this.longitude,
        this.latitude,
        this.remark,
        this.managerId,
        this.managerName,
        this.taskBegin,
        this.realBegin,
        this.taskEnd,
        this.realEnd,
        this.serviceHours,
        this.realMinutes,
        this.content,
        this.storeId,
        this.storeName,
        this.status});

  OneDayListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createId = json['createId'];
    createName = json['createName'];
    createTime = json['createTime'];
    updateId = json['updateId'];
    updateName = json['updateName'];
    updateTime = json['updateTime'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    contactName = json['contactName'];
    contactPhone = json['contactPhone'];
    orderId = json['orderId'];
    orderType = json['orderType'];
    payUserId = json['payUserId'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    remark = json['remark'];
    managerId = json['managerId'];
    managerName = json['managerName'];
    taskBegin = json['taskBegin'];
    realBegin = json['realBegin'];
    taskEnd = json['taskEnd'];
    realEnd = json['realEnd'];
    serviceHours = json['serviceHours'];
    realMinutes = json['realMinutes'];
    content = json['content'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    status = json['status'];
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
    data['contactName'] = this.contactName;
    data['contactPhone'] = this.contactPhone;
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['payUserId'] = this.payUserId;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['remark'] = this.remark;
    data['managerId'] = this.managerId;
    data['managerName'] = this.managerName;
    data['taskBegin'] = this.taskBegin;
    data['realBegin'] = this.realBegin;
    data['taskEnd'] = this.taskEnd;
    data['realEnd'] = this.realEnd;
    data['serviceHours'] = this.serviceHours;
    data['realMinutes'] = this.realMinutes;
    data['content'] = this.content;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['status'] = this.status;
    return data;
  }
}