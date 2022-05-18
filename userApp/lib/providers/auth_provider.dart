import 'package:flutter/material.dart';
import 'package:thrifty_cab/models/user_model.dart';
import 'package:thrifty_cab/services.dart/auth_services.dart';
import 'package:thrifty_cab/services.dart/preferences.dart';
import 'package:thrifty_cab/services.dart/profile_services.dart';
import 'package:thrifty_cab/services.dart/storage_services.dart';

class AuthProvider extends ChangeNotifier {
  Userinfo? _user;
  Userinfo? get user => _user;

  Future<void> setUser(Userinfo? usr) async {
    _user = usr;
  }


  Future<void> login() async {
    try {
      var res = await AuthServices.loginServices();

      _user = Userinfo.fromJson(res['data']['userinfo']);

      final res2 = await ProfileServices.getProfileData();
      final data = res2['data'];
      _user!.nationality = data['nationality'] ?? "null";
      _user!.address = data['address'] ?? "";
      _user!.docType = data['doc_type'];
      _user!.emailVerified = 1;

      if (data['doc_type'] == '1') {
        await StorageServices.saveDocToLocal(docType: '1', data: data);
      } else if (data['doc_type'] == '0')
        await StorageServices.saveDocToLocal(docType: '0', data: data);

      await PreferencesUtils.setUser(_user!);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> sendOTP(String phone) async {
    try {
      await AuthServices.sendOtpServices();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> verifyOTP(String phone, String otp) async {
    try {
      await AuthServices.verifyOtpServices();
      await PreferencesUtils.setIntPref(PreferencesUtils.phoneVerified, 1);
      print("OTP Verification Success");
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> logout() async {
    _user = Userinfo();
    await PreferencesUtils.clearPref();
    await StorageServices.clearStorageOnLogout();

    notifyListeners();
  }

  setUserOnLogin() async {
    try {
      final res2 = await ProfileServices.getProfileData();
      final data = res2['data'];
      _user!.nationality = data['nationality'] ?? "null";
      _user!.address = data['address'] ?? "";
      _user!.docType = data['doc_type'];
      _user!.emailVerified = 1;

      if (data['doc_type'] == '1')
        await StorageServices.saveDocToLocal(docType: '1', data: data);
      else if (data['doc_type'] == '0')
        await StorageServices.saveDocToLocal(docType: '0', data: data);

      await PreferencesUtils.setUser(_user!);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> setUserData(Map<String, dynamic> data) async {
    _user!.phone = data['phone'];
    _user!.phoneCode = data['phone_code'];
    _user!.nationality = data['nationality'];
    _user!.address = data['address'];
    _user!.docType = data['doc_type'];
  }

  Future<void> setUserFromLocal(Userinfo usr) async {
    _user!.userName = usr.userName;
    _user!.address = usr.address;
    _user!.phone = usr.phone;
    _user!.nationality = usr.nationality;
    _user!.docType = usr.docType;

    await PreferencesUtils.setUser(_user!);
  }
}
