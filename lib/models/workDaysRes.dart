class WorkDaysRes {
  int code;
  String message;
  WorkDate data;

  WorkDaysRes({this.code, this.message, this.data});

  WorkDaysRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new WorkDate.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class WorkDate {
  int sumDay;
  List<ServiceDateList> serviceDateList;
  int sumHour;

  WorkDate({this.sumDay, this.serviceDateList, this.sumHour});

  WorkDate.fromJson(Map<String, dynamic> json) {
    sumDay = json['sumDay'];
    if (json['serviceDateList'] != null) {
      serviceDateList = new List<ServiceDateList>();
      json['serviceDateList'].forEach((v) {
        serviceDateList.add(new ServiceDateList.fromJson(v));
      });
    }
    sumHour = json['sumHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sumDay'] = this.sumDay;
    if (this.serviceDateList != null) {
      data['serviceDateList'] =
          this.serviceDateList.map((v) => v.toJson()).toList();
    }
    data['sumHour'] = this.sumHour;
    return data;
  }
}

class ServiceDateList {
  String taskBegin;
  int status;

  ServiceDateList({this.taskBegin, this.status});

  ServiceDateList.fromJson(Map<String, dynamic> json) {
    taskBegin = json['taskBegin'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskBegin'] = this.taskBegin;
    data['status'] = this.status;
    return data;
  }
}