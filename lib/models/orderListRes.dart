class OrderListRes {
  int code;
  List<Data> data;
  String message;

  OrderListRes({this.code, this.data, this.message});

  OrderListRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String address;
  String contactName;
  String contactPhone;
  String content;
  int employeeId;
  String employeeMobile;
  String employeeName;
  int evaluateStatus;
  int id;
  String latitude;
  String longitude;
  int managerId;
  String managerMobile;
  String managerName;
  int orderId;
  int orderType;
  String realBegin;
  String realEnd;
  int realMinutes;
  String remark;
  int serviceHours;
  int status;
  int storeId;
  String storeName;
  String taskBegin;
  String taskEnd;

  Data(
      {this.address,
        this.contactName,
        this.contactPhone,
        this.content,
        this.employeeId,
        this.employeeMobile,
        this.employeeName,
        this.evaluateStatus,
        this.id,
        this.latitude,
        this.longitude,
        this.managerId,
        this.managerMobile,
        this.managerName,
        this.orderId,
        this.orderType,
        this.realBegin,
        this.realEnd,
        this.realMinutes,
        this.remark,
        this.serviceHours,
        this.status,
        this.storeId,
        this.storeName,
        this.taskBegin,
        this.taskEnd});

  Data.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    contactName = json['contactName'];
    contactPhone = json['contactPhone'];
    content = json['content'];
    employeeId = json['employeeId'];
    employeeMobile = json['employeeMobile'];
    employeeName = json['employeeName'];
    evaluateStatus = json['evaluateStatus'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    managerId = json['managerId'];
    managerMobile = json['managerMobile'];
    managerName = json['managerName'];
    orderId = json['orderId'];
    orderType = json['orderType'];
    realBegin = json['realBegin'];
    realEnd = json['realEnd'];
    realMinutes = json['realMinutes'];
    remark = json['remark'];
    serviceHours = json['serviceHours'];
    status = json['status'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    taskBegin = json['taskBegin'];
    taskEnd = json['taskEnd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['contactName'] = this.contactName;
    data['contactPhone'] = this.contactPhone;
    data['content'] = this.content;
    data['employeeId'] = this.employeeId;
    data['employeeMobile'] = this.employeeMobile;
    data['employeeName'] = this.employeeName;
    data['evaluateStatus'] = this.evaluateStatus;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['managerId'] = this.managerId;
    data['managerMobile'] = this.managerMobile;
    data['managerName'] = this.managerName;
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['realBegin'] = this.realBegin;
    data['realEnd'] = this.realEnd;
    data['realMinutes'] = this.realMinutes;
    data['remark'] = this.remark;
    data['serviceHours'] = this.serviceHours;
    data['status'] = this.status;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['taskBegin'] = this.taskBegin;
    data['taskEnd'] = this.taskEnd;
    return data;
  }
}