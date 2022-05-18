import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/models/profile.dart';
import 'package:thrifty_cab_driver/services/services.dart';
import 'package:thrifty_cab_driver/utils/app_texts.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/widgets/vehicle_tags.dart';

class CarDetails extends StatefulWidget {
  @override
  State<CarDetails> createState() => _KycInfoState();
}

class _KycInfoState extends State<CarDetails> {
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
            txt: "Car Details",
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
                              decoration: BoxDecoration(
                                boxShadow: boxShadow2,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(b * 4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: h * 20, bottom: h * 20),
                                    width: SizeConfig.screenWidth,
                                    decoration: BoxDecoration(
                                      boxShadow: boxShadow2,
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(b * 4),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        sb(5),
                                        CachedNetworkImage(
                                          imageUrl: data!.body!.fleetAssigned!
                                              .vehiclePhotos!.first.imageUrl!,
                                          width: b * 138,
                                          height: h * 89,
                                          fit: BoxFit.fitWidth,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: b * 138,
                                            height: h * 89,
                                            decoration: BoxDecoration(
                                              color: secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        sb(20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.body!.fleetAssigned!
                                                  .modelName!,
                                              style: TextStyle(
                                                fontSize: b * 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            sh(10),
                                            Row(
                                              children: [
                                                Container(
                                                  height: h * 40,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: b * 9),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color(0xfff2f2f2),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Brand",
                                                        style: TextStyle(
                                                          fontSize: b * 10,
                                                          color:
                                                              Color(0xff3f3d56),
                                                        ),
                                                      ),
                                                      sh(7),
                                                      Text(
                                                        data
                                                            .body!
                                                            .fleetAssigned!
                                                            .brandName!,
                                                        style: TextStyle(
                                                          fontSize: b * 10,
                                                          color:
                                                              Color(0xffa7a7a7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                sb(12),
                                                Container(
                                                  height: h * 40,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: b * 9),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color(0xfff2f2f2),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Color",
                                                        style: TextStyle(
                                                          fontSize: b * 10,
                                                          color:
                                                              Color(0xff3f3d56),
                                                        ),
                                                      ),
                                                      sh(7),
                                                      Text(
                                                        data
                                                            .body!
                                                            .fleetAssigned!
                                                            .color!,
                                                        style: TextStyle(
                                                          fontSize: b * 10,
                                                          color:
                                                              Color(0xffa7a7a7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            sh(12),
                                            Text(
                                              "Registration",
                                              style: TextStyle(
                                                fontSize: b * 10,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.6,
                                                color: Color(0xff3f3d56),
                                              ),
                                            ),
                                            sh(10),
                                            Text(
                                              data.body!.fleetAssigned!
                                                  .registerationNumber!,
                                              style: TextStyle(
                                                fontSize: b * 18,
                                                fontWeight: FontWeight.w700,
                                                color: secondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  sh(40),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: b * 20, bottom: h * 20),
                                    child: Text(
                                      "Car Info",
                                      style: TextStyle(
                                        fontSize: b * 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: h * 1,
                                    width: SizeConfig.screenWidth,
                                    color: Color(0xffe5e5e5),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: b * 20, vertical: h * 16),
                                    child: Wrap(
                                      runSpacing: h * 5,
                                      children: [
                                        VehicleTags(
                                          txt: data.body!.fleetAssigned!
                                                  .seatingCapacity!
                                                  .toString() +
                                              " seater",
                                        ),
                                        sb(6),
                                        VehicleTags(
                                          txt: data
                                              .body!.fleetAssigned!.fuelType!,
                                        ),
                                        sb(6),
                                        VehicleTags(
                                          txt: data.body!.fleetAssigned!
                                              .transmissionType!,
                                        ),
                                        sb(6),
                                        VehicleTags(txt: "Air Bags"),
                                      ],
                                    ),
                                  ),
                                  DetailTile(
                                    title: "Engine Number",
                                    detail: data
                                        .body!.fleetAssigned!.enginerNumber!,
                                  ),
                                  sh(16),
                                  DetailTile(
                                    title: "Chasis Number",
                                    detail:
                                        data.body!.fleetAssigned!.chasisNumber!,
                                  ),
                                  sh(16),
                                  DetailTile(
                                    title: "Registration Number",
                                    detail: data.body!.fleetAssigned!
                                        .registerationNumber!,
                                  ),
                                  sh(16),
                                  DetailTile(
                                    title: "Model Number",
                                    detail:
                                        data.body!.fleetAssigned!.modelNumber!,
                                  ),
                                  sh(16),
                                  DetailTile(
                                    title: "Vehicle Year",
                                    detail:
                                        data.body!.fleetAssigned!.vehicleYear!,
                                  ),
                                  sh(34),
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

class DetailTile extends StatelessWidget {
  final String title;
  final String detail;
  DetailTile({
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    var b = SizeConfig.screenWidth / 375;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: b * 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.title,
            style: TextStyle(
              fontSize: b * 12,
              color: Color(0xff666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Text(
            this.detail,
            style: TextStyle(
              fontSize: b * 12,
            ),
          ),
        ],
      ),
    );
  }
}
