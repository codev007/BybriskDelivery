import 'dart:convert';
import 'dart:io';

import 'package:bybrisk_delivery/beans/Overview.dart';
import 'package:bybrisk_delivery/database/BybriskSharedPreferences.dart';
import 'package:bybrisk_delivery/deliveryModule/ShippingDetails.dart';
import 'package:bybrisk_delivery/deliveryModule/pendingDetails.dart';
import 'package:bybrisk_delivery/style/design.dart';
import 'package:bybrisk_delivery/style/dimen.dart';
import 'package:bybrisk_delivery/style/fonts.dart';
import 'package:bybrisk_delivery/style/string.dart';
import 'package:bybrisk_delivery/style/transaction.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk_delivery/database/apiController.dart';
import 'package:bybrisk_delivery/style/colors.dart' as CustomColor;

class DeliverDelicery extends StatefulWidget {
  DeliverDelicery({Key key}) : super(key: key);
  @override
  _DeliverDeliceryState createState() => _DeliverDeliceryState();
}

class _DeliverDeliceryState extends State<DeliverDelicery>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var deliveriesList = List<Overview>();
  bool isLoading = true;
  bool isFound = false;
  String mEmployeeID;
  @override
  bool get wantKeepAlive => true;
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
      appBar: null,
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : isFound
              ? Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 250.0,
                          width: 300.0,
                          child: FlareActor(
                            "assets/animation/empty.flr",
                            animation: "empty",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                          alignment: Alignment.center,
                          child: Text(
                            BybrickString().deliverynotfound,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: Bybriskfont().large,
                                color: CustomColor.BybriskColor.textSecondary,
                                fontSize: BybriskDimen().exlarge),
                          ),
                        )
                      ],
                    ),
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

  _listViewContaintDesign(Overview overview) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(FadeRouteBuilder(page: ShippingDetails(overview.pincode)));
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                overview.pincode + "( " + overview.number.toString() + " )",
                style: TextStyle(
                    fontFamily: Bybriskfont().large,
                    color: CustomColor.BybriskColor.textPrimary,
                    fontSize: 20.0),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  _fetchDeliveries() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      Map<String, dynamic> jsondat = {"employee_id": mEmployeeID};

      final response = await http.post(mApiController().deliverWithArea,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        List<Overview> temp;
        setState(() {
          temp = (json.decode(response.body) as List)
              .map((data) => new Overview.fromJson(data))
              .toList();
          for (int i = 0; i < temp.length; i++) {
            if (temp[i].number != 0) {
              deliveriesList.add(temp[i]);
            }
          }
          if (deliveriesList.length > 0) {
            isLoading = false;
          } else {
            isFound = true;
            isLoading = false;
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
}
