import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thrifty_cab_driver/screens/profilePages/changePassword.dart';
import 'package:thrifty_cab_driver/screens/profilePages/profile.dart';
import 'package:thrifty_cab_driver/staticPages/privacy_policy.dart';
import 'package:thrifty_cab_driver/staticPages/tnc.dart';
import 'package:thrifty_cab_driver/utils/app_texts.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:thrifty_cab_driver/dialogBoxes/logoutDialog.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

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
                padding: EdgeInsets.symmetric(horizontal: b * 15),
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    sh(20),
                    Center(
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png",
                        width: b * 100,
                        height: h * 100,
                        fit: BoxFit.fitWidth,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    sh(8),
                    Text(
                      "Shikhar Raj",
                      style: TextStyle(
                        fontSize: b * 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    sh(22),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: h * 15),
                      decoration: BoxDecoration(
                        boxShadow: boxShadow2,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(b * 4),
                      ),
                      child: Row(
                        children: [
                          sb(24),
                          SvgPicture.asset(
                            'assets/icons/status.svg',
                            color: Colors.black,
                            height: h * 20,
                          ),
                          sb(22),
                          Text(
                            "Accepting Ride",
                            style: TextStyle(
                              fontSize: b * 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          FlutterSwitch(
                            duration: Duration(milliseconds: 100),
                            height: h * 25,
                            width: b * 43,
                            padding: b * 2,
                            toggleSize: b * 17,
                            borderRadius: b * 20,
                            activeColor: primaryColor,
                            value: status,
                            onToggle: (value) {
                              setState(() {
                                status = value;
                              });
                            },
                          ),
                          sb(24),
                        ],
                      ),
                    ),
                    sh(14),
                    SettingsTile(
                      title: ProfileLabel,
                      icon: 'profile_icon',
                      page: ProfilePage(),
                    ),
                    sh(14),
                    SettingsTile(
                      title: "Change Password",
                      icon: 'tnc_icon',
                      page: ChangePassword(),
                    ),
                    sh(14),
                    SettingsTile(
                      title: TnCLabel,
                      icon: 'tnc_icon',
                      page: TnCScreen(),
                    ),
                    sh(14),
                    SettingsTile(
                      title: PrivacyPolicyLabel,
                      icon: 'privacy_icon',
                      page: PrivacyPolicyScreen(),
                    ),
                    sh(50),
                    Center(
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

    return InkWell(
      onTap: () {
        if (page != null)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        else if (title != RateAppLabel)
          showDialog(
              context: context,
              builder: (context) {
                return dialogBox!;
              });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: h * 15),
        decoration: BoxDecoration(
          boxShadow: boxShadow2,
          color: Colors.white,
          borderRadius: BorderRadius.circular(b * 4),
        ),
        child: Row(
          children: [
            sb(24),
            SvgPicture.asset(
              'assets/icons/${this.icon}.svg',
              color: Colors.black,
              height: h * 20,
            ),
            sb(22),
            Text(
              this.title,
              style: TextStyle(
                fontSize: b * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.only(left: b * 2),
              width: b * 26,
              height: b * 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffc4c4c4).withOpacity(0.4),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: b * 13,
              ),
            ),
            sb(24),
          ],
        ),
      ),
    );
  }
}
