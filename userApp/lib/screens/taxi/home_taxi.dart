import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/models/directions_model.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/screens/taxi/choose_vehicle.dart';
import 'package:thrifty_cab/screens/taxi/choose_vehicle_outstation.dart';
import 'package:thrifty_cab/screens/taxi/destination_location.dart';
import 'package:thrifty_cab/screens/taxi/driver_assign.dart';
import 'package:thrifty_cab/screens/taxi/pickup_location.dart';
import 'package:thrifty_cab/screens/taxi/searching_widget.dart';
import 'package:thrifty_cab/services.dart/directions_services.dart';
import 'package:thrifty_cab/utils/api_keys.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';

class HomeTaxi extends StatefulWidget {
  const HomeTaxi({Key? key}) : super(key: key);

  @override
  _HomeTaxiState createState() => _HomeTaxiState();
}

GoogleMapController? mapController;

class _HomeTaxiState extends State<HomeTaxi> {
  Completer<GoogleMapController> _controller = Completer();
  int stage = 0;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 7,
  );
  setCurrentLocMarker() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever)
      await Geolocator.requestPermission();

    final loc = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    _kGooglePlex = CameraPosition(target: LatLng(loc.latitude, loc.longitude));
  }

  @override
  void initState() {
    setCurrentLocMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    final appProvider = Provider.of<AppFlowProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (appProvider.stage == BookingStage.Destination) {
          appProvider.changeBookingStage(BookingStage.PickUp);
          return false;
        } else if (appProvider.stage == BookingStage.Vehicle ||
            appProvider.stage == BookingStage.VehicleOutstation) {
          appProvider.changeBookingStage(BookingStage.Destination);
          return false;
        } else if (appProvider.stage == BookingStage.Booked) {
          appProvider.changeBookingStage(BookingStage.PickUp);
          return false;
        } else if (appProvider.stage == BookingStage.SearchingVehicle)
          return false;
        else
          return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: SafeArea(
          top: appProvider.stage != BookingStage.PickUp,
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: !appProvider.isMap
                      ? Container(
                          color: Colors.white,
                        )
                      : GoogleMap(
                          mapType: MapType.normal,
                          compassEnabled: true,
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                          buildingsEnabled: false,
                          markers: {
                            if (appProvider.currentLoc != null)
                              Marker(
                                markerId: MarkerId(PickupLabel),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed,
                                ),
                                infoWindow: InfoWindow(title: "Pickup Point"),
                                position: LatLng(
                                  appProvider.currentLoc!.latitude,
                                  appProvider.currentLoc!.longitude,
                                ),
                              ),
                            if (appProvider.destLoc != null)
                              Marker(
                                markerId: MarkerId(DestinationLabel),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueBlue,
                                ),
                                infoWindow:
                                    InfoWindow(title: DestinationPointLabel),
                                position: LatLng(
                                  appProvider.destLoc!.latitude,
                                  appProvider.destLoc!.longitude,
                                ),
                              )
                          },
                          polylines: {
                            if (appProvider.directions != null)
                              Polyline(
                                polylineId: PolylineId('route'),
                                color: Colors.black,
                                width: 3,
                                points: appProvider.directions!.polylinePoints!
                                    .map(
                                      (e) => LatLng(e!.latitude, e.longitude),
                                    )
                                    .toList(),
                              )
                          },
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                            mapController = controller;
                          },
                        ),
                ),
                if (appProvider.stage == BookingStage.PickUp) PickUpSheet()
              ],
            ),
            if (appProvider.stage == BookingStage.Vehicle ||
                appProvider.stage == BookingStage.VehicleOutstation)
              Container(
                decoration: BoxDecoration(
                  gradient: buttonGradient,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        appProvider
                            .changeBookingStage(BookingStage.Destination);
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
                    Spacer(),
                    Text(
                      ChooseYourCar,
                      style: TextStyle(
                        fontSize: b * 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(flex: 2),
                  ],
                ),
              ),
            if (appProvider.stage == BookingStage.Destination)
              DestinationScreen(),
            if (appProvider.stage == BookingStage.Vehicle) ChooseCar(),
            if (appProvider.stage == BookingStage.VehicleOutstation)
              ChooseCarOutstation(),
            if (appProvider.stage == BookingStage.PickUp)
              TopSearchBar(h: h, b: b),
            if (appProvider.stage == BookingStage.SearchingVehicle)
              SearchingWidget(),
            if (appProvider.stage == BookingStage.Booked) DriverAssign()
          ]),
        ),
      ),
    );
  }
}

class TopSearchBar extends StatefulWidget {
  const TopSearchBar({
    Key? key,
    required this.h,
    required this.b,
  }) : super(key: key);

  final double h;
  final double b;

  @override
  State<TopSearchBar> createState() => _TopSearchBarState();
}

class _TopSearchBarState extends State<TopSearchBar> {
  setCurrentLocMarker() async {
    final loc = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    final appProvider = Provider.of<AppFlowProvider>(context, listen: false);

    await appProvider.setCurrentLoc(
        LatLng(loc.latitude, loc.longitude), CurrentLocLabel);
  }

  @override
  void initState() {
    setCurrentLocMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppFlowProvider>(context);

    return InkWell(
      onTap: () async {
        LocationResult result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlacePicker(GoogleMapApiKey),
          ),
        );
        if (result.latLng != null) {
          await appProvider.setCurrentLoc(
              result.latLng!, result.formattedAddress!);
        }
        Directions? dir = await DirectionServices()
            .getDirections(origin: result.latLng!, dest: appProvider.destLoc!);

        if (dir != null) await appProvider.setDirections(dir);
      },
      child: Container(
        margin: EdgeInsets.only(
          top: widget.h * 50,
          left: widget.b * 15,
          right: widget.b * 15,
        ),
        padding: EdgeInsets.symmetric(
          vertical: widget.h * 15,
          horizontal: widget.b * 24,
        ),
        decoration: allBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: widget.b * 18,
            ),
            sb(10),
            Expanded(
              child: Text(
                appProvider.currentAdd ?? ChooseYourLocLabel,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: widget.b * 12),
              ),
            ),
            sb(10),
            Icon(
              Icons.location_pin,
              size: widget.b * 18,
            )
          ],
        ),
      ),
    );
  }
}
