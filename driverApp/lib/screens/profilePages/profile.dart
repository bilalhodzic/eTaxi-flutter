import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/screens/profilePages/carDetails.dart';
import 'package:thrifty_cab_driver/screens/profilePages/kycInfo.dart';
import 'package:thrifty_cab_driver/screens/profilePages/personalInfo.dart';
import 'package:thrifty_cab_driver/utils/app_texts.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            txt: ProfileLabel,
            icon: 'assets/icons/settings.svg',
            isBackButton: true,
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
                    ProfileTile(
                      title: "Personal Info",
                      icon: 'info',
                      page: PersonalInfo(),
                      line: "Manage your phone number,address.....",
                    ),
                    sh(14),
                    ProfileTile(
                      title: "KYC Info",
                      icon: 'kyc',
                      page: KycInfo(),
                      line: "Manage your KYC info.....",
                    ),
                    sh(14),
                    ProfileTile(
                      title: "Car Details",
                      icon: 'car',
                      page: CarDetails(),
                      line: "Manage your car details.....",
                    ),
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

class ProfileTile extends StatelessWidget {
  final String title;
  final String icon;
  final dynamic page;
  final String line;
  ProfileTile({
    required this.title,
    required this.icon,
    required this.page,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
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
            Image.asset(
              'assets/icons/${this.icon}.png',
              height: h * 20,
              width: b * 22,
            ),
            sb(22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.title,
                  style: TextStyle(
                    fontSize: b * 14,
                    letterSpacing: 0.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  this.line,
                  style: TextStyle(
                    fontSize: b * 10,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
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
