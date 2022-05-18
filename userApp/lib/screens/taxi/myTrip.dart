import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thrifty_cab/models/taxi/allRides.dart';
import 'package:thrifty_cab/screens/taxi/rideDetailOutstation.dart';
import 'package:thrifty_cab/services.dart/taxiSerivces.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgetsTaxi/myTripCard.dart';

class MyTrips extends StatefulWidget {
  const MyTrips({Key? key}) : super(key: key);

  @override
  _MyTripsState createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  List<String> types = [
    AllBookingsLabel,
    PendingLabel,
    ConfirmedLabel,
    OnGoingLabel,
    CompletedLabel,
    CancelledLabel,
  ];
  String historyType = AllBookingsLabel;
  List numbers = [1, 3, 2, 8, 5, 0, 4, 6, 7];

  @override
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
              child: Row(children: [
                Spacer(),
                Text(
                  MyTripsLabel,
                  style: TextStyle(
                    fontSize: b * 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                Spacer(),
                PopupMenuButton<String>(
                  padding: EdgeInsets.only(left: b * 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(b * 4),
                  ),
                  onSelected: (value) {
                    setState(() {
                      historyType = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return types.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              choice != OnGoingLabel
                                  ? label(choice)
                                  : "assets/icons/choose_your_car.svg",
                              width: b * 16,
                              color: Colors.black,
                            ),
                            sb(26),
                            Text(
                              choice,
                              style: TextStyle(
                                fontSize: b * 14,
                                color: Colors.black.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: SvgPicture.asset(
                    "assets/icons/filter.svg",
                    color: Colors.black,
                    width: b * 20,
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
                    sh(20),
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
                                  Result res =
                                      data.body!.result![numbers[index]];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RideDetailOutstation(
                                            res: res,
                                          ),
                                        ),
                                      );
                                    },
                                    child: historyType != AllBookingsLabel
                                        ? res.bookingStatus?.tr() != historyType
                                            ? sh(0)
                                            : MyTripCard(
                                                res: res,
                                              )
                                        : MyTripCard(res: res),
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

  String label(String title) {
    if (title == PendingLabel)
      return "assets/icons/pending.svg";
    else if (title == ConfirmedLabel)
      return "assets/icons/confirmed.svg";
    else if (title == CompletedLabel)
      return "assets/icons/completed.svg";
    else if (title == CancelledLabel)
      return "assets/icons/cancelled.svg";
    else if (title == ConfirmedLabel)
      return "assets/icons/confirmed.svg";
    else if (title == AllBookingsLabel) return "assets/icons/all bookings.svg";

    return '';
  }
}
