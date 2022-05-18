import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/utils/app_texts.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';

class TnCScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: buttonGradient),
          child: Column(
            children: [
              AppBarText(
                txt: TnCLabel,
                icon: 'assets/icons/tnc_icon.svg',
                actionIcon: null,
                isBackButton: true,
              ),
              Expanded(
                child: Container(
                  width: SizeConfig.screenWidth,
                  decoration: constBoxDecoration,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: b * 30),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sh(42),
                        Text(
                          LastUpdate + ": 28th Nov 2021",
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff999999),
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          AcceptingTheTerm,
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(20),
                        Text(
                          DummyTnC,
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
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
