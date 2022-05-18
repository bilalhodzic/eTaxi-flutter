import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thrifty_cab/models/taxi/allTaxi.dart';
import 'package:thrifty_cab/screens/staticPages/congo_page.dart';
import 'package:thrifty_cab/screens/taxi/choose_vehicle_outstation.dart';
import 'package:thrifty_cab/services.dart/taxiSerivces.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgetsTaxi/addressCard.dart';
import 'package:thrifty_cab/widgetsTaxi/fareDetails.dart';
import 'package:thrifty_cab/widgetsTaxi/paymentSection.dart';
import 'package:thrifty_cab/widgetsTaxi/vehicleCardTaxi.dart';

class CheckoutOutstation extends StatefulWidget {
  final String pickup;
  final String destination;
  final OutStationData data;
  final int selectedTaxi;

  const CheckoutOutstation(
      {Key? key,
      required this.pickup,
      required this.destination,
      required this.data,
      required this.selectedTaxi})
      : super(key: key);
  @override
  _CheckoutOutstationState createState() => _CheckoutOutstationState();
}

class _CheckoutOutstationState extends State<CheckoutOutstation> {
  bool round = false;
  TextEditingController promoController = TextEditingController();
  @override
  void initState() {
    round = !(widget.data.oneWay!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            AppBarText(
              txt: CheckoutLabel,
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
                        pickUp: widget.pickup,
                        destination: widget.destination,
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
                            Row(
                              children: [
                                Container(
                                  width: b * 138,
                                  height: h * 56,
                                  decoration: BoxDecoration(
                                    color: !round
                                        ? primaryColor
                                        : Color(0xfff9f9f9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      Text(
                                        KeepCarLabel,
                                        style: TextStyle(
                                          fontSize: b * 12,
                                          color: Color(0xff3C3B3B),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            sh(21),
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
                                      widget.data.pickUpDate!,
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
                                    sb(8),
                                    Text(
                                      widget.data.pickUpTime!,
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
                                            widget.data.pickUpDate!,
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
                                            widget.data.dropDate!,
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
                                            widget.data.pickUpTime!,
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
                                            widget.data.dropTime!,
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
                      FutureBuilder(
                          future: Services.getTaxiAvailable(),
                          builder: (context, AsyncSnapshot<AllTaxi?> snap) {
                            if (snap.hasData) {
                              AllTaxi? data = snap.data;
                              return ListView.builder(
                                padding: EdgeInsets.only(top: h * 10),
                                shrinkWrap: true,
                                itemCount: 1,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return VehicleCard(
                                    selected: true,
                                    data: data!.body!
                                        .elementAt(widget.selectedTaxi),
                                  );
                                },
                              );
                            } else
                              return sh(0);
                          }),
                      sh(11),
                      DiscountSection(
                        b: b,
                        promoController: promoController,
                        h: h,
                      ),
                      sh(24),
                      PaymentMethod(),
                      sh(24),
                      FareDetails(),
                      AppButton(
                        label: BookRideLabel.toUpperCase(),
                        onPressed: () {
                          AudioCache player = AudioCache();
                          player.play('sounds/booking_success.mp3');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CongoPage(
                                isUpdate: false,
                                istaxi: true,
                              ),
                            ),
                          );
                        },
                      ),
                      sh(28)
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
