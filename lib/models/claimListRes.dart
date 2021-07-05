class ClaimListRes {
  int code;
  int count;
  String message;
  List<ClaimItem> data;

  ClaimListRes({this.code, this.message, this.data});

  ClaimListRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ClaimItem>();
      json['data'].forEach((v) {
        data.add(new ClaimItem.fromJson(v));
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

class ClaimItem {
  int id;
  String name;
  String brand;
  String model;
  String picture;
  int amount;

  ClaimItem({this.id, this.name, this.brand, this.model, this.picture, this.amount});

  ClaimItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    brand = json['brand'];
    model = json['model'];
    picture = json['picture'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['picture'] = this.picture;
    data['amount'] = this.amount;
    return data;
  }
}