import 'dart:async';
import 'package:bybrisk_delivery/database/BybriskSharedPreferences.dart';
import 'package:bybrisk_delivery/deliveryModule/deliveryHome.dart';
import 'package:bybrisk_delivery/style/icons.dart';
import 'package:bybrisk_delivery/style/transaction.dart';
import 'package:bybrisk_delivery/views/login.dart';
import 'package:bybrisk_delivery/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_delivery/style/colors.dart' as CustomColors;

class FlashScreen extends StatefulWidget {
  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  bool isLogin;
  bool isSignUp;

  _data() async {
    bool login = await SharedDatabase().isLogin();
    bool sign = await SharedDatabase().getSignup();
    setState(() {
      isLogin = login;
      isSignUp = sign;
    });
    print(isLogin.toString()+isSignUp.toString());
    if (isLogin != null) {
      if (isLogin) {
        if (isSignUp != null) {
          if (isSignUp) {
            Timer(
                Duration(seconds: 2),
                () => Navigator.of(context)
                    .pushReplacement(FadeRouteBuilder(page: Home())));
          } else {
            Timer(
                Duration(seconds: 2),
                () => Navigator.of(context)
                    .pushReplacement(FadeRouteBuilder(page: SignUp())));
          }
        } else {
          Timer(
              Duration(seconds: 2),
              () => Navigator.of(context)
                  .pushReplacement(FadeRouteBuilder(page: SignUp())));
        }
      } else {
        Timer(
            Duration(seconds: 2),
            () => Navigator.of(context)
                .pushReplacement(FadeRouteBuilder(page: Login())));
      }
    } else {
      Timer(
          Duration(seconds: 2),
          () => Navigator.of(context)
              .pushReplacement(FadeRouteBuilder(page: Login())));
    }
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              height: 100.0,
              child: Image.asset(
                BybriskIcon().logo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
