import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:thrifty_cab_driver/screens/homeMain.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/widgets/app_button.dart';
import 'package:thrifty_cab_driver/widgets/app_snackBar.dart';

class DialogBoxComplete extends StatefulWidget {
  @override
  _DialogBoxCompleteState createState() => _DialogBoxCompleteState();
}

class _DialogBoxCompleteState extends State<DialogBoxComplete> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
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
                "Complete a Ride",
                style: TextStyle(
                  fontSize: b * 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              sh(20),
              Text(
                "Are you sure , want to complete the Ride ? Please Confirm to Complete",
                style: TextStyle(
                  fontSize: b * 12,
                  letterSpacing: 0.5,
                  color: Color(0xff3c3b3b),
                ),
              ),
              sh(20),
              isPressed
                  ? LoadingButton()
                  : AppButton(
                      vertPad: h * 10,
                      label: "COMPLETE RIDE",
                      onPressed: () {
                        setState(() {
                          isPressed = true;
                        });
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => HomeMain(
                                index: 1,
                              ),
                            ),
                          );
                          appSnackBar(
                            context: context,
                            msg: "The ride is successfully completed",
                            isError: false,
                          );
                        });
                      },
                    ),
            ]),
          ),
        ],
      ),
    );
  }
}

void dialogBoxComplete(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return DialogBoxComplete();
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 300),
  );
}
