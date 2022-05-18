import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/screens/self%20drive/homeMain.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/providers/taxi/booking_provider.dart';
import 'package:thrifty_cab/screens/taxi/home_main_taxi.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';

class ModeSelectorScreen extends StatefulWidget {
  const ModeSelectorScreen({Key? key}) : super(key: key);

  @override
  State<ModeSelectorScreen> createState() => _ModeSelectorScreenState();
}

class _ModeSelectorScreenState extends State<ModeSelectorScreen> {
  late double h, b;
  bool isSelf = false;
  bool isTaxi = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    h = MediaQuery.of(context).size.height / 812;
    b = MediaQuery.of(context).size.width / 375;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              sh(80),
              Image.asset(
                'assets/logo/logo.png',
                width: b * 215,
              ),
              sh(60),
              Text(
                ChooseOptionLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: b * 24,
                ),
              ),
              sh(16),
              Text(
                WhatToRideLabel,
                style: TextStyle(
                  fontSize: b * 12,
                ),
              ),
              sh(31),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    isSelf = true;
                    isTaxi = false;
                  });

                  Future.delayed(Duration(milliseconds: 20), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => HomeMain(),
                      ),
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelf ? primaryColor : Color(0xfff9f9f9),
                    borderRadius: BorderRadius.circular(b * 4),
                  ),
                  height: h * 122,
                  width: b * 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/self_drive.png',
                        width: b * 61,
                        height: h * 61,
                      ),
                      sh(12),
                      Text(
                        SelfDriveLabel,
                        style: TextStyle(
                          fontSize: b * 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sh(20),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    isSelf = false;
                    isTaxi = true;
                  });

                  Future.delayed(Duration(milliseconds: 20), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                                create: (_) => TaxiBookingProvider()),
                            ChangeNotifierProvider(
                                create: (_) => AppFlowProvider())
                          ],
                          child: HomeMainTaxi(),
                        ),
                      ),
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isTaxi ? primaryColor : Color(0xfff9f9f9),
                    borderRadius: BorderRadius.circular(b * 4),
                  ),
                  height: h * 122,
                  width: b * 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/taxi.png',
                        width: b * 61,
                        height: h * 61,
                      ),
                      sh(12),
                      Text(
                        TaxiLabel,
                        style: TextStyle(
                          fontSize: b * 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
