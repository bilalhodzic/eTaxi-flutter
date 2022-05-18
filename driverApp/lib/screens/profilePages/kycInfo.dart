import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/models/profile.dart';
import 'package:thrifty_cab_driver/screens/profilePages/docPreview.dart';
import 'package:thrifty_cab_driver/services/services.dart';
import 'package:thrifty_cab_driver/utils/app_texts.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';

class KycInfo extends StatefulWidget {
  @override
  State<KycInfo> createState() => _KycInfoState();
}

class _KycInfoState extends State<KycInfo> {
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
            txt: "KYC Information",
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
                            Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.fromLTRB(
                                  b * 20, h * 20, 0, h * 20),
                              decoration: BoxDecoration(
                                boxShadow: boxShadow2,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(b * 4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Driving License number",
                                    style: TextStyle(
                                      fontSize: b * 10,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  sh(3),
                                  Text(
                                    data!.body!.licenseNumber!,
                                    style: TextStyle(
                                      fontSize: b * 14,
                                      color: Color(0xff3c3b3b),
                                    ),
                                  ),
                                  sh(20),
                                  docContainer(
                                    label: "Identity Card",
                                    file: data.body!.kycDocuments!
                                        .elementAt(1)
                                        .images,
                                    fileCode: 1,
                                  ),
                                  docContainer(
                                    label: "Address Proof",
                                    file:
                                        data.body!.kycDocuments!.first.images!,
                                    fileCode: 2,
                                  ),
                                  docContainer(
                                    label: "Driving License",
                                    file: data.body!.licenseImage!.images!,
                                    fileCode: 3,
                                  )
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

  Widget docContainer({
    @required String? label,
    @required List<Images>? file,
    @required int? fileCode,
  }) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? "",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: b * 10,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        sh(10),
        SizedBox(
          height: h * 95,
          width: SizeConfig.screenWidth,
          child: ListView.builder(
            padding: EdgeInsets.only(left: b * 0, bottom: h * 0, top: h * 2),
            physics: BouncingScrollPhysics(),
            itemCount: file!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(right: b * 6),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DocPreview(
                          photoUrl: file.elementAt(index).imageUrl!,
                          name: label,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: file.elementAt(index).imageUrl!,
                    width: b * 128,
                    height: h * 83,
                    fit: BoxFit.fitWidth,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(b * 4),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        sh(20),
      ],
    );
  }
}
