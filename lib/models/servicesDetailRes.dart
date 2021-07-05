class ServicesDetailRes {
  int code;
  ServicesDetailData data;
  String message;

  ServicesDetailRes({this.code, this.data, this.message});

  ServicesDetailRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new ServicesDetailData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class ServicesDetailData {
  String address;
  String contactName;
  String content;
  String evaluateContent;
  int evaluateStar;
  String houseAcreage;
  int id;
  List<SubItems> items;
  String latitude;
  String longitude;
  String managerMobile;
  String managerName;
  String orderName;
  int orderType;
  int peoples;
  String petsName;
  String pictures;
  String realBegin;
  String realEnd;
  int realMinutes;
  String remark;
  int serviceHours;
  int status;
  int storeId;
  String storeName;
  String taskBegin;

  ServicesDetailData(
      {this.address,
        this.contactName,
        this.content,
        this.evaluateContent,
        this.evaluateStar,
        this.houseAcreage,
        this.id,
        this.items,
        this.latitude,
        this.longitude,
        this.managerMobile,
        this.managerName,
        this.orderName,
        this.orderType,
        this.peoples,
        this.petsName,
        this.pictures,
        this.realBegin,
        this.realEnd,
        this.realMinutes,
        this.remark,
        this.serviceHours,
        this.status,
        this.storeId,
        this.storeName,
        this.taskBegin});

  ServicesDetailData.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    contactName = json['contactName'];
    content = json['content'];
    evaluateContent = json['evaluateContent'];
    evaluateStar = json['evaluateStar'];
    houseAcreage = json['houseAcreage'];
    id = json['id'];
    if (json['items'] != null) {
      items = new List<SubItems>();
      json['items'].forEach((v) {
        items.add(new SubItems.fromJson(v));
      });
    }
    latitude = json['latitude'];
    longitude = json['longitude'];
    managerMobile = json['managerMobile'];
    managerName = json['managerName'];
    orderName = json['orderName'];
    orderType = json['orderType'];
    peoples = json['peoples'];
    petsName = json['petsName'];
    pictures = json['pictures'];
    realBegin = json['realBegin'];
    realEnd = json['realEnd'];
    realMinutes = json['realMinutes'];
    remark = json['remark'];
    serviceHours = json['serviceHours'];
    status = json['status'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    taskBegin = json['taskBegin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['contactName'] = this.contactName;
    data['content'] = this.content;
    data['evaluateContent'] = this.evaluateContent;
    data['evaluateStar'] = this.evaluateStar;
    data['houseAcreage'] = this.houseAcreage;
    data['id'] = this.id;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['managerMobile'] = this.managerMobile;
    data['managerName'] = this.managerName;
    data['orderName'] = this.orderName;
    data['orderType'] = this.orderType;
    data['peoples'] = this.peoples;
    data['petsName'] = this.petsName;
    data['pictures'] = this.pictures;
    data['realBegin'] = this.realBegin;
    data['realEnd'] = this.realEnd;
    data['realMinutes'] = this.realMinutes;
    data['remark'] = this.remark;
    data['serviceHours'] = this.serviceHours;
    data['status'] = this.status;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['taskBegin'] = this.taskBegin;
    return data;
  }
}

class SubItems {
  int id;
  String position;
  int structureId;
  List<StructureItems> structureItems;
  String structureName;

  SubItems(
      {this.id,
        this.position,
        this.structureId,
        this.structureItems,
        this.structureName});

  SubItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    structureId = json['structureId'];
    if (json['structureItems'] != null) {
      structureItems = new List<StructureItems>();
      json['structureItems'].forEach((v) {
        structureItems.add(new StructureItems.fromJson(v));
      });
    }
    structureName = json['structureName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    data['structureId'] = this.structureId;
    if (this.structureItems != null) {
      data['structureItems'] =
          this.structureItems.map((v) => v.toJson()).toList();
    }
    data['structureName'] = this.structureName;
    return data;
  }
}

class StructureItems {
  String acceptNormal;
  String cleanLevel;
  String cleanLotion;
  int cleanPeriod;
  String cleanPlace;
  String cleanTools;
  int days;
  int id;
  int itemId;
  String name;
  int orderId;
  int orderStructureId;
  String position;
  int structureId;
  String structureName;
  int taskId;
  String texture;

  StructureItems(
      {this.acceptNormal,
        this.cleanLevel,
        this.cleanLotion,
        this.cleanPeriod,
        this.cleanPlace,
        this.cleanTools,
        this.days,
        this.id,
        this.itemId,
        this.name,
        this.orderId,
        this.orderStructureId,
        this.position,
        this.structureId,
        this.structureName,
        this.taskId,
        this.texture});

  StructureItems.fromJson(Map<String, dynamic> json) {
    acceptNormal = json['acceptNormal'];
    cleanLevel = json['cleanLevel'];
    cleanLotion = json['cleanLotion'];
    cleanPeriod = json['cleanPeriod'];
    cleanPlace = json['cleanPlace'];
    cleanTools = json['cleanTools'];
    days = json['days'];
    id = json['id'];
    itemId = json['itemId'];
    name = json['name'];
    orderId = json['orderId'];
    orderStructureId = json['orderStructureId'];
    position = json['position'];
    structureId = json['structureId'];
    structureName = json['structureName'];
    taskId = json['taskId'];
    texture = json['texture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acceptNormal'] = this.acceptNormal;
    data['cleanLevel'] = this.cleanLevel;
    data['cleanLotion'] = this.cleanLotion;
    data['cleanPeriod'] = this.cleanPeriod;
    data['cleanPlace'] = this.cleanPlace;
    data['cleanTools'] = this.cleanTools;
    data['days'] = this.days;
    data['id'] = this.id;
    data['itemId'] = this.itemId;
    data['name'] = this.name;
    data['orderId'] = this.orderId;
    data['orderStructureId'] = this.orderStructureId;
    data['position'] = this.position;
    data['structureId'] = this.structureId;
    data['structureName'] = this.structureName;
    data['taskId'] = this.taskId;
    data['texture'] = this.texture;
    return data;
  }
}