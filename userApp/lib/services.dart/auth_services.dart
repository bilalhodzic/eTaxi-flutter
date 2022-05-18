import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;

final apiurl = 'https://localhost:44310/';
final realDeviceUri = 'http://192.168.0.15:44310/';
final localUri = 'http://10.0.2.2:44310/';
final ngRokUri = 'https://5cfd-93-180-105-223.eu.ngrok.io/';

class AuthServices {
  static Future loginServices() async {
    var url = '${ngRokUri}authentication/login';
    log("🚀 ~ url $url");
    final res = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': 'text/plain'
      },
      body: jsonEncode(<String, String>{
        'userName': 'admin@admin.com',
        "password": 'qweasd'
      }),
    );

     print('Response status: ${res}');
    log('Response body: ${res}');

    final jsondata =
        await rootBundle.rootBundle.loadString('assets/json/profile.json');
    final data = jsonDecode(jsondata);
    return data;
  }

  static Future<void> sendOtpServices() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/json/sendOTP.json');
    final data = jsonDecode(jsondata);
    return data;
  }

  static Future<void> verifyOtpServices() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/json/verifyOTP.json');
    final data = jsonDecode(jsondata);
    return data;
  }
}
