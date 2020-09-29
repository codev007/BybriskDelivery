class Delivery {
  String id;
  String orderId;
  String dpincode;
  String address;
  String cOD;
  String dmobile;
  String date;
  String time;
  String status;
  String name;
  String businessName;
  String bmobile;
  String baddress;
  String bpincode;
  String ago;

  Delivery(
      {this.id,
        this.orderId,
        this.dpincode,
        this.address,
        this.cOD,
        this.dmobile,
        this.date,
        this.time,
        this.status,
        this.name,
        this.businessName,
        this.bmobile,
        this.baddress,
        this.bpincode,
        this.ago});

  Delivery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    dpincode = json['dpincode'];
    address = json['address'];
    cOD = json['COD'];
    dmobile = json['dmobile'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    name = json['name'];
    businessName = json['business_name'];
    bmobile = json['bmobile'];
    baddress = json['baddress'];
    bpincode = json['bpincode'];
    ago = json['ago'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['dpincode'] = this.dpincode;
    data['address'] = this.address;
    data['COD'] = this.cOD;
    data['dmobile'] = this.dmobile;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['name'] = this.name;
    data['business_name'] = this.businessName;
    data['bmobile'] = this.bmobile;
    data['baddress'] = this.baddress;
    data['bpincode'] = this.bpincode;
    data['ago'] = this.ago;
    return data;
  }
}