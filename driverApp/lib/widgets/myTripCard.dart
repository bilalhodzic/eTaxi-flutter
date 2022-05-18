import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:thrifty_cab_driver/models/allRides.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';

class MyTripCard extends StatelessWidget {
  final Result data;

  MyTripCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Container(
      margin: EdgeInsets.only(right: b * 15, bottom: h * 10, left: b * 15),
      decoration: BoxDecoration(
        boxShadow: boxShadow2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: h * 13, left: b * 20),
                child: CachedImage(b: b, h: h),
              ),
              sb(10),
              Padding(
                padding: EdgeInsets.only(top: h * 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.customerName!,
                      style: TextStyle(
                        fontSize: b * 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    sh(3),
                    Text(
                      "+91 9044195099",
                      style: TextStyle(
                        color: Color(0xffa7a7a7),
                        fontSize: b * 10,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: b * 30, vertical: h * 7),
                decoration: BoxDecoration(
                  color: tagColor(data.bookingStatus!),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  data.bookingStatus!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: b * 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          sh(12),
          Container(
            margin: EdgeInsets.symmetric(horizontal: b * 15),
            color: primaryColor,
            height: h * 1.5,
            width: SizeConfig.screenWidth,
          ),
          sh(12),
          Container(
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.symmetric(horizontal: b * 16),
            padding: EdgeInsets.fromLTRB(b * 18, h * 10, b * 18, h * 10),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(b * 4),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/calendar.svg",
                            width: b * 10,
                            color: Colors.black,
                          ),
                          sb(8),
                          Text(
                            data.pickupDatetime!.substring(0, 10),
                            style: TextStyle(
                              fontSize: b * 10,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/distance.svg",
                            width: b * 10,
                            color: Colors.black,
                          ),
                          sb(8),
                          Text(
                            data.totalKmJourney.toString() + " KM",
                            style: TextStyle(
                              fontSize: b * 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                sh(10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/clock.svg",
                            width: b * 12,
                            color: Colors.black,
                          ),
                          sb(8),
                          Text(
                            timeFormat(TimeOfDay.fromDateTime(
                                DateTime.parse(data.pickupDatetime!))),
                            style: TextStyle(
                              fontSize: b * 10,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/cash.svg",
                            width: b * 12,
                            color: Colors.black,
                          ),
                          sb(8),
                          Text(
                            data.paymentMode!,
                            style: TextStyle(
                              fontSize: b * 10,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          sh(16),
          Padding(
            padding: EdgeInsets.fromLTRB(b * 16, 0, b * 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/blue_cirle.svg',
                      width: b * 17,
                    ),
                    sb(19),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.pickupAddress!,
                            style: TextStyle(
                              fontSize: b * 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Transform.translate(
                  offset: Offset(-b * 3, 0),
                  child: Icon(
                    Icons.more_vert,
                    color: Color(0xff999999),
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/choose_city.svg',
                      color: Colors.red,
                      height: h * 20,
                    ),
                    sb(19),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.dropAddress!,
                            style: TextStyle(
                              fontSize: b * 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          sh(16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: b * 15),
            color: primaryColor,
            height: h * 1.5,
            width: SizeConfig.screenWidth,
          ),
          sh(12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: b * 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: b * 9,
                    vertical: h * 5,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    data.fareApplied! + " Fare",
                    style: TextStyle(
                      fontSize: b * 12,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "TOTAL FARE",
                      style: TextStyle(
                        fontSize: b * 10,
                        letterSpacing: 0.6,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    sh(2),
                    Text(
                      "\u20b9 " + data.totalFare.toString(),
                      style: TextStyle(
                        fontSize: b * 18,
                        letterSpacing: 0.6,
                        color: secondaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          sh(14),
        ],
      ),
    );
  }
}

Color tagColor(String type) {
  if (type.tr() == CancelledLabel)
    return Color(0xffc22a23);
  else if (type.tr() == CompletedLabel)
    return Color(0xff14ce5e);
  else if (type.tr() == "Assigned")
    return Color(0xff55a3ff);
  else if (type.tr() == "Ongoing") return secondaryColor;
  return Color(0xff395185);
}
