import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thrifty_cab_driver/dialogBoxes/dialogBoxCancel.dart';
import 'package:thrifty_cab_driver/dialogBoxes/dialogBoxComplete.dart';
import 'package:thrifty_cab_driver/dialogBoxes/dialogBoxOtp.dart';
import 'package:thrifty_cab_driver/models/allRides.dart';
import 'package:thrifty_cab_driver/models/rideDetails.dart';
import 'package:thrifty_cab_driver/services/services.dart';
import 'package:thrifty_cab_driver/widgets/myTripCard.dart';
import 'package:thrifty_cab_driver/utils/app_texts.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';
import 'package:thrifty_cab_driver/widgets/app_button.dart';

class RideDetail extends StatelessWidget {
  final Result res;

  const RideDetail({Key? key, required this.res}) : super(key: key);
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
            AppBarText(
              txt: "Ride Detail",
              icon: 'assets/icons/settings.svg',
              isBackButton: true,
              actionIcon: null,
            ),
            Expanded(
              child: Container(
                decoration: constBoxDecoration,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: b * 30),
                  child: FutureBuilder(
                      future: Services.getRideDetail(),
                      builder: (context, AsyncSnapshot<RideDetails?> snap) {
                        if (snap.hasData) {
                          RideDetails? data = snap.data;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sh(20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CachedImage(b: b, h: h),
                                  sb(10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        res.customerName!,
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
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: b * 30, vertical: h * 7),
                                    decoration: BoxDecoration(
                                      color: tagColor(res.bookingStatus!),
                                    ),
                                    child: Text(
                                      res.bookingStatus!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: b * 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              sh(17),
                              Container(
                                color: primaryColor,
                                height: h * 1.5,
                                width: SizeConfig.screenWidth,
                              ),
                              sh(12),
                              Container(
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.fromLTRB(
                                    b * 18, h * 10, b * 18, h * 10),
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
                                                res.pickupDatetime!
                                                    .substring(0, 10),
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
                                                res.totalKmJourney.toString() +
                                                    " KM",
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
                                                timeFormat(
                                                    TimeOfDay.fromDateTime(
                                                        DateTime.parse(res
                                                            .pickupDatetime!))),
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
                                                res.paymentMode!,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/blue_cirle.svg',
                                        width: b * 17,
                                      ),
                                      sb(19),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            res.pickupDatetime!
                                                .substring(0, 10),
                                            style: TextStyle(
                                              fontSize: b * 10,
                                              color: Color(0xffa7a7a7),
                                            ),
                                          ),
                                          Text(
                                            timeFormat(TimeOfDay.fromDateTime(
                                                DateTime.parse(
                                                    res.pickupDatetime!))),
                                            style: TextStyle(
                                              fontSize: b * 10,
                                              color: Color(0xffa7a7a7),
                                            ),
                                          ),
                                        ],
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      res.bookingStatus == "Completed"
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  res.dropDatetime!
                                                      .substring(0, 10),
                                                  style: TextStyle(
                                                    fontSize: b * 10,
                                                    color: Color(0xffa7a7a7),
                                                  ),
                                                ),
                                                Text(
                                                  timeFormat(
                                                      TimeOfDay.fromDateTime(
                                                          DateTime.parse(res
                                                              .dropDatetime!))),
                                                  style: TextStyle(
                                                    fontSize: b * 10,
                                                    color: Color(0xffa7a7a7),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : sh(0),
                                    ],
                                  ),
                                ],
                              ),
                              sh(16),
                              Container(
                                color: primaryColor,
                                height: h * 1.5,
                                width: SizeConfig.screenWidth,
                              ),
                              sh(14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sb(5),
                                  CachedNetworkImage(
                                    imageUrl: data!.body!.fleetAssigned!
                                        .vehiclePhotos!.first.imageUrl!,
                                    width: b * 114,
                                    height: h * 80,
                                    fit: BoxFit.fitWidth,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: b * 114,
                                      height: h * 80,
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  sb(18),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.body!.fleetAssigned!.modelName!,
                                        style: TextStyle(
                                          fontSize: b * 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      sh(4),
                                      Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Brand",
                                                style: TextStyle(
                                                  fontSize: b * 10,
                                                  color: Color(0xff3f3d56),
                                                ),
                                              ),
                                              sb(6),
                                              Text(
                                                data.body!.fleetAssigned!
                                                    .brandName!,
                                                style: TextStyle(
                                                  fontSize: b * 10,
                                                  color: Color(0xffa7a7a7),
                                                ),
                                              ),
                                            ],
                                          ),
                                          sb(32),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Color",
                                                style: TextStyle(
                                                  fontSize: b * 10,
                                                  color: Color(0xff3f3d56),
                                                ),
                                              ),
                                              sb(6),
                                              Text(
                                                data.body!.fleetAssigned!
                                                    .color!,
                                                style: TextStyle(
                                                  fontSize: b * 10,
                                                  color: Color(0xffa7a7a7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      sh(7),
                                      Text(
                                        "Registration Number",
                                        style: TextStyle(
                                          fontSize: b * 10,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.6,
                                          color: Color(0xff3f3d56),
                                        ),
                                      ),
                                      sh(5),
                                      Text(
                                        data.body!.fleetAssigned!
                                            .registerationNumber!,
                                        style: TextStyle(
                                          fontSize: b * 14,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              sh(24),
                              Container(
                                color: primaryColor,
                                height: h * 1.5,
                                width: SizeConfig.screenWidth,
                              ),
                              sh(16),
                              Text(
                                "Booking & Bill Detail",
                                style: TextStyle(
                                  fontSize: b * 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              sh(15),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(b * 4),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sh(19),
                                    textRow(b, BookingIdLabel, res.id!, h),
                                    textRow(
                                        b,
                                        "Total KM",
                                        res.totalKmJourney.toString() + " kms",
                                        h),
                                    textRow(
                                        b, "Fare Applied", res.fareApplied!, h),
                                    textRow(b, "Base Fare",
                                        "\u20b9 " + res.baseFare.toString(), h),
                                    textRow(b, "Excess Km",
                                        res.excessKm.toString() + ' Kms', h),
                                    textRow(
                                        b,
                                        "Standard Fare/Km",
                                        '\u20b9 ${res.standardFarePerKm}/Km',
                                        h),
                                    textRow(
                                        b,
                                        "Additional Fare",
                                        '\u20b9 ' +
                                            res.additonalFare.toString(),
                                        h),
                                    textRow(
                                        b,
                                        "Sub Total Fare",
                                        '\u20b9 ' + res.subTotalFare.toString(),
                                        h),
                                    textRow(
                                        b,
                                        "Total Discount",
                                        '\u20b9 ' +
                                            res.totalDiscount.toString(),
                                        h),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: b * 17),
                                      color: borderColor,
                                      height: h * 1.5,
                                      width: SizeConfig.screenWidth,
                                    ),
                                    sh(12),
                                    textRow(
                                      b,
                                      "Total Fare",
                                      '\u20b9 ' + res.totalFare.toString(),
                                      h,
                                      isBold: true,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: b * 2, top: h * 16, bottom: h * 20),
                                child: Text(
                                  "** $GSTLabel",
                                  style: TextStyle(
                                    fontSize: b * 10,
                                    color: Colors.black.withOpacity(0.7),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                              res.bookingStatus == 'Ongoing'
                                  ? AppButton(
                                      label: "COMPLETE RIDE",
                                      onPressed: () {
                                        dialogBoxComplete(context);
                                      },
                                    )
                                  : sh(0),
                              res.bookingStatus == 'Assigned'
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              dialogBoxCancel(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: h * 15),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        b * 5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "CANCEL",
                                                  style: TextStyle(
                                                    fontSize: b * 12,
                                                    height: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        sb(25),
                                        Expanded(
                                          child: AppButton(
                                            label: "START RIDE",
                                            onPressed: () {
                                              dialogBoxOtp(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : sh(0),
                              res.bookingStatus == 'Cancelled'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        sh(12),
                                        Container(
                                          color: primaryColor,
                                          height: h * 1.5,
                                          width: SizeConfig.screenWidth,
                                        ),
                                        sh(12),
                                        Text(
                                          "Cancellation Reason",
                                          style: TextStyle(
                                            fontSize: b * 12,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                        sh(7),
                                        Container(
                                          width: SizeConfig.screenWidth,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: b * 16,
                                              vertical: h * 16),
                                          decoration: BoxDecoration(
                                            color: Color(0xffF6F6F6),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            data.body!.cancellationReason!,
                                            style: TextStyle(
                                              fontSize: b * 12,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : sh(0),
                              sh(30),
                            ],
                          );
                        } else
                          return sh(0);
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textRow(double b, String? title, String? content, double h,
      {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(left: b * 20, right: b * 20, bottom: h * 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title!,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
                fontSize: b * 12,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content!,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
                fontSize: b * 12,
                color: secondaryColor,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
