import 'package:shared_preferences/shared_preferences.dart';

class SharedDatabase {
  setPincode(List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('pincode', value);
  }

  Future<List<String>> getPincode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getStringList('pincode');
  }
  setVerified(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('verifed', value);
  }
  Future<bool> getVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('verifed');
  }
  setSignup(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('done', value);
  }

  Future<bool> getSignup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('done');
  }

  setLogin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', value);
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('login');
  }

  setMobile(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobile', value);
  }

  Future<String> getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('mobile');
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('id');
  }

  setProfileData(String id, String name, String email, String address,
      String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('address', address);
    prefs.setString('mobile', mobile);
  }
  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('name');
  }
  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('email');
  }
  mLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
