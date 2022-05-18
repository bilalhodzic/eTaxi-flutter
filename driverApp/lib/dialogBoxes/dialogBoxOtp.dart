import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/widgets/app_button.dart';
import 'package:thrifty_cab_driver/widgets/app_snackBar.dart';

class DialogBoxOtp extends StatefulWidget {
  @override
  _DialogBoxOtpState createState() => _DialogBoxOtpState();
}

class _DialogBoxOtpState extends State<DialogBoxOtp> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  bool isPressed = false;
  bool otpFull = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    BoxDecoration pinPutDecoration = BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.black, width: 1),
      ),
      color: Colors.white,
    );

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: b * 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(b * 30, h * 30, b * 30, h * 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Start a Ride",
                style: TextStyle(
                  fontSize: b * 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              sh(20),
              Text(
                "Please enter the OTP recieved on the Customer’s phone to start the Ride.",
                style: TextStyle(
                  fontSize: b * 12,
                  letterSpacing: 0.5,
                  color: Color(0xff3c3b3b),
                ),
              ),
              sh(10),
              PinPut(
                withCursor: true,
                fieldsCount: 5,
                textStyle: TextStyle(
                  fontSize: b * 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                eachFieldWidth: b * 22,
                eachFieldHeight: h * 10,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
              ),
              sh(20),
              Row(
                children: [
                  Text(
                    "Didn’t recieved OTP? ",
                    style: TextStyle(
                      fontSize: b * 12,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontSize: b * 12,
                        fontWeight: FontWeight.w500,
                        color: secondaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              sh(30),
              isPressed
                  ? LoadingButton()
                  : AppButton(
                      vertPad: h * 10,
                      label: "START",
                      onPressed: () {
                        if (_pinPutController.text.length == 5) {
                          setState(() {
                            isPressed = true;
                            otpFull = true;
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context);
                            appSnackBar(
                              context: context,
                              msg: "The ride is successfully started",
                              isError: false,
                            );
                          });
                        } else
                          setState(() {
                            otpFull = false;
                          });
                      },
                    ),
              otpFull ? sh(0) : sh(10),
              otpFull
                  ? sh(0)
                  : Text(
                      "Please enter the otp to start!",
                      style: TextStyle(
                        fontSize: b * 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
            ]),
          ),
        ],
      ),
    );
  }
}

void dialogBoxOtp(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return DialogBoxOtp();
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 300),
  );
}
