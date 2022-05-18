import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:thrifty_cab/mode_selector.dart';
import 'package:thrifty_cab/screens/commonPages/login.dart';
import 'package:thrifty_cab/services.dart/preferences.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'models/user_model.dart';

class AuthWidget extends StatefulWidget {
  AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );
  @override
  void initState() {
    checkState();
    super.initState();
  }

  checkState() async {
    Userinfo? _user = await PreferencesUtils.getUser();
    log('user is $_user');

    _controller.animateTo(1, curve: Curves.easeInCirc);

    await Future.delayed(Duration(milliseconds: 1500));
    if (_user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            fromRoot: true,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ModeSelectorScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    return Scaffold(
      body: Container(
        height: h * 812,
        width: b * 375,
        padding: EdgeInsets.symmetric(horizontal: b * 80, vertical: h * 290),
        decoration: BoxDecoration(gradient: buttonGradient),
        child: ScaleTransition(
          alignment: Alignment.center,
          scale: _controller,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: b * 30),
            width: b * 200,
            height: h * 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              'assets/logo/logo.png',
            ),
          ),
        ),
      ),
    );
  }
}
