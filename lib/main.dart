import 'package:bybrisk_delivery/views/flashscreen.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_delivery/style/colors.dart' as CustomColors;
/// App entry point
void main() async {
  // then render the app on screen
  runApp(MyApp());
}

final routes = {
  '/': (BuildContext context) => new FlashScreen(),
  // '/': (BuildContext context) => new Home(),

};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      //    routes: routes,
      routes: routes,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: CustomColors.BybriskColor.white,
        accentColor: CustomColors.BybriskColor.primaryColor,
        primaryColorDark: CustomColors.BybriskColor.primaryColor,
        primaryIconTheme: Theme.of(context)
            .primaryIconTheme
            .copyWith(color: CustomColors.BybriskColor.primaryColor),
      ),
    );
  }
}