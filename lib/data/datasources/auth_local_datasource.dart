
import 'package:minpa_lite/data/models/requests/printer_request_model.dart';
import 'package:minpa_lite/data/models/responses/auth_response_model.dart';
import 'package:minpa_lite/data/models/responses/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/responses/store_model.dart';

class AuthLocalDatasource {
  Future<void> saveUserData(UserModel data) async {
    // save user data to local storage
    final pref = await SharedPreferences.getInstance();
    await pref.setString('user', data.toJson());
  }

  //remove outlet data from local storage
  Future<void> removeOutletData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('outlet');
  }

  //remove user data from local storage
  Future<void> removeUserData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('user');
  }

  //get user data from local storage
  Future<UserModel?> getUserData() async {
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString('user');
    if (user != null) {
      return UserModel.fromJson(user);
    } else {
      return null;
    }
  }

  //get token
  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString('user');
    if (user != null) {
      return AuthResponseModel.fromJson(user).accessToken;
    } else {
      return null;
    }
  }

  //check if user is logged in
  Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString('user');
    return user != null;
  }

  Future<void> savePrinter(PrinterModel? data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data == null) {
      await prefs.remove('printer');
      return;
    }
    await prefs.setString('printer', data.toJson());
  }

  Future<PrinterModel?> getPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final printer = prefs.getString('printer');
    return printer != null ? PrinterModel.fromJson(printer) : null;
  }

  Future<void> saveStore(StoreModel? data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data == null) {
      await prefs.remove('store');
      return;
    }
    await prefs.setString('store', data.toJson());
  }

  Future<StoreModel?> getStore() async {
    final prefs = await SharedPreferences.getInstance();
    final store = prefs.getString('store');
    return store != null ? StoreModel.fromJson(store) : null;
  }
}
