import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgetsTaxi/driverCard.dart';
import 'package:thrifty_cab/widgetsTaxi/fareDetails.dart';

class DriverAssign extends StatefulWidget {
  const DriverAssign({Key? key}) : super(key: key);

  @override
  _DriverAssignState createState() => _DriverAssignState();
}

class _DriverAssignState extends State<DriverAssign> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppFlowProvider>(context);

    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      builder: (context, controller) {
        return SingleChildScrollView(
          controller: controller,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: b * 15),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh(11),
                DriverCard(
                  h: h,
                  b: b,
                  isLocal: true,
                ),
                sh(7),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.fromLTRB(b * 17, h * 20, b * 17, h * 20),
                  decoration: allBoxDecoration,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appProvider.currentAdd!,
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
                            sh(5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/choose_city.svg',
                                  color: Color(0xffD40511),
                                  height: h * 20,
                                ),
                                sb(19),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appProvider.destAdd!,
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
                      sb(5),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Container(
                              height: h * 47,
                              padding: EdgeInsets.symmetric(horizontal: b * 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff0000000).withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/clock.svg',
                                    width: b * 17,
                                  ),
                                  Text(
                                    NowLabel,
                                    style: TextStyle(
                                      fontSize: b * 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                sh(14),
                FareDetails(),
                AppButton(
                  label: BookAnotherLabel,
                  onPressed: () {
                    appProvider.changeBookingStage(BookingStage.PickUp);
                    appProvider.setDestinationLoc(LatLng(0, 0), '');
                  },
                ),
                sh(10),
              ],
            ),
          ),
        );
      },
    );
  }
}
