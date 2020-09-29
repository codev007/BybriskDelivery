import 'dart:convert';
import 'dart:io';

import 'package:bybrisk_delivery/FirebaseMessagingService.dart';
import 'package:bybrisk_delivery/beans/Delivery.dart';
import 'package:bybrisk_delivery/database/BybriskSharedPreferences.dart';
import 'package:bybrisk_delivery/style/design.dart';
import 'package:bybrisk_delivery/style/dimen.dart';
import 'package:bybrisk_delivery/style/fonts.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk_delivery/database/apiController.dart';
import 'package:bybrisk_delivery/style/colors.dart' as CustomColor;

class ShippingDetails extends StatefulWidget {
  final String mPincode;
  ShippingDetails(this.mPincode, {Key key}) : super(key: key);
  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var deliveriesList = List<Delivery>();
  bool isLoading = true;
  String mEmployeeID;
  bool isVerifing = false;
  var token = List<String>();
  _getData() async {
    String id = await SharedDatabase().getID();
    setState(() {
      mEmployeeID = id;
    });
    this._fetchDeliveries();
  }

  @override
  void initState() {
    this._getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.mPincode,
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: BybriskDimen().title),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                    itemCount: deliveriesList.length,
                    itemBuilder: (BuildContext contex, int index) {
                      return _listViewContaintDesign(deliveriesList[index]);
                    }),
              ),
            ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      deliveriesList.clear();
      isLoading = true;
    });
    _fetchDeliveries();
  }

  _listViewContaintDesign(Delivery deliveryPojo) {
    return InkWell(
      onTap: () {
        _deliveryDetails(deliveryPojo);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                deliveryPojo.orderId,
                style:
                    TextStyle(fontFamily: Bybriskfont().large, fontSize: 18.0),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(deliveryPojo.address + ", " + deliveryPojo.dpincode),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                    child: Text(
                      deliveryPojo.ago,
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                    child: Text(
                      deliveryPojo.status == "1"
                          ? "Pending"
                          : deliveryPojo.status == "2"
                              ? "Picked"
                              : deliveryPojo.status == "4"
                                  ? "Delivered"
                                  : "Shipping",
                      style: TextStyle(
                          fontSize: 13.0,
                          color: CustomColor.BybriskColor.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            BybriskDesign().bigSpacer()
          ],
        ),
      ),
    );
  }

  _fetchDeliveries() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      Map<String, dynamic> jsondat = {
        "pincode": widget.mPincode,
        "id": mEmployeeID
      };

      final response = await http.post(mApiController().delivered,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          deliveriesList = (json.decode(response.body) as List)
              .map((data) => new Delivery.fromJson(data))
              .toList();
          if (deliveriesList.length > 0) {
            isLoading = false;
          } else {
            this._fetchDeliveries();
            BybriskDesign()
                .showInSnackBar("Deliveries not found !", _scaffoldKey);
          }
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchDeliveries();
    }
  }

  _deliveryDetails(Delivery deliveryPojo) {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (contex) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 18.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Delivery Details",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Deliver Address",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.address,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Deliver Pincode",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.dpincode,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Contact Number",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.dmobile,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Delivery Type",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.cOD == "PP"
                                  ? "Prepaid"
                                  : "Cash on delivery : ₹" + deliveryPojo.cOD,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Delivery Status",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 10.0),
                            child: Text(
                              deliveryPojo.status == "1"
                                  ? "Pending"
                                  : deliveryPojo.status == "2"
                                      ? "Picked"
                                      : deliveryPojo.status == "4"
                                          ? "Delivered"
                                          : "Shipping",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          isVerifing
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child: FlatButton(
                                            onPressed: () async {
                                              setStates(() {
                                                isVerifing = true;
                                                token.add("/topics/admin");
                                                token.add("/topics/" +
                                                    deliveryPojo.bmobile);
                                              });
                                              _makeitPicked(deliveryPojo.id,
                                                  deliveryPojo.orderId);
                                            },
                                            child: Text(
                                              "CHANGE STATUS TO DELIVERED",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: CustomColor
                                                      .BybriskColor
                                                      .primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          Container(
                            height: 20.0,
                          )
                        ],
                      ),
                    ),
                  ));
            },
          );
        });
  }

  void _makeitPicked(String id, String orderID) async {
    try {
      String url = mApiController().shippingToDelivered;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {"id": id};
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
        sendAndRetrieveMessage(
            orderID, " Status updated : Delivered successfully", token);
        BybriskDesign().showInSnackBar("Updated successfully", _scaffoldKey);
        Navigator.of(context).pop();
        _refresh();
      } else {
        BybriskDesign()
            .showInSnackBar("Problem occurs ! Please try again", _scaffoldKey);
      }
      setState(() {
        isVerifing = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("Internet connection lost", _scaffoldKey);
      Navigator.of(context).pop();
    }
  }
}
