class MeetingRes {
  int code;
  List<Data> data;
  String message;

  MeetingRes({this.code, this.data, this.message});

  MeetingRes.fromJson(Map<String, dynamic> json) {
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
  int createId;
  String createName;
  String createTime;
  int deductionFee;
  String deductionReason;
  int employeeId;
  String employeeMobile;
  String employeeName;
  String houseAcreage;
  int id;
  String latitude;
  String longitude;
  int managerId;
  String managerMobile;
  String managerName;
  String name;
  int originalPrice;
  int payUserId;
  String payUserName;
  String payUserPhone;
  int peoples;
  String periodBegin;
  String petsName;
  int productId;
  String productImg;
  int realPay;
  int refundStatus;
  String remark;
  int serviceHours;
  int signStatus;
  int skuId;
  String skuName;
  int status;
  int storeId;
  String storeName;
  int type;
  int updateId;
  String updateName;
  String updateTime;

  Data(
      {this.address,
        this.contactName,
        this.contactPhone,
        this.createId,
        this.createName,
        this.createTime,
        this.deductionFee,
        this.deductionReason,
        this.employeeId,
        this.employeeMobile,
        this.employeeName,
        this.houseAcreage,
        this.id,
        this.latitude,
        this.longitude,
        this.managerId,
        this.managerMobile,
        this.managerName,
        this.name,
        this.originalPrice,
        this.payUserId,
        this.payUserName,
        this.payUserPhone,
        this.peoples,
        this.periodBegin,
        this.petsName,
        this.productId,
        this.productImg,
        this.realPay,
        this.refundStatus,
        this.remark,
        this.serviceHours,
        this.signStatus,
        this.skuId,
        this.skuName,
        this.status,
        this.storeId,
        this.storeName,
        this.type,
        this.updateId,
        this.updateName,
        this.updateTime});

  Data.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    contactName = json['contactName'];
    contactPhone = json['contactPhone'];
    createId = json['createId'];
    createName = json['createName'];
    createTime = json['createTime'];
    deductionFee = json['deductionFee'];
    deductionReason = json['deductionReason'];
    employeeId = json['employeeId'];
    employeeMobile = json['employeeMobile'];
    employeeName = json['employeeName'];
    houseAcreage = json['houseAcreage'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    managerId = json['managerId'];
    managerMobile = json['managerMobile'];
    managerName = json['managerName'];
    name = json['name'];
    originalPrice = json['originalPrice'];
    payUserId = json['payUserId'];
    payUserName = json['payUserName'];
    payUserPhone = json['payUserPhone'];
    peoples = json['peoples'];
    periodBegin = json['periodBegin'];
    petsName = json['petsName'];
    productId = json['productId'];
    productImg = json['productImg'];
    realPay = json['realPay'];
    refundStatus = json['refundStatus'];
    remark = json['remark'];
    serviceHours = json['serviceHours'];
    signStatus = json['signStatus'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    status = json['status'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    type = json['type'];
    updateId = json['updateId'];
    updateName = json['updateName'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['contactName'] = this.contactName;
    data['contactPhone'] = this.contactPhone;
    data['createId'] = this.createId;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['deductionFee'] = this.deductionFee;
    data['deductionReason'] = this.deductionReason;
    data['employeeId'] = this.employeeId;
    data['employeeMobile'] = this.employeeMobile;
    data['employeeName'] = this.employeeName;
    data['houseAcreage'] = this.houseAcreage;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['managerId'] = this.managerId;
    data['managerMobile'] = this.managerMobile;
    data['managerName'] = this.managerName;
    data['name'] = this.name;
    data['originalPrice'] = this.originalPrice;
    data['payUserId'] = this.payUserId;
    data['payUserName'] = this.payUserName;
    data['payUserPhone'] = this.payUserPhone;
    data['peoples'] = this.peoples;
    data['periodBegin'] = this.periodBegin;
    data['petsName'] = this.petsName;
    data['productId'] = this.productId;
    data['productImg'] = this.productImg;
    data['realPay'] = this.realPay;
    data['refundStatus'] = this.refundStatus;
    data['remark'] = this.remark;
    data['serviceHours'] = this.serviceHours;
    data['signStatus'] = this.signStatus;
    data['skuId'] = this.skuId;
    data['skuName'] = this.skuName;
    data['status'] = this.status;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['type'] = this.type;
    data['updateId'] = this.updateId;
    data['updateName'] = this.updateName;
    data['updateTime'] = this.updateTime;
    return data;
  }
}