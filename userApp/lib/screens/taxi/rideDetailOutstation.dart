import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thrifty_cab/models/taxi/allRides.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/vehicle_tags.dart';
import 'package:thrifty_cab/widgetsTaxi/addressCard.dart';
import 'package:thrifty_cab/widgetsTaxi/driverCard.dart';
import 'package:thrifty_cab/widgetsTaxi/fareDetails.dart';

class RideDetailOutstation extends StatelessWidget {
  final Result res;
  bool round = false;
  RideDetailOutstation({Key? key, required this.res}) : super(key: key);
  TextEditingController promoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    round = res.bookingType == 'Local'
        ? false
        : res.tripType == 'Round'
            ? true
            : false;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            AppBarText(
              txt: "${res.bookingType} " + BookingLabel.tr(),
              icon: 'assets/icons/settings.svg',
              isBackButton: true,
              actionIcon: null,
            ),
            Expanded(
              child: Container(
                decoration: constBoxDecoration,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: b * 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sh(15),
                      AddressCard(
                        b: b,
                        h: h,
                        pickUp: res.pickupAddress!,
                        destination: res.dropAddress!,
                      ),
                      sh(16),
                      Container(
                        width: SizeConfig.screenWidth,
                        padding:
                            EdgeInsets.fromLTRB(b * 17, h * 20, b * 17, h * 20),
                        decoration: allBoxDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            res.bookingType != 'Local'
                                ? Row(
                                    children: [
                                      Container(
                                        width: b * 138,
                                        height: h * 56,
                                        decoration: BoxDecoration(
                                          color: !round
                                              ? primaryColor
                                              : Color(0xfff9f9f9),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              OnewayLabel,
                                              style: TextStyle(
                                                fontSize: b * 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff3C3B3B),
                                              ),
                                            ),
                                            sh(4),
                                            Text(
                                              DroppedOffLabel,
                                              style: TextStyle(
                                                fontSize: b * 12,
                                                color: Color(0xff3C3B3B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: b * 138,
                                        height: h * 56,
                                        decoration: BoxDecoration(
                                          color: !round
                                              ? Color(0xfff9f9f9)
                                              : primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              RoundTripLabel,
                                              style: TextStyle(
                                                fontSize: b * 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff3C3B3B),
                                              ),
                                            ),
                                            sh(4),
                                            FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                KeepCarLabel,
                                                style: TextStyle(
                                                  fontSize: b * 12,
                                                  color: Color(0xff3C3B3B),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : sh(0),
                            sh(res.bookingType != 'Local' ? 21 : 0),
                            Text(
                              round ? ReturnDateLabel : WhenLabel,
                              style: TextStyle(
                                fontSize: b * 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff3c3b3b),
                              ),
                            ),
                            sh(11),
                            !round
                                ? Row(children: [
                                    SvgPicture.asset(
                                      "assets/icons/calendar.svg",
                                      width: b * 11,
                                      color: Colors.black,
                                    ),
                                    sb(8),
                                    Text(
                                      res.pickupDatetime!.substring(0, 10),
                                      style: TextStyle(
                                        fontSize: b * 12,
                                        color: Color(0xff3F3D56),
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    sb(20),
                                    SvgPicture.asset(
                                      "assets/icons/clock.svg",
                                      width: b * 14,
                                      color: Colors.black,
                                    ),
                                    sb(4),
                                    Text(
                                      timeFormat(TimeOfDay.fromDateTime(
                                          DateTime.parse(res.pickupDatetime!))),
                                      style: TextStyle(
                                        fontSize: b * 12,
                                        letterSpacing: 0.6,
                                        color: Color(0xff3F3D56),
                                      ),
                                    ),
                                  ])
                                : Column(
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
                                            res.pickupDatetime!
                                                .substring(0, 10),
                                            style: TextStyle(
                                              fontSize: b * 12,
                                              letterSpacing: 0.6,
                                              color: Color(0xff3F3D56),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            ToLabel,
                                            style: TextStyle(
                                              fontSize: b * 12,
                                              letterSpacing: 0.6,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            "assets/icons/calendar.svg",
                                            width: b * 10,
                                            color: Colors.black,
                                          ),
                                          sb(8),
                                          Text(
                                            res.dropDatetime!.substring(0, 10),
                                            style: TextStyle(
                                              fontSize: b * 12,
                                              letterSpacing: 0.6,
                                              color: Color(0xff3F3D56),
                                            ),
                                          ),
                                        ],
                                      ),
                                      sh(10),
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
                                                DateTime.parse(
                                                    res.pickupDatetime!))),
                                            style: TextStyle(
                                              fontSize: b * 12,
                                              letterSpacing: 0.6,
                                              color: Color(0xff3F3D56),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            ToLabel,
                                            style: TextStyle(
                                              fontSize: b * 12,
                                              letterSpacing: 0.6,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            "assets/icons/clock.svg",
                                            width: b * 14,
                                            color: Colors.black,
                                          ),
                                          sb(8),
                                          Text(
                                            timeFormat(TimeOfDay.fromDateTime(
                                                DateTime.parse(
                                                    res.dropDatetime!))),
                                            style: TextStyle(
                                              fontSize: b * 12,
                                              letterSpacing: 0.6,
                                              color: Color(0xff3F3D56),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      sh(20),
                      Text(
                        SelectedCabLabel,
                        style: TextStyle(
                          fontSize: b * 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(14),
                      SelectedVehicle(
                        selected: true,
                        data: res.fleetAssigned,
                      ),
                      DriverCard(
                        h: h,
                        b: b,
                        res: res,
                        isLocal: res.bookingType == 'Local' ? true : false,
                      ),
                      sh(15),
                      FareDetails(),
                      res.bookingStatus == CancelledLabel
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sh(12),
                                Container(
                                  color: primaryColor,
                                  height: h * 1.5,
                                  width: SizeConfig.screenWidth,
                                ),
                                sh(12),
                                Text(
                                  CancelReason,
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
                                      horizontal: b * 16, vertical: h * 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF6F6F6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    res.cancellationReason!,
                                    style: TextStyle(
                                      fontSize: b * 12,
                                      color: Colors.black.withOpacity(0.5),
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : sh(0),
                      sh(30),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectedVehicle extends StatelessWidget {
  const SelectedVehicle({Key? key, required this.selected, this.data})
      : super(key: key);
  final bool selected;
  final FleetAssigned? data;

  @override
  Widget build(BuildContext context) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: b * 16, vertical: h * 16),
      decoration: BoxDecoration(
          border: Border.all(
            color: selected ? primaryColor : Colors.transparent,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Color(0xff000000).withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ]),
      margin: EdgeInsets.only(bottom: h * 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data != null
              ? Image.network(
                  data!.vehiclePhotos!.first.imageUrl!,
                  height: h * 40,
                  width: b * 59,
                )
              : Image.asset(
                  'assets/images/car_placeholder.png',
                  height: h * 40,
                  width: b * 59,
                ),
          sb(13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data?.brandName ?? 'Sedan',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: b * 14,
                  ),
                ),
                sh(4),
                Wrap(
                  runSpacing: h * 5,
                  children: [
                    VehicleTags(
                      txt:
                          (data?.seatingCapacity.toString() ?? "2") + " seater",
                      size: b * 8,
                    ),
                    sb(6),
                    VehicleTags(
                      txt: data?.fuelType ?? "Petrol",
                      size: b * 8,
                    ),
                    sb(6),
                    VehicleTags(
                      txt: data?.transmissionType ?? ManualLabel,
                      size: b * 8,
                    ),
                    sb(6),
                    VehicleTags(
                      txt: "Air Bags",
                      size: b * 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '\u20b9 250',
            style: TextStyle(
              fontSize: b * 18,
              color: secondaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
