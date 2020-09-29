import 'dart:convert';
import 'dart:io';
import 'package:bybrisk_delivery/style/design.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk_delivery/database/BybriskSharedPreferences.dart';
import 'package:bybrisk_delivery/database/apiController.dart';
import 'package:bybrisk_delivery/style/colors.dart' as CustomColor;
import 'package:bybrisk_delivery/style/dimen.dart';
import 'package:bybrisk_delivery/style/fonts.dart';
import 'package:bybrisk_delivery/style/string.dart';
import 'package:bybrisk_delivery/style/transaction.dart';
import 'package:bybrisk_delivery/tabs/deliver.dart';
import 'package:bybrisk_delivery/tabs/picked.dart';
import 'package:bybrisk_delivery/views/flashscreen.dart';
import 'package:bybrisk_delivery/views/upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String name = "....", email = "...";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String employeeid;

  _getData() async {
    String mob = await SharedDatabase().getEmail();
    String emi = await SharedDatabase().getName();
    String emId = await SharedDatabase().getID();

    setState(() {
      name = emi;
      email = mob;
      employeeid = emId;
    });
    mExist();
  }

  _unsubscribed() async {
    List<String> pin = await SharedDatabase().getPincode();
    if (pin != null) {
      for (int i = 0; i < pin.length; i++) {
        _firebaseMessaging.subscribeToTopic(pin.toString());
      }
    }
  }

  @override
  void initState() {
    _getData();
    //  _firebaseMessaging.subscribeToTopic("admin");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print(_messageText);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print(_messageText);
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        print('$token');
      });
    });
    _unsubscribed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration:
                    BoxDecoration(color: CustomColor.BybriskColor.primaryColor),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: CustomColor.BybriskColor.white,
                        child: Text(
                          name[0],
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                      Container(
                        height: 5.0,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            color: CustomColor.BybriskColor.white,
                            fontSize: 18.0),
                      ),
                      Container(
                        height: 5.0,
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            color: CustomColor.BybriskColor.white,
                            fontSize: 18.0),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.cloud_upload),
                title: Text(
                  'Upload documents',
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(FadeRouteBuilder(page: UploadDocuments()));
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text(
                  'Terms and Conditions',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  'Privacy Policy',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text(
                  'Logout',
                ),
                onTap: () {
                  _auth.signOut();
                  SharedDatabase().mLogout();
                  Navigator.of(context)
                      .pushReplacement(FadeRouteBuilder(page: FlashScreen()));
                },
              ),
            ],
          ),
        ),
        appBar: null,
        body: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  icon: Icon(
                    Icons.sort,
                    color: CustomColor.BybriskColor.primaryColor,
                  ),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "PENDING DELIVERIES",
                    ),
                    Tab(
                      text: "READY FOR DELIVER DELIVERIES",
                    )
                  ],
                ),
                title: Text(
                  BybrickString().appName,
                  style: TextStyle(
                      fontFamily: Bybriskfont().large,
                      color: CustomColor.BybriskColor.primaryColor,
                      fontSize: BybriskDimen().title),
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  PickedDelivery(
                    key: PageStorageKey("p1"),
                  ),
                  DeliverDelicery(
                    key: PageStorageKey("p2"),
                  )
                ],
              ),
            )));
  }

  void mExist() async {
    try {
      String url = mApiController().isVerified;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {"id": employeeid};
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
      } else {
        Navigator.of(context).push(FadeRouteBuilder(page: UploadDocuments()));
      }
    } on SocketException {
      BybriskDesign().showInSnackBar("No internet connection", _scaffoldKey);
    }
  }
}
