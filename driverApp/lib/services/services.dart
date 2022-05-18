import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' as rootBundle;
import 'package:thrifty_cab_driver/models/allRides.dart';
import 'package:thrifty_cab_driver/models/newRide.dart';
import 'package:thrifty_cab_driver/models/profile.dart';
import 'package:thrifty_cab_driver/models/rideDetails.dart';

class Services {
  static Future<Profile?> getProfile() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/json/profile.json');
    final data = jsonDecode(jsondata);
    return Profile.fromJson(data);
  }

  static Future<AllRides?> getAllRides() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/json/allRides.json');
    final data = jsonDecode(jsondata);
    return AllRides.fromJson(data);
  }

  static Future<RideDetails?> getRideDetail() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/json/rideDetail.json');
    final data = jsonDecode(jsondata);
    return RideDetails.fromJson(data);
  }

  static Future<NewRide?> getNewRide() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/json/newRide.json');
    final data = jsonDecode(jsondata);
    return NewRide.fromJson(data);
  }
}
