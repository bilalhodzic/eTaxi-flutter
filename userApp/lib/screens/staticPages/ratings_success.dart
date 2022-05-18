import 'package:flutter/material.dart';
import 'package:thrifty_cab/screens/self%20drive/homeMain.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';

class RatingSuccessScreen extends StatelessWidget {
  const RatingSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeMain(index: 2),
            ),
            (route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(gradient: buttonGradient),
            child: Column(
              children: [
                AppBarText(
                  txt: RatingNReview,
                  icon: 'assets/icons/rating_icon.svg',
                  actionIcon: null,
                  isBackButton: false,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 45),
                    decoration: constBoxDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sh(100),
                        Image.asset(
                          'assets/images/rating_illus.png',
                          height: h * 156,
                          width: b * 276,
                        ),
                        sh(46),
                        Text(
                          ThankUFeedback,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        sh(30),
                        Center(
                          child: AppButton(
                            label: ContinueLabel,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeMain(index: 2),
                                  ),
                                  (route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
