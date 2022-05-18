import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/screens/commonPages/login.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:provider/provider.dart';

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: h * 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(b * 4),
                      ),
                      child: Text(
                        NoLabel,
                        style: TextStyle(
                          letterSpacing: 0.6,
                          fontSize: b * 12,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                sb(20),
                Expanded(
                  child: AppButton(
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    label: OkayLabel,
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
