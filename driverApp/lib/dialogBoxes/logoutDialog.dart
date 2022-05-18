import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:thrifty_cab_driver/screens/authScreens/login.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';
import 'package:thrifty_cab_driver/widgets/app_button.dart';

class LogOutDialog extends StatelessWidget {
  LogOutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: b * 30),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 10),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: b * 16, vertical: h * 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/activate_email_illus.png',
              height: h * 100,
            ),
            sh(10),
            Text(
              ConfirmLogoutMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: b * 14,
              ),
            ),
            sh(25),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: h * 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(b * 5),
                      ),
                      child: Center(
                        child: Text(
                          "NO",
                          style: TextStyle(
                            fontSize: b * 12,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                sb(25),
                Expanded(
                  child: AppButton(
                    vertPad: h * 10,
                    label: "Yes",
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

dialogBoxLogout(BuildContext context) async {
  await showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (BuildContext context) {
      return LogOutDialog();
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 300),
  );
}
