import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:thrifty_cab/screens/self%20drive/homeMain.dart';
import 'package:thrifty_cab/models/city_model.dart';
import 'package:thrifty_cab/models/current_loc_model.dart';
import 'package:thrifty_cab/providers/home_provider.dart';
import 'package:thrifty_cab/services.dart/preferences.dart';
import 'package:thrifty_cab/utils/api_keys.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({Key? key}) : super(key: key);

  @override
  _SelectCityScreenState createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  String selectedPickCity = ChoosePickCity;
  String selectedDropCity = DroptoCityLabel;
  int? selectedPickCityID;
  int? selectedDropCityID;

  bool isPressed = false;
  bool isManualAddrPick = true, isManualAddrDrop = true;
  Future<void>? getCities;

  Future<void> getExistingData() async {
    try {
      CurrentLoc? currentLoc = await PreferencesUtils.getLoc();
      selectedDropCity = currentLoc!.dropCity!;
      selectedDropCityID = int.parse(currentLoc.dropCityID!);
      selectedPickCity = currentLoc.pickCity!;
      selectedPickCityID = int.parse(currentLoc.pickCityID!);

      pickUpAdd.text = currentLoc.pickCityAddr!;
      dropOffAdd.text = currentLoc.dropCityAddr!;

      pickCoordinates = currentLoc.pickCoordinates;
      dropCoordinates = currentLoc.dropCoordinates;

      startDate = currentLoc.pickTime!.toString().substring(0, 10);
      endDate = currentLoc.dropTime!.toString().substring(0, 10);

      startTime = TimeOfDay.fromDateTime(currentLoc.pickTime!);
      endTime = TimeOfDay.fromDateTime(currentLoc.dropTime!);

      isManualAddrDrop = false;
      isManualAddrPick = false;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getExistingData();
    getCities = Provider.of<HomeProvider>(context, listen: false).getCities();
  }

  TextEditingController pickUpAdd = TextEditingController();
  TextEditingController dropOffAdd = TextEditingController();

  LatLng? pickCoordinates, dropCoordinates;

  String? pickCityFromMap, dropCityFromMap;

  checkAndProceed() async {
    formateDateTime();

    try {
      CurrentLoc loc = CurrentLoc(
        pickCity: selectedPickCity,
        pickCityID: selectedPickCityID.toString(),
        pickCityAddr: pickUpAdd.text,
        pickCoordinates: pickCoordinates,
        dropCity: selectedDropCity,
        dropCityID: selectedDropCityID.toString(),
        dropCityAddr: dropOffAdd.text,
        dropCoordinates: dropCoordinates,
        pickTime: DateTime.parse(startDateFormatted),
        dropTime: DateTime.parse(endDateFormatted),
      );

      await PreferencesUtils.setLoc(locDetails: loc);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeMain(),
        ),
        (route) => false,
      );
    } catch (e) {
      appSnackBar(context: context, msg: GenericError, isError: true);
    } finally {
      if (mounted) {
        isPressed = false;
        setState(() {});
      }
    }
  }

  formateDateTime() async {
    startDateFormatted = startDate +
        " " +
        startTime!.hour.toString().padLeft(2, '0') +
        ":" +
        startTime!.minute.toString().padLeft(2, '0') +
        ":00";

    endDateFormatted = endDate +
        " " +
        endTime!.hour.toString().padLeft(2, '0') +
        ":" +
        endTime!.minute.toString().padLeft(2, '0') +
        ":00";
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    var edgeInsets = EdgeInsets.fromLTRB(
      b * 16,
      h * 0,
      b * 16,
      h * 0,
    );
    var textStyle = TextStyle(
      fontSize: b * 12,
      color: Color(0xff3C3B3B),
      fontWeight: FontWeight.w400,
      letterSpacing: 0.6,
    );

    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            AppBarText(
              txt: ChooseYourCity,
              icon: 'assets/icons/choose_city.svg',
              isBackButton: false,
              actionIcon: null,
            ),
            Expanded(
              child: Container(
                decoration: constBoxDecoration,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: b * 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sh(25),
                      Center(
                        child: Image.asset(
                          'assets/images/choose.png',
                          height: h * 154,
                          width: b * 140,
                        ),
                      ),
                      sh(23),
                      Text(
                        PlanMyTripLbl,
                        style: TextStyle(
                          fontSize: b * 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      sh(20),
                      Text(
                        PickUpCityLbl,
                        style: TextStyle(
                          fontSize: b * 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(10),
                      Container(
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FutureBuilder(
                          future: getCities,
                          builder: (context, snap) {
                            return DropdownBelow(
                              boxHeight: h * 48,
                              itemWidth: SizeConfig.screenWidth - b * 60,
                              itemTextstyle: textStyle,
                              boxPadding: edgeInsets,
                              boxTextstyle: textStyle,
                              boxWidth: SizeConfig.screenWidth - b * 60,
                              icon: SvgPicture.asset(
                                'assets/icons/drop_down_icon.svg',
                                height: h * 8,
                              ),
                              hint: Text(
                                selectedPickCity == ChoosePickCity
                                    ? PickUpCityLbl
                                    : selectedPickCity,
                                style: textStyle,
                              ),
                              value: null,
                              items: provider.cities.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e.name!),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (City? val) {
                                selectedPickCity = val!.name!.toString();
                                selectedPickCityID = val.id;
                                setState(() {
                                  pickUpAdd.clear();
                                });
                              },
                            );
                          },
                        ),
                      ),
                      sh(20),
                      Text(
                        PickUpAddrLbl,
                        style: TextStyle(
                          fontSize: b * 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(10),
                      Container(
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FutureBuilder(
                            future: getCities,
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.done) {
                                List<DropdownMenuItem> menuItem = [];
                                menuItem.add(
                                  DropdownMenuItem<int>(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.my_location,
                                          size: b * 16,
                                        ),
                                        sb(10),
                                        Text(
                                          ChooseAddressManLbl,
                                          style: textStyle,
                                        ),
                                      ],
                                    ),
                                    value: -1,
                                  ),
                                );

                                menuItem.add(
                                  hubItem(),
                                );

                                menuItem.addAll(provider.allHub.where((ele) {
                                  return ele.cityID == selectedPickCityID
                                      ? true
                                      : false;
                                }).map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e.address ?? ""),
                                    value: e.hubID,
                                  );
                                }).toList());

                                return DropdownBelow(
                                  boxHeight: h * 48,
                                  boxPadding: edgeInsets,
                                  itemWidth: SizeConfig.screenWidth - b * 60,
                                  itemTextstyle: textStyle,
                                  boxTextstyle: textStyle,
                                  boxWidth: SizeConfig.screenWidth - b * 60,
                                  icon: SvgPicture.asset(
                                    'assets/icons/drop_down_icon.svg',
                                    height: h * 8,
                                  ),
                                  hint: Text(
                                    pickUpAdd.text == ''
                                        ? PickUpAddrLbl
                                        : pickUpAdd.text,
                                    style: textStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: menuItem,
                                  value: null,
                                  onChanged: (val) {
                                    if (val == -1) {
                                      showPlacePicker(0);
                                    } else {
                                      final selectedHub =
                                          provider.allHub.where((ele) {
                                        return ele.hubID == val ? true : false;
                                      }).first;
                                      pickUpAdd.text =
                                          selectedHub.address ?? "";
                                      pickCoordinates = LatLng(
                                        selectedHub.lat!,
                                        selectedHub.long!,
                                      );
                                      isManualAddrPick = false;
                                      setState(() {});
                                    }
                                  },
                                );
                              }
                              return Container(
                                height: h * 48,
                                padding: edgeInsets,
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth,
                                child: Text(
                                  pickUpAdd.text == ''
                                      ? PickUpAddrLbl
                                      : pickUpAdd.text,
                                  style: textStyle,
                                ),
                              );
                            }),
                      ),
                      sh(20),
                      Text(
                        DroptoCityLabel,
                        style: TextStyle(
                          fontSize: b * 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(10),
                      Container(
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffe5e5e5e5)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FutureBuilder(
                          future: getCities,
                          builder: (context, snap) {
                            if (snap.connectionState == ConnectionState.done)
                              return DropdownBelow(
                                boxHeight: h * 48,
                                itemWidth: SizeConfig.screenWidth - b * 60,
                                itemTextstyle: textStyle,
                                boxPadding: edgeInsets,
                                boxTextstyle: textStyle,
                                boxWidth: SizeConfig.screenWidth - b * 60,
                                icon: SvgPicture.asset(
                                  'assets/icons/drop_down_icon.svg',
                                  height: h * 8,
                                ),
                                hint: Text(
                                  selectedDropCity == DroptoCityLabel
                                      ? DroptoCityLabel
                                      : selectedDropCity,
                                  style: textStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                value: null,
                                items: provider.cities.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e.name!),
                                    value: e,
                                  );
                                }).toList(),
                                onChanged: (City? val) {
                                  selectedDropCityID = val!.id!;
                                  selectedDropCity = val.name!;
                                  setState(() {
                                    dropOffAdd.clear();
                                  });
                                },
                              );
                            else
                              return Container(
                                height: h * 48,
                                padding: edgeInsets,
                                alignment: Alignment.centerLeft,
                                width: SizeConfig.screenWidth,
                                child: Text(
                                  selectedDropCity == DroptoCityLabel
                                      ? DroptoCityLabel
                                      : selectedDropCity,
                                  style: textStyle,
                                ),
                              );
                          },
                        ),
                      ),
                      sh(20),
                      Text(
                        DropOffAddrLbl,
                        style: TextStyle(
                          fontSize: b * 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(10),
                      Container(
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FutureBuilder(
                            future: getCities,
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.done) {
                                List<DropdownMenuItem> menuItem = [];
                                menuItem.add(
                                  DropdownMenuItem<int>(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.my_location,
                                          size: b * 16,
                                        ),
                                        sb(10),
                                        Text(
                                          ChooseAddressManLbl,
                                          style: textStyle,
                                        ),
                                      ],
                                    ),
                                    value: -1,
                                  ),
                                );

                                menuItem.add(
                                  hubItem(),
                                );

                                menuItem.addAll(provider.allHub.where((ele) {
                                  return ele.cityID == selectedDropCityID
                                      ? true
                                      : false;
                                }).map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e.address ?? ""),
                                    value: e.hubID,
                                  );
                                }).toList());

                                return DropdownBelow(
                                  boxHeight: h * 48,
                                  boxPadding: edgeInsets,
                                  itemWidth: SizeConfig.screenWidth - b * 60,
                                  itemTextstyle: textStyle,
                                  boxTextstyle: textStyle,
                                  boxWidth: SizeConfig.screenWidth - b * 60,
                                  icon: SvgPicture.asset(
                                    'assets/icons/drop_down_icon.svg',
                                    height: h * 8,
                                  ),
                                  hint: Text(
                                    dropOffAdd.text == ''
                                        ? DropOffAddrLbl
                                        : dropOffAdd.text,
                                    style: textStyle,
                                  ),
                                  items: menuItem,
                                  value: null,
                                  onChanged: (val) {
                                    if (val == -1) {
                                      showPlacePicker(1);
                                    } else {
                                      final selectedHub =
                                          provider.allHub.where((ele) {
                                        return ele.hubID == val ? true : false;
                                      }).first;
                                      dropOffAdd.text =
                                          selectedHub.address ?? "";
                                      dropCoordinates = LatLng(
                                        selectedHub.lat!,
                                        selectedHub.long!,
                                      );
                                      isManualAddrDrop = false;
                                      setState(() {});
                                    }
                                  },
                                );
                              }
                              return Container(
                                height: h * 48,
                                padding: edgeInsets,
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth,
                                child: Text(
                                  dropOffAdd.text == ''
                                      ? DropOffAddrLbl
                                      : dropOffAdd.text,
                                  style: textStyle,
                                ),
                              );
                            },
                          )),
                      sh(20),
                      Text(
                        DateLabel,
                        style: TextStyle(
                          fontSize: b * 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(10),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
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
                                        ? DateTime.now().add(Duration(days: 11))
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
                                    endDate =
                                        picked.end.toString().substring(0, 10);
                                  });
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
                                  dateFormatString(startDate),
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
                          Icon(Icons.arrow_forward, size: b * 16),
                          sb(23),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
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
                                  initialDateRange: DateTimeRange(
                                    start: startDate.compareTo(
                                                DateTime.now().toString()) <
                                            0
                                        ? DateTime.now()
                                        : DateTime.parse(startDate),
                                    end: endDate.compareTo(
                                                DateTime.now().toString()) <
                                            0
                                        ? DateTime.now().add(Duration(days: 11))
                                        : DateTime.parse(endDate),
                                  ),
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 730)),
                                );
                                if (picked != null) {
                                  setState(() {
                                    startDate = picked.start
                                        .toString()
                                        .substring(0, 10);
                                    endDate =
                                        picked.end.toString().substring(0, 10);
                                  });
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
                                  dateFormatString(endDate),
                                  style: TextStyle(
                                    fontSize: b * 10,
                                    letterSpacing: 0.6,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      sh(20),
                      Text(
                        "$TimeLabel(IST)",
                        style: TextStyle(
                          fontSize: b * 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                      sh(10),
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
                          Icon(Icons.arrow_forward, size: b * 16),
                          sb(23),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                selectTime(context, false);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: h * 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(b * 4),
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
                            ),
                          ),
                        ],
                      ),
                      sh(20),
                      AppButton(
                        label: SubmitLabel,
                        onPressed: () async {
                          if (selectedPickCity == ChoosePickCity ||
                              selectedDropCity == DroptoCityLabel ||
                              pickUpAdd.text == '' ||
                              dropOffAdd.text == '' ||
                              startTime == null ||
                              endTime == null) {
                            appSnackBar(
                              context: context,
                              msg: FillDetailsLabel,
                              isError: true,
                            );
                          } else if (startDate.compareTo(DateTime.now()
                                      .toString()
                                      .substring(0, 10)) <=
                                  0 &&
                              DateFormat.Hm()
                                      .format(DateFormat("hh:mm").parse(
                                          startTime!.hour.toString() +
                                              ":" +
                                              startTime!.minute.toString()))
                                      .compareTo(DateFormat.Hm()
                                          .format(DateTime.now())) <=
                                  0) {
                            appSnackBar(
                              context: context,
                              msg: SelectTimeLabel,
                              isError: true,
                            );
                          } else {
                            setState(() {
                              isPressed = true;
                            });

                            checkAndProceed();
                          }
                        },
                      ),
                      sh(40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPlacePicker(int type) async {
    LocationResult? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          GoogleMapApiKey,
        ),
      ),
    );

    if (result == null) return;
    if (type == 0) {
      pickCityFromMap = result.city!.name!;

      pickUpAdd.text = result.formattedAddress ?? "";
      pickCoordinates = result.latLng;
    } else {
      dropCityFromMap = result.city!.name!;
      {
        dropOffAdd.text = result.formattedAddress ?? "";
        dropCoordinates = result.latLng;
      }
    }

    setState(() {});
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
