import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/models/taxi/allTaxi.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/services.dart/taxiSerivces.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgetsTaxi/paymentSection.dart';
import 'package:thrifty_cab/widgetsTaxi/vehicleCardTaxi.dart';

class ChooseCar extends StatefulWidget {
  const ChooseCar({Key? key}) : super(key: key);

  @override
  _ChooseCarState createState() => _ChooseCarState();
}

class _ChooseCarState extends State<ChooseCar> {
  TextEditingController promoController = TextEditingController();
  bool isCash = false;
  int selectedIndex = 0;
  List prices = ['272', '348', '499'];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    final appProvider = Provider.of<AppFlowProvider>(context);

    return DraggableScrollableSheet(
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: b * 15),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                sh(16),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.fromLTRB(b * 17, h * 20, b * 17, h * 20),
                  decoration: allBoxDecoration,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
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
                                        appProvider.currentAdd ??
                                            "4517 Washinton Ave Manchester, Kentucky 39495",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appProvider.destAdd ??
                                            "3891 Ranchview Dr. Richardson, California 62639",
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
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                selectTime(context, true);
                              },
                              child: Container(
                                height: h * 54,
                                padding:
                                    EdgeInsets.symmetric(horizontal: b * 7.5),
                                decoration: allBoxDecoration,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/clock.svg',
                                      width: b * 17,
                                    ),
                                    Text(
                                      startTime != null
                                          ? timeFormat(startTime!)
                                          : NowLabel,
                                      style: TextStyle(
                                        fontSize: b * 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                sh(24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: b * 19),
                  child: Text(
                    ChooseCabLabel,
                    style: TextStyle(
                      fontSize: b * 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff3c3b3b),
                    ),
                  ),
                ),
                sh(10),
                FutureBuilder(
                    future: Services.getTaxiAvailable(),
                    builder: (context, AsyncSnapshot<AllTaxi?> snap) {
                      if (snap.hasData) {
                        AllTaxi? data = snap.data;
                        return ListView.builder(
                          padding: EdgeInsets.only(top: h * 10),
                          shrinkWrap: true,
                          itemCount: data!.body!.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: VehicleCard(
                                selected: selectedIndex == index ? true : false,
                                data: data.body!.elementAt(index),
                                price: prices[index],
                              ),
                            );
                          },
                        );
                      } else
                        return sh(0);
                    }),
                sh(27),
                DiscountSection(b: b, promoController: promoController, h: h),
                sh(24),
                PaymentMethod(),
                sh(28),
                AppButton(
                  label: BookRideLabel.toUpperCase(),
                  onPressed: () {
                    appProvider
                        .changeBookingStage(BookingStage.SearchingVehicle);
                  },
                ),
                sh(28)
              ],
            ),
          ),
        );
      },
    );
  }

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> selectTime(BuildContext context, bool isStart) async {
    TimeOfDay tempTime;
    if (startTime != null || endTime != null) {
      tempTime = isStart ? startTime! : endTime!;
    } else {
      tempTime = TimeOfDay.now();
    }

    // ignore: non_constant_identifier_names
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: tempTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              surface: Colors.white,
              secondary: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      if (picked_s != null) {
        if (isStart)
          startTime = picked_s;
        else
          endTime = picked_s;
      }
    });
  }
}
