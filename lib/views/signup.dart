import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bybrisk_delivery/FirebaseMessagingService.dart';
import 'package:bybrisk_delivery/deliveryModule/deliveryHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk_delivery/database/BybriskSharedPreferences.dart';
import 'package:bybrisk_delivery/database/apiController.dart';
import 'package:bybrisk_delivery/style/design.dart';
import 'package:bybrisk_delivery/style/dimen.dart';
import 'package:bybrisk_delivery/style/fonts.dart';
import 'package:bybrisk_delivery/style/string.dart';
import 'package:bybrisk_delivery/style/transaction.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_delivery/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String name, email, address, mobile;
  Uuid uuid = Uuid();

  getMobile() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        setState(() {
          mobile = user.phoneNumber.toString();
        });
      }
    });
  }

  @override
  void initState() {
    this.getMobile();
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
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                margin: EdgeInsets.only(top: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        BybrickString().signupQuote,
                        style: TextStyle(
                            fontFamily: Bybriskfont().large,
                            color: CustomColor.BybriskColor.primaryColor,
                            fontSize: BybriskDimen().large),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Complete your \nProfile",
                        style: TextStyle(
                            fontSize: BybriskDimen().exlarge,
                            color: Colors.black45),
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "your name".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        //  controller: password,
                        obscureText: false,
                        onChanged: (value) {
                          setState(() {
                            this.name = value.toString();
                          });
                        },
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Your name',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 2.0, top: 10.0),
                      child: Text(
                        "Email address".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        //  controller: password,
                        obscureText: false,
                        onChanged: (value) {
                          setState(() {
                            this.email = value.toString();
                          });
                        },
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Your Email',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 2.0, top: 10.0),
                      child: Text(
                        "Address".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        //  controller: password,
                        obscureText: false,
                        onChanged: (value) {
                          setState(() {
                            this.address = value.toString();
                          });
                        },
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Address',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BybriskDesign().hollowButtonDesign(),
                      margin: EdgeInsets.only(top: 20.0, bottom: 40.0),
                      child: InkWell(
                        splashColor: CustomColor.BybriskColor.white,
                        onTap: () {
                          if (name.length > 0 &&
                              email.length > 0 &&
                              address.length > 0 &&
                              mobile.length > 0) {
                            setState(() {
                              isLoading = true;
                            });
                            mSignup(uuid.v1().toString(), name, email, address,
                                mobile);
                          } else {
                            BybriskDesign().showInSnackBar(
                                "Feilds are missing !", _scaffoldKey);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 15.0, left: 15.0),
                          child: Text(
                            "Submit Now",
                            style: TextStyle(
                                color: CustomColor.BybriskColor.white,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void mSignup(String id, name, email, address, mobile) async {
    try {
      String url = mApiController().deliverySignup;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {
        "id": id,
        "name": name,
        "email": email,
        "address": address,
        "mobile": mobile
      };
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setSignup(true);
        SharedDatabase().setProfileData(id, name, email, address, mobile);
        sendAndRetrieveMessage(
            "New Delivery boy found", "Activate now", ['admin']);
        Navigator.of(context).pushReplacement(FadeRouteBuilder(page: Home()));
        BybriskDesign().showInSnackBar("Congratulation", _scaffoldKey);
      } else {
        SharedDatabase().setSignup(false);
        BybriskDesign()
            .showInSnackBar("Problem occurs ! Please try again", _scaffoldKey);
      }
      setState(() {
        isLoading = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("No internet connection", _scaffoldKey);
      mSignup(id, name, email, address, mobile);
    }
  }
}
