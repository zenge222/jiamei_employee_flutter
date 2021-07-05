class OpinionParams {
  String opinion;
  String pictures;

  OpinionParams({this.opinion, this.pictures});

  OpinionParams.fromJson(Map<String, dynamic> json) {
    opinion = json['opinion'];
    pictures = json['pictures'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['opinion'] = this.opinion;
    data['pictures'] = this.pictures;
    return data;
  }
}