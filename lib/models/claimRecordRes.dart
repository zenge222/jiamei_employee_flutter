class ClaimRecordRes {
  int code;
  String message;
  List<ClaimRecordItem> data;

  ClaimRecordRes({this.code, this.message, this.data});

  ClaimRecordRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ClaimRecordItem>();
      json['data'].forEach((v) {
        data.add(new ClaimRecordItem.fromJson(v));
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

class ClaimRecordItem {
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
  List<RecordList> itemList;
  String reason;
  int status;
  int checkId;
  String checkName;

  ClaimRecordItem(
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
        this.itemList,
        this.reason,
        this.status,
        this.checkId,
        this.checkName});

  ClaimRecordItem.fromJson(Map<String, dynamic> json) {
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
    if (json['itemList'] != null) {
      itemList = new List<RecordList>();
      json['itemList'].forEach((v) {
        itemList.add(new RecordList.fromJson(v));
      });
    }
    reason = json['reason'];
    status = json['status'];
    checkId = json['checkId'];
    checkName = json['checkName'];
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
    if (this.itemList != null) {
      data['itemList'] = this.itemList.map((v) => v.toJson()).toList();
    }
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['checkId'] = this.checkId;
    data['checkName'] = this.checkName;
    return data;
  }
}

class RecordList {
  int id;
  int claimId;
  int stockId;
  String stockCode;
  String stockName;
  String stockBrand;
  String stockModel;
  int claimNumber;

  RecordList(
      {this.id,
        this.claimId,
        this.stockId,
        this.stockCode,
        this.stockName,
        this.stockBrand,
        this.stockModel,
        this.claimNumber});

  RecordList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claimId'];
    stockId = json['stockId'];
    stockCode = json['stockCode'];
    stockName = json['stockName'];
    stockBrand = json['stockBrand'];
    stockModel = json['stockModel'];
    claimNumber = json['claimNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['claimId'] = this.claimId;
    data['stockId'] = this.stockId;
    data['stockCode'] = this.stockCode;
    data['stockName'] = this.stockName;
    data['stockBrand'] = this.stockBrand;
    data['stockModel'] = this.stockModel;
    data['claimNumber'] = this.claimNumber;
    return data;
  }
}