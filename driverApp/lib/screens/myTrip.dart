import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thrifty_cab_driver/models/allRides.dart';
import 'package:thrifty_cab_driver/screens/rideDetail.dart';
import 'package:thrifty_cab_driver/services/services.dart';
import 'package:thrifty_cab_driver/widgets/myTripCard.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({Key? key}) : super(key: key);

  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  List<String> types = [
    AllBookingsLabel,
    "Assigned",
    "Ongoing",
    CompletedLabel,
    CancelledLabel,
  ];
  String historyType = AllBookingsLabel;

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
                  "My Trips",
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
                              label(choice),
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
                                          builder: (context) => RideDetail(
                                            res: res,
                                          ),
                                        ),
                                      );
                                    },
                                    child: historyType != AllBookingsLabel
                                        ? res.bookingStatus != historyType
                                            ? sh(0)
                                            : MyTripCard(
                                                data: res,
                                              )
                                        : MyTripCard(data: res),
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
    if (title == "Assigned")
      return "assets/icons/pending.svg";
    else if (title == CompletedLabel)
      return "assets/icons/completed.svg";
    else if (title == CancelledLabel)
      return "assets/icons/cancelled.svg";
    else if (title == "Ongoing")
      return "assets/icons/choose_your_car.svg";
    else if (title == AllBookingsLabel) return "assets/icons/all bookings.svg";

    return '';
  }
}
