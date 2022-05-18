import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thrifty_cab_driver/models/newRide.dart';
import 'package:thrifty_cab_driver/services/services.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/widgets/app_button.dart';
import 'package:thrifty_cab_driver/widgets/app_snackBar.dart';

class DialogBoxAccept extends StatefulWidget {
  @override
  _DialogBoxAcceptState createState() => _DialogBoxAcceptState();
}

class _DialogBoxAcceptState extends State<DialogBoxAccept> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: b * 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(b * 20, h * 13, b * 20, h * 20),
            child: FutureBuilder(
                future: Services.getNewRide(),
                builder: (context, AsyncSnapshot<NewRide?> snap) {
                  if (snap.hasData) {
                    NewRide? data = snap.data;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedImage(b: b, h: h),
                              sb(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data!.customerName!,
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
                            ],
                          ),
                          sh(12),
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
                                            data.pickupDatetime!
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
                                            data.totalKmJourney.toString() +
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
                                            timeFormat(TimeOfDay.fromDateTime(
                                                DateTime.parse(
                                                    data.pickupDatetime!))),
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
                          Column(
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
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "TOTAL FARE",
                                          style: TextStyle(
                                            fontSize: b * 10,
                                            letterSpacing: 0.6,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
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
                              sh(0),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/choose_city.svg',
                                    color: Colors.red,
                                    height: h * 20,
                                  ),
                                  sb(19),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: b * 9,
                                            vertical: h * 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                          child: Text(
                                            data.fareApplied! + " Fare",
                                            style: TextStyle(
                                              fontSize: b * 12,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          sh(37),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: h * 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.circular(b * 5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "REJECT",
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
                                child: isPressed
                                    ? LoadingButton()
                                    : AppButton(
                                        vertPad: h * 10,
                                        label: "ACCEPT",
                                        onPressed: () {
                                          setState(() {
                                            isPressed = true;
                                          });
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            Navigator.of(context).pop();
                                            appSnackBar(
                                              context: context,
                                              msg:
                                                  "The ride is successfully accepted, please proceed to start",
                                              isError: false,
                                            );
                                          });
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ]);
                  } else
                    return sh(0);
                }),
          ),
        ],
      ),
    );
  }
}

void dialogBoxAccept(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return DialogBoxAccept();
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 300),
  );
}
