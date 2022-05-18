import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/models/profile.dart';
import 'package:thrifty_cab_driver/services/services.dart';
import 'package:thrifty_cab_driver/utils/app_texts.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';

class PersonalInfo extends StatelessWidget {
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
            txt: "Personal Information",
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
                child: FutureBuilder(
                    future: Services.getProfile(),
                    builder: (context, AsyncSnapshot<Profile?> snap) {
                      if (snap.hasData) {
                        Profile? data = snap.data;
                        return Column(
                          children: [
                            sh(20),
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: data!.body!.avatar!.imageUrl!,
                                width: b * 100,
                                height: h * 100,
                                fit: BoxFit.fitWidth,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                              data.body!.fullName!,
                              style: TextStyle(
                                fontSize: b * 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            sh(18),
                            Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.symmetric(
                                  vertical: h * 20, horizontal: b * 18),
                              decoration: BoxDecoration(
                                boxShadow: boxShadow2,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(b * 4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InfoTile(
                                    title: "Full Name",
                                    line: data.body!.fullName!,
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "Employee Id",
                                    line: data.body!.employeeId!,
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "Gender",
                                    line: data.body!.gender!,
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "Address",
                                    line: data.body!.address!,
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "Email",
                                    line: data.body!.email!,
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "Phone Number",
                                    line: data.body!.phoneNumber!,
                                    isNumber: true,
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "Alternate Phone Number",
                                    line: data.body!.alternatePhoneNumber!,
                                    isNumber: true,
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "Nationality",
                                    line: "Indian",
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "City",
                                    line: data.body!.cityName!,
                                  ),
                                  sh(24),
                                  InfoTile(
                                    title: "Admin Commission",
                                    line: data.body!.commission!.toString() +
                                        " %",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else
                        return sh(0);
                    }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String line;
  final bool isNumber;
  InfoTile({
    required this.title,
    required this.line,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.title,
          style: TextStyle(
            fontSize: b * 12,
            letterSpacing: 0.6,
            color: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.w400,
          ),
        ),
        sh(3),
        Wrap(
          children: [
            isNumber
                ? Image.asset(
                    'assets/images/India.png',
                    height: h * 20,
                    width: b * 20,
                  )
                : sh(0),
            isNumber ? sb(11) : sb(0),
            Text(
              this.line,
              style: TextStyle(
                fontSize: b * 14,
                color: Color(0xff3c3b3b),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
