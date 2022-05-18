import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/models/taxi/allTaxi.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/screens/taxi/checkout_outstation.dart';
import 'package:thrifty_cab/services.dart/taxiSerivces.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgetsTaxi/addressCard.dart';
import 'package:thrifty_cab/widgetsTaxi/vehicleCardTaxi.dart';

class ChooseCarOutstation extends StatefulWidget {
  const ChooseCarOutstation({Key? key}) : super(key: key);

  @override
  _ChooseCarOutstationState createState() => _ChooseCarOutstationState();
}

class _ChooseCarOutstationState extends State<ChooseCarOutstation> {
  TextEditingController promoController = TextEditingController();
  bool isCash = false;
  bool round = false;
  OutStationData data = OutStationData();
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
                AddressCard(
                  b: b,
                  h: h,
                  pickUp: appProvider.currentAdd!,
                  destination: appProvider.destAdd!,
                ),
                sh(16),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.fromLTRB(b * 17, h * 20, b * 17, h * 20),
                  decoration: allBoxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                round = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: h * 56,
                              width: b * 138,
                              decoration: BoxDecoration(
                                color:
                                    !round ? primaryColor : Color(0xfff9f9f9),
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
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                round = true;
                              });
                            },
                            child: Container(
                              width: b * 138,
                              height: h * 56,
                              decoration: BoxDecoration(
                                color:
                                    !round ? Color(0xfff9f9f9) : primaryColor,
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
                      sh(14),
                      Text(
                        DateLabel,
                        style: TextStyle(
                          fontSize: b * 12,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(6),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (round) {
                                  final picked = await showDateRangePicker(
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.dark().copyWith(
                                          primaryColor: Colors.black,
                                          colorScheme: ColorScheme.dark(
                                            primary: primaryColor,
                                            surface: secondaryColor,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDateRange: DateTimeRange(
                                      start: startDate.compareTo(
                                                  DateTime.now().toString()) <
                                              0
                                          ? DateTime.now()
                                          : DateTime.parse(startDate),
                                      end: endDate.compareTo(
                                                  DateTime.now().toString()) <
                                              0
                                          ? DateTime.now()
                                              .add(Duration(days: 11))
                                          : DateTime.parse(endDate),
                                    ),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 730)),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      startDate = picked.start
                                          .toString()
                                          .substring(0, 10);
                                      endDate = picked.end
                                          .toString()
                                          .substring(0, 10);
                                    });
                                  }
                                } else {
                                  _selectDate(context);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: h * 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(b * 4),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  round
                                      ? dateFormatString(startDate)
                                      : dateFormatString(selectedDate
                                          .toString()
                                          .substring(0, 10)),
                                  style: TextStyle(
                                    fontSize: b * 10,
                                    letterSpacing: 0.6,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          sb(23),
                          round
                              ? Icon(Icons.arrow_forward, size: b * 16)
                              : sb(0),
                          sb(23),
                          Expanded(
                            child: round
                                ? InkWell(
                                    onTap: () async {
                                      final picked = await showDateRangePicker(
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Theme(
                                            data: ThemeData.dark().copyWith(
                                              primaryColor: Colors.black,
                                              colorScheme: ColorScheme.dark(
                                                primary: primaryColor,
                                                surface: secondaryColor,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                        context: context,
                                        initialDateRange: DateTimeRange(
                                          start: startDate.compareTo(
                                                      DateTime.now()
                                                          .toString()) <
                                                  0
                                              ? DateTime.now()
                                              : DateTime.parse(startDate),
                                          end: endDate.compareTo(DateTime.now()
                                                      .toString()) <
                                                  0
                                              ? DateTime.now()
                                                  .add(Duration(days: 11))
                                              : DateTime.parse(endDate),
                                        ),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 730)),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          startDate = picked.start
                                              .toString()
                                              .substring(0, 10);
                                          endDate = picked.end
                                              .toString()
                                              .substring(0, 10);
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: h * 12),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(b * 4),
                                        border: Border.all(color: borderColor),
                                      ),
                                      child: Text(
                                        dateFormatString(endDate),
                                        style: TextStyle(
                                          fontSize: b * 10,
                                          letterSpacing: 0.6,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  )
                                : sb(0),
                          ),
                        ],
                      ),
                      sh(14),
                      Text(
                        "$TimeLabel(IST)",
                        style: TextStyle(
                          fontSize: b * 12,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(6),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                selectTime(context, true);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: h * 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(b * 4),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  startTime != null
                                      ? timeFormat(startTime!)
                                      : StartTimeLabel,
                                  style: TextStyle(
                                    fontSize: b * 10,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          sb(23),
                          round
                              ? Icon(Icons.arrow_forward, size: b * 16)
                              : sb(0),
                          sb(23),
                          Expanded(
                            child: round
                                ? InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      selectTime(context, false);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: h * 12),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(b * 4),
                                        border: Border.all(color: borderColor),
                                      ),
                                      child: Text(
                                        endTime != null
                                            ? timeFormat(endTime!)
                                            : EndTimeLabel,
                                        style: TextStyle(
                                          fontSize: b * 10,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  )
                                : sb(0),
                          ),
                        ],
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
                          physics: BouncingScrollPhysics(),
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
                sh(15),
                AppButton(
                  label: BookRideLabel.toUpperCase(),
                  onPressed: () {
                    data.pickup = appProvider.currentAdd!;
                    data.destination = appProvider.destAdd!;
                    data.dropDate = dateFormatString(endDate);
                    data.pickUpDate = round
                        ? dateFormatString(startDate)
                        : dateFormatString(
                            selectedDate.toString().substring(0, 10));
                    data.pickUpTime =
                        timeFormat(startTime ?? TimeOfDay(hour: 0, minute: 0));
                    data.dropTime =
                        timeFormat(endTime ?? TimeOfDay(hour: 0, minute: 0));
                    data.oneWay = !round;
                    if (startTime == null) {
                      appSnackBar(
                          context: context,
                          msg: SelectTimeToLabel,
                          isError: true);
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => CheckoutOutstation(
                            pickup: appProvider.currentAdd!,
                            destination: appProvider.destAdd!,
                            data: data,
                            selectedTaxi: selectedIndex,
                          ),
                        ),
                      );
                    }
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

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.black,
            colorScheme: ColorScheme.dark(
              primary: primaryColor,
              surface: secondaryColor,
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 730)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  String startDateFormatted = '';
  String endDateFormatted = '';
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String startDate = DateTime.now().toString().substring(0, 10);
  String endDate =
      DateTime.now().add(Duration(days: 1)).toString().substring(0, 10);

  Future<void> selectTime(BuildContext context, bool isStart) async {
    TimeOfDay tempTime;
    if (startTime != null && endTime != null) {
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

class OutStationData {
  String? pickup;
  String? destination;
  String? pickUpDate;
  String? pickUpTime;
  String? dropDate;
  String? dropTime;
  bool? oneWay;

  OutStationData(
      {this.pickup,
      this.destination,
      this.pickUpDate,
      this.pickUpTime,
      this.dropDate,
      this.dropTime,
      this.oneWay});
}
