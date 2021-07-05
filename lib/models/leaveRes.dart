class LeaveRes {
  int code;
  String message;
  List<LeaveItem> data;

  LeaveRes({this.code, this.message, this.data});

  LeaveRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<LeaveItem>();
      json['data'].forEach((v) {
        data.add(new LeaveItem.fromJson(v));
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

class LeaveItem {
  int id;
  int createId;
  String createName;
  String createTime;
  int updateId;
  String updateName;
  String updateTime;
  int employeeId;
  String employeeName;
  int storeId;
  String storeName;
  int jobNumber;
  int workType;
  int replaceEmployeeId;
  String replaceEmployeeName;
  int replaceTaskId;
  int type;
  String reason;
  String beginTime;
  String endTime;
  String managerRemark;
  int status;

  LeaveItem(
      {this.id,
        this.createId,
        this.createName,
        this.createTime,
        this.updateId,
        this.updateName,
        this.updateTime,
        this.employeeId,
        this.employeeName,
        this.storeId,
        this.storeName,
        this.jobNumber,
        this.workType,
        this.replaceEmployeeId,
        this.replaceEmployeeName,
        this.replaceTaskId,
        this.type,
        this.reason,
        this.beginTime,
        this.endTime,
        this.managerRemark,
        this.status});

  LeaveItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createId = json['createId'];
    createName = json['createName'];
    createTime = json['createTime'];
    updateId = json['updateId'];
    updateName = json['updateName'];
    updateTime = json['updateTime'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    jobNumber = json['jobNumber'];
    workType = json['workType'];
    replaceEmployeeId = json['replaceEmployeeId'];
    replaceEmployeeName = json['replaceEmployeeName'];
    replaceTaskId = json['replaceTaskId'];
    type = json['type'];
    reason = json['reason'];
    beginTime = json['beginTime'];
    endTime = json['endTime'];
    managerRemark = json['managerRemark'];
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
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['jobNumber'] = this.jobNumber;
    data['workType'] = this.workType;
    data['replaceEmployeeId'] = this.replaceEmployeeId;
    data['replaceEmployeeName'] = this.replaceEmployeeName;
    data['replaceTaskId'] = this.replaceTaskId;
    data['type'] = this.type;
    data['reason'] = this.reason;
    data['beginTime'] = this.beginTime;
    data['endTime'] = this.endTime;
    data['managerRemark'] = this.managerRemark;
    data['status'] = this.status;
    return data;
  }
}