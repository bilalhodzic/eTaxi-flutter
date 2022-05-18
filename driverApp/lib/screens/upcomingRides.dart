import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/models/allRides.dart';
import 'package:thrifty_cab_driver/screens/rideDetail.dart';
import 'package:thrifty_cab_driver/services/services.dart';
import 'package:thrifty_cab_driver/widgets/upcomingRidesCard.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';

class UpcomingRides extends StatefulWidget {
  const UpcomingRides({Key? key}) : super(key: key);

  @override
  _UpcomingRidesState createState() => _UpcomingRidesState();
}

class _UpcomingRidesState extends State<UpcomingRides> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: buttonGradient,
              ),
              padding:
                  EdgeInsets.symmetric(vertical: h * 22, horizontal: b * 20),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Upcoming Rides",
                  style: TextStyle(
                    fontSize: b * 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Container(
                width: SizeConfig.screenWidth,
                decoration: constBoxDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sh(10),
                    Expanded(
                      child: FutureBuilder(
                          future: Services.getAllRides(),
                          builder: (context, AsyncSnapshot<AllRides?> snap) {
                            if (snap.hasData) {
                              AllRides? data = snap.data;
                              return ListView.builder(
                                padding: EdgeInsets.only(top: h * 10),
                                shrinkWrap: true,
                                itemCount: data!.body!.result!.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Result res = data.body!.result![index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RideDetail(res: res),
                                        ),
                                      );
                                    },
                                    child: res.bookingStatus == 'Ongoing' ||
                                            res.bookingStatus == 'Assigned'
                                        ? UpcomingRideCard(
                                            data: res,
                                          )
                                        : sh(0),
                                  );
                                },
                              );
                            } else
                              return sh(0);
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
