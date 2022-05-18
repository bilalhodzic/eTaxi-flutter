import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({Key? key}) : super(key: key);

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  late double h, b;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    h = SizeConfig.screenHeight / 812;
    b = SizeConfig.screenWidth / 375;

    final appProvider = Provider.of<AppFlowProvider>(context);
    bool isMap = appProvider.isMap;
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              appProvider.changeBookingStage(BookingStage.PickUp);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: h * 22,
                horizontal: b * 20,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: b * 18,
              ),
            ),
          ),
          title: Text(
            DestinationLabel,
            style: TextStyle(
              fontSize: b * 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: buttonGradient,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: b * 15,
                      vertical: h * 15,
                    ),
                    padding:
                        EdgeInsets.fromLTRB(b * 17, h * 20, b * 17, h * 20),
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
                                    appProvider.currentAdd ?? PickUpAddrLbl,
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
                          children: [
                            SvgPicture.asset(
                              'assets/icons/choose_city.svg',
                              color: Color(0xffD40511),
                              height: h * 20,
                            ),
                            sb(19),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appProvider.destAdd ?? "Enter Destination",
                                    style: TextStyle(
                                      fontSize: b * 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  sh(25),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: h * 20,
                    horizontal: b * 30,
                  ),
                  child: AppButton(
                    label: isMap ? ConfirmLocationLabel : LocateOnMapLabel,
                    onPressed: () {
                      if (isMap) {
                        if (appProvider.taxiMode == TaxiMode.OutStation) {
                          appProvider.changeBookingStage(
                              BookingStage.VehicleOutstation);
                        } else {
                          appProvider.changeBookingStage(BookingStage.Vehicle);
                        }
                      } else {
                        appProvider.changeMapStatus(true);
                      }
                    },
                    isShadow: false,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
