import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:thrifty_cab/models/taxi/allRides.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/strings.dart';
import '../utils/sizeConfig.dart';

class MyTripCard extends StatelessWidget {
  final Result res;

  const MyTripCard({Key? key, required this.res}) : super(key: key);
  static List images = [
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340049/thriftycab/avatar/merry_rose_sfxyaa.jpg",
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340047/thriftycab/avatar/juhi_eoiulv.jpg",
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340045/thriftycab/avatar/joe_west_zbwgfe.jpg",
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340042/thriftycab/avatar/michail_ratbej.jpg",
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340040/thriftycab/avatar/fatima_feroz_danhwm.jpg",
  ];

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
                child: CachedNetworkImage(
                  imageUrl: (images..shuffle()).first,
                  width: b * 56,
                  height: h * 59,
                  fit: BoxFit.fitWidth,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(b * 6),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              sb(10),
              Padding(
                padding: EdgeInsets.only(top: h * 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      res.driver!,
                      style: TextStyle(
                        fontSize: b * 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    sh(3),
                    Text(
                      res.fleetAssigned!.modelName!,
                      style: TextStyle(
                        color: Color(0xff3f3d56),
                        fontSize: b * 12,
                      ),
                    ),
                    sh(3),
                    Text(
                      res.fleetAssigned!.registerationNumber!,
                      style: TextStyle(
                        color: Color(0xff3f3d56),
                        fontSize: b * 12,
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
                  color: tagColor(res.bookingStatus!),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  res.bookingStatus!.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: b * 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          sh(14),
          Container(
            margin: EdgeInsets.symmetric(horizontal: b * 15),
            color: primaryColor,
            height: h * 1.5,
            width: SizeConfig.screenWidth,
          ),
          sh(12),
          Padding(
            padding: EdgeInsets.fromLTRB(b * 16, 0, b * 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/blue_cirle.svg',
                      width: b * 17,
                    ),
                    sb(19),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            res.pickupAddress!,
                            style: TextStyle(
                              fontSize: b * 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/calendar.svg",
                                width: b * 10,
                                color: Colors.black,
                              ),
                              sb(8),
                              Text(
                                res.pickupDatetime!.substring(0, 10),
                                style: TextStyle(
                                  fontSize: b * 10,
                                ),
                              ),
                            ],
                          ),
                          sh(3),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/clock.svg",
                                width: b * 14,
                                color: Colors.black,
                              ),
                              sb(8),
                              Text(
                                timeFormat(TimeOfDay.fromDateTime(
                                    DateTime.parse(res.pickupDatetime!))),
                                style: TextStyle(
                                  fontSize: b * 10,
                                ),
                              ),
                            ],
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
                sh(5),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/choose_city.svg',
                      color: Colors.red,
                      height: h * 20,
                    ),
                    sb(19),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            res.dropAddress!,
                            style: TextStyle(
                              fontSize: b * 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [],
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
                    res.bookingType!,
                    style: TextStyle(
                      fontSize: b * 12,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
                sb(16),
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
                    res.fareApplied! + " $FareLabel",
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
                      TotalFareLabel.toUpperCase(),
                      style: TextStyle(
                        fontSize: b * 10,
                        letterSpacing: 0.6,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    sh(2),
                    Text(
                      "\u20b9 " + res.totalFare.toString(),
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

  String label(String title) {
    if (title == ReportLabel)
      return "assets/icons/report.svg";
    else if (title == CancelLabel)
      return "assets/icons/cancel.svg";
    else if (title == UpdateLabel)
      return "assets/icons/update.svg";
    else if (title == ReportHisLabel)
      return "assets/icons/report.svg";
    else if (title == RatingLabel) return "assets/icons/rating.svg";
    return '';
  }
}

Color tagColor(String type) {
  if (type.tr() == CancelledLabel)
    return Color(0xffc22a23);
  else if (type.tr() == CompletedLabel)
    return Color(0xff14ce5e);
  else if (type.tr() == ConfirmedLabel)
    return Color(0xff55a3ff);
  else if (type.tr() == PendingLabel) return primaryColor;
  return Color(0xff395185);
}
