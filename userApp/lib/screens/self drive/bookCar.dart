import 'package:flutter/material.dart';
import 'package:thrifty_cab/models/booking_history_model.dart';
import 'package:thrifty_cab/models/booking_model.dart';
import 'package:thrifty_cab/models/current_loc_model.dart';
import 'package:thrifty_cab/models/vehicle_model.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thrifty_cab/models/city_model.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/providers/home_provider.dart';
import 'package:thrifty_cab/screens/staticPages/congo_page.dart';
import 'package:thrifty_cab/screens/commonPages/login.dart';
import 'package:thrifty_cab/screens/commonPages/phone_verify.dart';
import 'package:thrifty_cab/screens/commonPages/profile.dart';
import 'package:thrifty_cab/services.dart/preferences.dart';
import 'package:thrifty_cab/utils/api_keys.dart';
import 'package:thrifty_cab/utils/appBar.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';
import 'package:thrifty_cab/widgets/swipeCarContainer.dart';
import 'package:thrifty_cab/widgets/vehicle_tags.dart';
import 'package:place_picker/place_picker.dart';
import 'package:provider/provider.dart';

class BookCar extends StatefulWidget {
  final VehicleModel? vehicle;
  final bool? isUpdate;
  final bool? limited;
  final BookingHistoryModel? booking;
  BookCar(
      {Key? key,
      @required this.vehicle,
      this.isUpdate = false,
      this.booking,
      this.limited = true})
      : super(key: key);

  @override
  _BookCarState createState() => _BookCarState();
}

class _BookCarState extends State<BookCar> {
  bool limited = true;
  String startDate = DateTime.now().toString().substring(0, 10);
  String endDate =
      DateTime.now().add(Duration(days: 1)).toString().substring(0, 10);

  String startDateFormatted = '';
  String endDateFormatted = '';

  CurrentLoc? currentLoc;

  String selectedPickCity = ChoosePickCity;
  String selectedDropCity = DroptoCityLabel;
  int? selectedPickCityID;
  int? selectedDropCityID;

  bool isManualAddrPick = false, isManualAddrDrop = false;

  TextEditingController pickUpAdd = TextEditingController();
  TextEditingController dropOffAdd = TextEditingController();
  TextEditingController estKm = TextEditingController();

  LatLng? pickCoordinates, dropCoordinates;
  String? pickCityFromMap, dropCityFromMap;
  bool isPressed = false;

  Future<void>? getCities;

  @override
  void initState() {
    super.initState();

    getCities = Provider.of<HomeProvider>(context, listen: false).getCities();

    if (widget.isUpdate == false || widget.isUpdate == null)
      getExistingData();
    else {
      getDataFromBooking();
    }

    if (widget.vehicle!.isLimited != "Yes") limited = false;

    PreferencesUtils.getPref(PreferencesUtils.currentCity).then((value) {
      selectedPickCity = value!;
      setState(() {});
    });
  }

  getDataFromBooking() async {
    try {
      final res = await Provider.of<BookingProvider>(context, listen: false)
          .getBookingByID(widget.booking!.bookingId!);

      selectedDropCity = res.dropoffCity!;
      selectedPickCity = res.pickupCity!;

      pickUpAdd.text = res.pickupAddr!;
      dropOffAdd.text = res.destAddr!;

      startDate = res.pickupDatetime!.split(' ').first;
      endDate = res.dropoffDatetime!.split(' ').first;

      startTime = TimeOfDay.fromDateTime(DateTime.parse(res.pickupDatetime!));
      endTime = TimeOfDay.fromDateTime(DateTime.parse(res.dropoffDatetime!));
      limited = res.billingType == 'Limited' ? true : false;
      isManualAddrDrop = false;
      isManualAddrPick = false;

      setState(() {});

      getCities!.then((value) {
        final cities = Provider.of<HomeProvider>(context, listen: false).cities;
        selectedPickCityID = cities
            .where((ele) {
              return ele.name == selectedPickCity ? true : false;
            })
            .first
            .id;
        selectedDropCityID = cities
            .where((ele) {
              return ele.name == selectedDropCity ? true : false;
            })
            .first
            .id;
      });
    } catch (e) {
      print(e);
      appSnackBar(
        context: context,
        msg: GenericError,
        isError: true,
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> getExistingData() async {
    try {
      currentLoc = await PreferencesUtils.getLoc();
      selectedDropCity = currentLoc!.dropCity!;
      selectedDropCityID = int.parse(currentLoc!.dropCityID!);
      selectedPickCity = currentLoc!.pickCity!;
      selectedPickCityID = int.parse(currentLoc!.pickCityID!);

      pickUpAdd.text = currentLoc!.pickCityAddr!;
      dropOffAdd.text = currentLoc!.dropCityAddr!;

      pickCoordinates = currentLoc!.pickCoordinates;
      dropCoordinates = currentLoc!.dropCoordinates;

      startDate = currentLoc!.pickTime!.toString().substring(0, 10);
      endDate = currentLoc!.dropTime!.toString().substring(0, 10);

      startTime = TimeOfDay.fromDateTime(currentLoc!.pickTime!);
      endTime = TimeOfDay.fromDateTime(currentLoc!.dropTime!);

      isManualAddrDrop = false;
      isManualAddrPick = false;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  continueBooking() async {
    if (limited) {
      if (selectedDropCity == DroptoCityLabel ||
          startTime == null ||
          endTime == null ||
          pickUpAdd.text == '' ||
          dropOffAdd.text == '' ||
          estKm.text == '') {
        appSnackBar(
          context: context,
          msg: EstKmErrorLabel,
          isError: true,
        );

        return null;
      } else {
        if (selectedDropCity == DroptoCityLabel ||
            startTime == null ||
            endTime == null ||
            pickUpAdd.text == '' ||
            dropOffAdd.text == '') {
          appSnackBar(
            context: context,
            msg: FieldEmptyError,
            isError: true,
          );

          return null;
        }
      }
    }

    final apiToken = await PreferencesUtils.getPref(PreferencesUtils.apiToken);
    final isPhoneVerified =
        await PreferencesUtils.getPref(PreferencesUtils.phoneVerified);
    final isEmailVerified =
        await PreferencesUtils.getPref(PreferencesUtils.emailVerified);
    if (apiToken == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
      );
    } else if (isEmailVerified == 0) {
      appSnackBar(context: context, msg: ActivateEmailSendMsg, isError: true);
    } else if (isPhoneVerified == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VerifyPhoneScreen(isPhoneProvided: true),
        ),
      );
    } else {
      isPressed = true;
      setState(() {});
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

        final pr = Provider.of<BookingProvider>(context, listen: false);

        // ignore: unused_local_variable
        num kms = await pr.setAddressAndDistance(
          pick: pickUpAdd.text,
          drop: dropOffAdd.text,
          pickLatLng: pickCoordinates,
          dropLatLong: dropCoordinates,
        );

        Booking booking = Booking(
          pickup: startDateFormatted,
          dropOff: endDateFormatted,
          typeID: widget.vehicle!.typeId,
          vehicleID: widget.vehicle!.vehicleId,
          modelId: widget.vehicle!.modelId,
          billingType: limited ? 'Limited' : 'Unlimited',
          dropCity: selectedDropCityID,
          pickupCity: selectedPickCityID,
          totalKms: estKm.text == '' ? 0 : num.parse(estKm.text),
        );

        await pr.getFare(booking);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              isBooking: true,
              vehicle: widget.vehicle,
            ),
          ),
        );
      } catch (e) {
        appSnackBar(context: context, msg: e.toString(), isError: true);
      } finally {
        if (mounted) {
          isPressed = false;
          setState(() {});
        }
      }
    }
  }

  updateBooking() async {
    try {
      formateDateTime();
      await Provider.of<BookingProvider>(context, listen: false).updateBooking(
        bookingID: widget.booking!.bookingId!.toString(),
        pickupDateTime: startDateFormatted,
        dropoffDateTime: endDateFormatted,
        pickupCity: selectedPickCityID.toString(),
        dropoffCity: selectedDropCityID.toString(),
        pickAdd: pickUpAdd.text,
        dropAdd: dropOffAdd.text,
      );
      appSnackBar(
        context: context,
        msg: UpdateSuccessMsg,
        isError: false,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CongoPage(isUpdate: true),
        ),
      );
    } catch (e) {
      appSnackBar(
        context: context,
        msg: e.toString(),
        isError: true,
      );
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
      fontSize: b * 11,
      color: Color(0xff3C3B3B),
      fontWeight: FontWeight.w400,
      letterSpacing: 0.6,
    );

    final provider = Provider.of<HomeProvider>(context);
    return DefaultTabController(
      initialIndex: widget.limited! ? 0 : 1,
      length: 2,
      child: Scaffold(
        appBar: appBarCommon(context, h, b, ChooseYourCar),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: constBoxDecoration,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (widget.vehicle!.isLimited != 'No' &&
                                widget.vehicle!.isUnlimited != 'No')
                            ? TabBar(
                                onTap: (index) {
                                  setState(() {
                                    if (index == 0) {
                                      limited = true;
                                    } else {
                                      limited = false;
                                    }
                                  });
                                },
                                tabs: [
                                  Tab(
                                    child: Text(
                                      LimitedLabel,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.45,
                                        color: limited
                                            ? secondaryColor
                                            : Colors.black,
                                        fontSize: b * 14,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      UnLimitedLabel,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.45,
                                        color: !limited
                                            ? secondaryColor
                                            : Colors.black,
                                        fontSize: b * 14,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: b * 15, top: h * 15, bottom: h * 5),
                                child: Text(
                                  widget.vehicle!.isLimited == 'No'
                                      ? UnLimitedLabel
                                      : LimitedLabel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.45,
                                    color: secondaryColor,
                                    fontSize: b * 16,
                                  ),
                                ),
                              ),
                        sh(10),
                        SwipeCar(
                          imgUrl: widget.vehicle!.photo!,
                          vehicleId: widget.vehicle!.vehicleId!.toString(),
                        ),
                        sh(10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: b * 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.vehicle!.vehicleName!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: b * 16,
                                          ),
                                        ),
                                        sh(10),
                                        Text(
                                          limited
                                              ? widget.vehicle!.limitedPrice!
                                              : widget.vehicle!.unlimitedPrice!,
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontSize: b * 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        sh(5),
                                        Text(
                                          SelfDriveLabel,
                                          style: TextStyle(
                                            color: Color(0xff999999),
                                            fontSize: b * 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        sh(10),
                                        Wrap(
                                          runSpacing: h * 5,
                                          children: [
                                            VehicleTags(
                                              txt: widget.vehicle!.seater,
                                              size: b * 12,
                                            ),
                                            sb(6),
                                            VehicleTags(
                                              txt: widget.vehicle!.fuelType,
                                              size: b * 12,
                                            ),
                                            sb(6),
                                            VehicleTags(
                                              txt: widget.vehicle!.transmission,
                                              size: b * 12,
                                            ),
                                            widget.vehicle!.airBags == "Yes"
                                                ? sb(6)
                                                : sh(0),
                                            widget.vehicle!.airBags == "Yes"
                                                ? VehicleTags(
                                                    txt: "Air Bags",
                                                    size: b * 12,
                                                  )
                                                : sh(0),
                                            sb(6),
                                            VehicleTags(
                                              txt: widget.vehicle!.year,
                                              size: b * 12,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              sh(20),
                              Container(
                                color: Color(0xfff2f2f2),
                                width: SizeConfig.screenWidth,
                                height: h * 2,
                              ),
                              sh(10),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: b * 15, vertical: h * 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  selectedPickCity,
                                  style: TextStyle(
                                    fontSize: b * 11,
                                    letterSpacing: 0.6,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
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
                                        menuItem.addAll(
                                            provider.allHub.where((ele) {
                                          return ele.cityID ==
                                                  selectedPickCityID
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
                                          itemWidth:
                                              SizeConfig.screenWidth - b * 60,
                                          itemTextstyle: textStyle,
                                          boxTextstyle: textStyle,
                                          boxWidth:
                                              SizeConfig.screenWidth - b * 60,
                                          icon: SvgPicture.asset(
                                            'assets/icons/drop_down_icon.svg',
                                            height: h * 8,
                                          ),
                                          hint: Text(
                                            pickUpAdd.text == ''
                                                ? PickUpAddrLbl
                                                : pickUpAdd.text,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: textStyle,
                                          ),
                                          items: menuItem,
                                          value: null,
                                          onChanged: (val) {
                                            if (val == -1) {
                                              showPlacePicker(0);
                                            } else {
                                              final selectedHub =
                                                  provider.allHub.where((ele) {
                                                return ele.hubID == val
                                                    ? true
                                                    : false;
                                              }).first;
                                              pickUpAdd.text =
                                                  selectedHub.address ?? "";
                                              pickCoordinates = LatLng(
                                                  selectedHub.lat!,
                                                  selectedHub.long!);
                                              isManualAddrPick = false;
                                              setState(() {});
                                            }
                                          },
                                        );
                                      }
                                      return Container(
                                        height: h * 48,
                                        padding: edgeInsets,
                                        alignment: Alignment.centerLeft,
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
                                  border:
                                      Border.all(color: Color(0xffe5e5e5e5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FutureBuilder(
                                  future: getCities,
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.done)
                                      return DropdownBelow(
                                        boxHeight: h * 35,
                                        itemWidth:
                                            SizeConfig.screenWidth - b * 60,
                                        itemTextstyle: TextStyle(
                                          fontSize: b * 13,
                                          color: Color(0xff3C3B3B),
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.6,
                                        ),
                                        boxPadding: edgeInsets,
                                        boxTextstyle: textStyle,
                                        boxWidth: SizeConfig.screenWidth,
                                        icon: SvgPicture.asset(
                                          'assets/icons/drop_down_icon.svg',
                                          height: h * 8,
                                        ),
                                        hint: Text(
                                          selectedDropCity != DroptoCityLabel
                                              ? selectedDropCity
                                              : DroptoCityLabel,
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
                                          dropOffAdd.clear();
                                          selectedDropCityID = val!.id!;
                                          selectedDropCity = val.name!;

                                          setState(() {});
                                        },
                                      );
                                    else
                                      return Container(
                                        height: h * 35,
                                        padding: edgeInsets,
                                        alignment: Alignment.centerLeft,
                                        width: SizeConfig.screenWidth,
                                        child: Text(
                                          currentLoc != null
                                              ? selectedDropCity
                                              : DroptoCityLabel,
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
                              InkWell(
                                onTap: () {
                                  if (selectedDropCity == DroptoCityLabel) {
                                    appSnackBar(
                                      context: context,
                                      msg: "Please choose a drop off location",
                                      isError: true,
                                    );
                                  } else {}
                                },
                                child: Container(
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

                                          menuItem.addAll(
                                              provider.allHub.where((ele) {
                                            return ele.cityID ==
                                                    selectedDropCityID
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
                                            itemWidth:
                                                SizeConfig.screenWidth - b * 60,
                                            itemTextstyle: textStyle,
                                            boxTextstyle: textStyle,
                                            boxWidth:
                                                SizeConfig.screenWidth - b * 60,
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
                                                final selectedHub = provider
                                                    .allHub
                                                    .where((ele) {
                                                  return ele.hubID == val
                                                      ? true
                                                      : false;
                                                }).first;
                                                dropOffAdd.text =
                                                    selectedHub.address ?? "";
                                                dropCoordinates = LatLng(
                                                    selectedHub.lat!,
                                                    selectedHub.long!);
                                                isManualAddrDrop = false;
                                                setState(() {});
                                              }
                                            },
                                          );
                                        }
                                        return Container(
                                          height: h * 48,
                                          padding: edgeInsets,
                                          alignment: Alignment.centerLeft,
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
                              ),
                              sh(limited ? 20 : 0),
                              limited
                                  ? AppTextField(
                                      label: EstKmLabel,
                                      controller: estKm,
                                      inputType: TextInputType.number,
                                      suffix: null,
                                      vertPad: h * 10,
                                      size: b * 11,
                                      spacing: 0.6,
                                      labelSize: b * 12,
                                      isBold: true,
                                      isVisibilty: null,
                                      validator: (val) {
                                        if (estKm.text.trim() == "")
                                          return FieldEmptyError;
                                        else
                                          return null;
                                      },
                                    )
                                  : sh(0),
                              sh(20),
                              Text(
                                DateLabel,
                                style: TextStyle(
                                  fontSize: b * 13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.6,
                                  color: Color(0xff3c3b3b),
                                ),
                              ),
                              sh(10),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        final picked =
                                            await showDateRangePicker(
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
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(Duration(days: 730)),
                                          initialDateRange: DateTimeRange(
                                            start: startDate.compareTo(
                                                        DateTime.now()
                                                            .toString()) <
                                                    0
                                                ? DateTime.now()
                                                : DateTime.parse(startDate),
                                            end: endDate.compareTo(
                                                        DateTime.now()
                                                            .toString()) <
                                                    0
                                                ? DateTime.now()
                                                    .add(Duration(days: 1))
                                                : DateTime.parse(endDate),
                                          ),
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
                                          border:
                                              Border.all(color: borderColor),
                                        ),
                                        child: Text(
                                          dateFormatString(startDate),
                                          style: TextStyle(
                                            fontSize: b * 10,
                                            letterSpacing: 0.6,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  sb(23),
                                  Text(
                                    ToLabel,
                                    style: TextStyle(
                                      fontSize: b * 12,
                                      letterSpacing: 0.6,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  sb(23),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        final picked =
                                            await showDateRangePicker(
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
                                          initialDateRange: DateTimeRange(
                                            start: startDate.compareTo(
                                                        DateTime.now()
                                                            .toString()) <
                                                    0
                                                ? DateTime.now()
                                                : DateTime.parse(startDate),
                                            end: endDate.compareTo(
                                                        DateTime.now()
                                                            .toString()) <
                                                    0
                                                ? DateTime.now()
                                                    .add(Duration(days: 1))
                                                : DateTime.parse(endDate),
                                          ),
                                          context: context,
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
                                          border:
                                              Border.all(color: borderColor),
                                        ),
                                        child: Text(
                                          dateFormatString(endDate),
                                          style: TextStyle(
                                            fontSize: b * 10,
                                            letterSpacing: 0.6,
                                            color:
                                                Colors.black.withOpacity(0.8),
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
                                  letterSpacing: 0.6,
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
                                        padding: EdgeInsets.symmetric(
                                            vertical: h * 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(b * 4),
                                          border:
                                              Border.all(color: borderColor),
                                        ),
                                        child: Text(
                                          startTime != null
                                              ? timeFormat(startTime!)
                                              : StartTimeLabel,
                                          style: TextStyle(
                                            fontSize: b * 10,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  sb(23),
                                  Text(
                                    ToLabel,
                                    style: TextStyle(
                                      fontSize: b * 12,
                                      letterSpacing: 0.6,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  sb(23),
                                  Expanded(
                                    child: InkWell(
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
                                          border:
                                              Border.all(color: borderColor),
                                        ),
                                        child: Text(
                                          endTime != null
                                              ? timeFormat(endTime!)
                                              : EndTimeLabel,
                                          style: TextStyle(
                                            fontSize: b * 10,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              sh(20),
                              isPressed
                                  ? LoadingButton()
                                  : AppButton(
                                      label: widget.isUpdate == false ||
                                              widget.isUpdate == null
                                          ? ContinueLabel
                                          : UpdateLabel,
                                      width: b * 140,
                                      onPressed: () {
                                        print("object");
                                        if (widget.isUpdate == false ||
                                            widget.isUpdate == null)
                                          continueBooking();
                                        else
                                          updateBooking();
                                      },
                                    ),
                              sh(20)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> selectTime(BuildContext context, bool isStart) async {
    String startTimeOnUpdate =
        DateTime.parse(startDate).toString().split(' ').first +
            ' ' +
            startTime!.format(context);

    String endTimeOnUpdate =
        DateTime.parse(endDate).toString().split(' ').first +
            ' ' +
            endTime!.format(context);

    TimeOfDay tempTime = TimeOfDay.fromDateTime(
      isStart
          ? (widget.isUpdate!
              ? DateTime.parse(startTimeOnUpdate)
              : currentLoc!.pickTime!)
          : (widget.isUpdate!
              ? DateTime.parse(endTimeOnUpdate)
              : currentLoc!.dropTime!),
    );

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

    if (picked_s != null) {
      if (isStart)
        startTime = picked_s;
      else
        endTime = picked_s;

      setState(() {});
    }
  }
}
