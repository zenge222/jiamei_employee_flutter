class LeaveParams {
  String beginTime;
  int createId;
  String createName;
  String createTime;
  int employeeId;
  String employeeName;
  String endTime;
  int id;
  String jobNumber;
  String managerRemark;
  String reason;
  String replaceEmployeeId;
  String replaceEmployeeName;
  String replaceTaskId;
  int status;
  int storeId;
  String storeName;
  int type;
  int updateId;
  String updateName;
  String updateTime;
  int workType;

  LeaveParams(
      {this.beginTime,
        this.createId,
        this.createName,
        this.createTime,
        this.employeeId,
        this.employeeName,
        this.endTime,
        this.id,
        this.jobNumber,
        this.managerRemark,
        this.reason,
        this.replaceEmployeeId,
        this.replaceEmployeeName,
        this.replaceTaskId,
        this.status,
        this.storeId,
        this.storeName,
        this.type,
        this.updateId,
        this.updateName,
        this.updateTime,
        this.workType});

  LeaveParams.fromJson(Map<String, dynamic> json) {
    beginTime = json['beginTime'];
    createId = json['createId'];
    createName = json['createName'];
    createTime = json['createTime'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    endTime = json['endTime'];
    id = json['id'];
    jobNumber = json['jobNumber'];
    managerRemark = json['managerRemark'];
    reason = json['reason'];
    replaceEmployeeId = json['replaceEmployeeId'];
    replaceEmployeeName = json['replaceEmployeeName'];
    replaceTaskId = json['replaceTaskId'];
    status = json['status'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    type = json['type'];
    updateId = json['updateId'];
    updateName = json['updateName'];
    updateTime = json['updateTime'];
    workType = json['workType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beginTime'] = this.beginTime;
    data['createId'] = this.createId;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['endTime'] = this.endTime;
    data['id'] = this.id;
    data['jobNumber'] = this.jobNumber;
    data['managerRemark'] = this.managerRemark;
    data['reason'] = this.reason;
    data['replaceEmployeeId'] = this.replaceEmployeeId;
    data['replaceEmployeeName'] = this.replaceEmployeeName;
    data['replaceTaskId'] = this.replaceTaskId;
    data['status'] = this.status;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['type'] = this.type;
    data['updateId'] = this.updateId;
    data['updateName'] = this.updateName;
    data['updateTime'] = this.updateTime;
    data['workType'] = this.workType;
    return data;
  }
}