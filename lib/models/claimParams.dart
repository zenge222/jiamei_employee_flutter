class ClaimParams {
  String reason;
  List<ItemList> itemList;

  ClaimParams({this.reason, this.itemList});

  ClaimParams.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    if (json['itemList'] != null) {
      itemList = new List<ItemList>();
      json['itemList'].forEach((v) {
        itemList.add(new ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    if (this.itemList != null) {
      data['itemList'] = this.itemList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemList {
  int claimNumber;
  int amount;
  String picture;
  String name;
  String brand;
  String model;
  int stockId;

  ItemList(
      {this.claimNumber,
        this.amount,
        this.picture,
        this.name,
        this.brand,
        this.model,
        this.stockId});

  ItemList.fromJson(Map<String, dynamic> json) {
    claimNumber = json['claimNumber'];
    amount = json['amount'];
    picture = json['picture'];
    name = json['name'];
    brand = json['brand'];
    model = json['model'];
    stockId = json['stockId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['claimNumber'] = this.claimNumber;
    data['amount'] = this.amount;
    data['picture'] = this.picture;
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['stockId'] = this.stockId;
    return data;
  }
}