import 'dart:convert';
import 'dart:io';
import 'package:bybrisk_delivery/helper/ImageHelper.dart';
import 'package:bybrisk_delivery/style/design.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk_delivery/database/BybriskSharedPreferences.dart';
import 'package:bybrisk_delivery/database/apiController.dart';
import 'package:bybrisk_delivery/style/dimen.dart';
import 'package:bybrisk_delivery/style/fonts.dart';
import 'package:bybrisk_delivery/style/string.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_delivery/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadDocuments extends StatefulWidget {
  @override
  _UploadDocumentsState createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isFound = false;
  bool isLoading = true;
  bool isVerified = false;
  final picker = ImagePicker();
  var uuid=new Uuid();
  String adhar,driving,imageRc;
  File _imageAdahr, _imageDrivingLicence, _imageRC;
  String employeeid;
  Future<File> getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return File(pickedFile.path);
  }

  Future<File> getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  _getDetails() async {
    String emId = await SharedDatabase().getID();
    bool isVerify = await SharedDatabase().getVerified();

    setState(() {
      employeeid = emId;
      if (isVerify != null) {
        isVerified = isVerify;
        if (isVerified) {
          isFound = true;
        } else {
          isFound = false;
        }
      } else {
        isVerified = false;
      }
    });
    mExist();
  }

  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Verification",
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: BybriskDimen().title),
        ),
        actions: <Widget>[
          _imageAdahr != null &&
                  _imageDrivingLicence != null &&
                  _imageRC != null
              ? IconButton(icon: Icon(Icons.cloud_upload), onPressed: () {
                setState(() {
                  isLoading=true;
                });
                uploadDocuments();
          })
              : Container()
        ],
      ),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : isFound
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.verified_user,
                          color: isVerified ? Colors.blue : Colors.red,
                          size: 100.0,
                        ),
                      ),
                      Container(
                          child: Text(
                        isVerified
                            ? "Verification Already\nCompleted"
                            : "You are not verified\nPlease wait",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: Bybriskfont().large,
                            color: CustomColor.BybriskColor.textSecondary,
                            fontSize: BybriskDimen().exlarge),
                      ))
                    ],
                  ),
                )
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 30.0,
                      ),
                      Container(
                        child: Text("ADD YOUR ADHAR CARD"),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.camera),
                                onPressed: () async {
                                  File file_one = await getImageCamera();
                                  setState(() {
                                    _imageAdahr = file_one;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () async {
                                  File file_one = await getImageGallery();
                                  setState(() {
                                    _imageAdahr = file_one;
                                  });
                                }),
                            _imageAdahr != null
                                ? CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage: FileImage(_imageAdahr),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      Container(
                        height: 30.0,
                      ),
                      Container(
                        child: Text("ADD YOUR DRIVING LICENCE"),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.camera),
                                onPressed: () async {
                                  File file_one = await getImageCamera();
                                  setState(() {
                                    _imageDrivingLicence = file_one;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () async {
                                  File file_one = await getImageGallery();
                                  setState(() {
                                    _imageDrivingLicence = file_one;
                                  });
                                }),
                            _imageDrivingLicence != null
                                ? CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage:
                                        FileImage(_imageDrivingLicence),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      Container(
                        height: 30.0,
                      ),
                      Container(
                        child: Text("ADD YOUR REGISTRATION CARD"),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.camera),
                                onPressed: () async {
                                  File file_one = await getImageCamera();
                                  setState(() {
                                    _imageRC = file_one;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () async {
                                  File file_one = await getImageGallery();
                                  setState(() {
                                    _imageRC = file_one;
                                  });
                                }),
                            _imageRC != null
                                ? CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage: FileImage(_imageRC),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      Container(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
    );
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
        setState(() {
          isFound = true;
        });
      } else {
        setState(() {
          isFound = false;
        });
      }
      setState(() {
        isLoading = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("No internet connection", _scaffoldKey);
    }
  }

  uploadDocuments() async {
    List<int> imageBytesorg = await ImageHelper()
        .compressImage(_imageAdahr.readAsBytesSync());
    String imageA = base64Encode(imageBytesorg);

    List<int> imageBytesorg1 = await ImageHelper()
        .compressImage(_imageDrivingLicence.readAsBytesSync());
    String imageL = base64Encode(imageBytesorg1);

    List<int> imageBytesorg2 = await ImageHelper()
        .compressImage(_imageRC.readAsBytesSync());
    String imageR = base64Encode(imageBytesorg2);

    try {
      String url = mApiController().uploadDocs;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {
        "id": employeeid,
        "adhar": imageA,
        "driving": imageL,
        "rc": imageR
      };
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
        setState(() {
          isFound = true;
        });
        mExist();
      } else {
        setState(() {
          isFound = false;
        });
      }
      setState(() {
        isLoading = false;
        SharedDatabase().setVerified(false);
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("No internet connection", _scaffoldKey);
    }
  }
}
