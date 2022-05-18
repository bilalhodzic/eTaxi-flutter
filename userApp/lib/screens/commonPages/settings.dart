import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thrifty_cab/mode_selector.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/screens/staticPages/contactUs.dart';
import 'package:thrifty_cab/screens/commonPages/login.dart';
import 'package:thrifty_cab/screens/staticPages/privacy_policy.dart';
import 'package:thrifty_cab/screens/commonPages/profile.dart';
import 'package:thrifty_cab/screens/commonPages/register.dart';
import 'package:thrifty_cab/screens/staticPages/tnc.dart';
import 'package:thrifty_cab/screens/commonPages/changePassword.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/auth_button.dart';
import 'package:thrifty_cab/widgets/change_lang_dialog.dart';
import 'package:thrifty_cab/widgets/logoutDialog.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  final bool isTaxi;

  const Settings({Key? key, required this.isTaxi}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    final userProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(children: [
          AppBarText(
            txt: AccountSectionLabel,
            icon: 'assets/icons/settings.svg',
            isBackButton: false,
            actionIcon: null,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: b * 30),
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sh(50),
                    if (!(userProvider.user == null))
                      SettingsTile(
                        title: ProfileLabel,
                        icon: 'profile_icon',
                        page: ProfileScreen(
                          isBooking: false,
                        ),
                      ),
                    sh(21),
                    SettingsTile(
                      title: ChangePassLabel,
                      icon: 'tnc_icon',
                      page: ChangePassword(),
                    ),
                    sh(21),
                    SettingsTile(
                      title: changeLanguage,
                      icon: 'lang',
                      dialogBox: ChangeLangDialog(),
                    ),
                    sh(21),
                    SettingsTile(
                      title: TnCLabel,
                      icon: 'tnc_icon',
                      page: TnCScreen(),
                    ),
                    sh(21),
                    SettingsTile(
                      title: PrivacyPolicyLabel,
                      icon: 'privacy_icon',
                      page: PrivacyPolicyScreen(),
                    ),
                    sh(21),
                    SettingsTile(
                      title: ContactUsLabel,
                      icon: 'privacy_icon',
                      page: ContactUs(),
                    ),
                    sh(21),
                    SettingsTile(
                      title: widget.isTaxi ? BookSelfLabel : BookTaxiLabel,
                      icon: 'choose_your_car',
                      page: null,
                    ),
                    sh(21),
                    userProvider.user == null ||
                            userProvider.user!.apiToken == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AuthButton(
                                  color: Colors.green,
                                  label: LoginLabel,
                                  onPress: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              sb(20),
                              Expanded(
                                child: AuthButton(
                                  color: primaryColor,
                                  label: RegisterLabel,
                                  onPress: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => RegisterScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: MaterialButton(
                              elevation: 0,
                              splashColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              highlightColor: Colors.transparent,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(b * 5),
                              ),
                              onPressed: () {
                                dialogBoxLogout(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: h * 15),
                                decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor),
                                  borderRadius: BorderRadius.circular(b * 5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout_rounded, size: b * 16),
                                    sb(5),
                                    Text(
                                      LogOutLabel,
                                      style: TextStyle(
                                        fontSize: b * 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    sh(30),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final String icon;
  final dynamic page;
  final Widget? dialogBox;
  SettingsTile(
      {required this.title, required this.icon, this.page, this.dialogBox});

  @override
  Widget build(BuildContext context) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return MaterialButton(
      elevation: 0,
      splashColor: primaryColor,
      padding: EdgeInsets.zero,
      highlightColor: primaryColor,
      color: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 4),
      ),
      onPressed: () {
        if (page != null)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        else if (dialogBox != null) {
          showDialog(
              context: context,
              builder: (context) {
                return dialogBox!;
              });
        } else if (title != RateAppLabel) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => ModeSelectorScreen(),
            ),
            (route) => false,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: h * 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(b * 4),
        ),
        child: Row(
          children: [
            sb(40),
            SvgPicture.asset(
              'assets/icons/${this.icon}.svg',
              color: Colors.black,
              height: h * 16,
            ),
            sb(22),
            Text(
              this.title,
              style: TextStyle(
                fontSize: b * 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
