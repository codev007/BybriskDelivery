class Overview {
  String pincode;
  int number;

  Overview({this.pincode, this.number});

  Overview.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pincode'] = this.pincode;
    data['number'] = this.number;
    return data;
  }
}