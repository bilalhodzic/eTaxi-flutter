import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thrifty_cab/models/directions_model.dart';
import 'package:thrifty_cab/utils/api_keys.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/strings.dart';

class TrackCarMapScreen extends StatefulWidget {
  final String? trackingID;
  final String? pickUpAddr;
  final String? dropOffAddr;
  TrackCarMapScreen({
    Key? key,
    this.trackingID,
    this.pickUpAddr,
    this.dropOffAddr,
  }) : super(key: key);

  @override
  _TrackCarMapScreenState createState() => _TrackCarMapScreenState();
}

class _TrackCarMapScreenState extends State<TrackCarMapScreen> {
  GoogleMapController? mapController;
  Directions? directions;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 14,
  );

  // getLocCoordinate() async {
  //   await getVehicleLocation();
  //   timer = Timer.periodic(Duration(seconds: 15), (val) {
  //     getVehicleLocation();
  //   });
  //   try {
  //     final pickCoordinates = {'latitude': 27.0, 'longitude': 70.0};

  //     final dropCoordinates = {'latitude': 28.0, 'longitude': 70.0};

  //     pickMarker = Marker(
  //       markerId: MarkerId("PickUp"),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(
  //         BitmapDescriptor.hueRed,
  //       ),
  //       infoWindow: InfoWindow(title: "Pickup Point"),
  //       position: LatLng(
  //         pickCoordinates['latitude']!,
  //         pickCoordinates['longitude']!,
  //       ),
  //     );

  //     dropMarker = Marker(
  //       markerId: MarkerId("DropOff"),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //       position:
  //           LatLng(dropCoordinates['latitude']!, dropCoordinates['longitude']!),
  //       infoWindow: InfoWindow(title: "Dropoff Point"),
  //     );

  //     directions = await DirectionServices()
  //         .getDirections(origin: LatLng(27, 77), dest: LatLng(22, 78));

  //     mapController.animateCamera(
  //       CameraUpdate.newLatLngBounds(directions!.bounds!, 100),
  //     );
  //     setState(() {});
  //   } catch (e) {
  //     print(e);
  //     appSnackBar(
  //       context: context,
  //       msg: GenericError,
  //       isError: true,
  //     );
  //   }
  // }

  // getVehicleLocation() async {
  //   print("Getting Vehicle Location");
  //   try {
  //     latLng = await Provider.of<BookingProvider>(context, listen: false)
  //         .getVehicleTrackDetails(
  //       trackID: widget.trackingID!,
  //     );

  //     carMarker = Marker(
  //         markerId: MarkerId('carLoc'),
  //         icon: await BitmapDescriptor.fromAssetImage(
  //           ImageConfiguration(
  //             size: Size(20, 20),
  //           ),
  //           'assets/icons/car.png',
  //         ),
  //         position: latLng);
  //     setState(() {});
  //   } catch (e) {
  //     appSnackBar(
  //       context: context,
  //       msg: e.toString(),
  //       isError: true,
  //     );
  //   }
  // }

  // String getBookingIdInt(String boi) {
  //   String idInInt = '';

  //   for (int i = boi.length - 1; i >= 0; i--) {
  //     if (boi[i] == '0' ||
  //         boi[i] == '1' ||
  //         boi[i] == '2' ||
  //         boi[i] == '3' ||
  //         boi[i] == '4' ||
  //         boi[i] == '5' ||
  //         boi[i] == '6' ||
  //         boi[i] == '7' ||
  //         boi[i] == '8' ||
  //         boi[i] == '9') {
  //       idInInt = idInInt + boi[i];
  //     } else
  //       break;
  //   }

  //   return idInInt.split("").reversed.join();
  // }

  Set<Marker> markers = Set();
  Map<PolylineId, Polyline> polylines = {};
  LatLng startLocation = LatLng(28.4744, 77.5040);
  LatLng endLocation = LatLng(28.6304, 77.2177);
  PolylinePoints polylinePoints = PolylinePoints();

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GoogleMapApiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: startLocation, zoom: 10)));
    });
  }

  @override
  void initState() {
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ), //Icon for Marker
    ));

    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: buttonGradient),
          child: Column(
            children: [
              AppBarText(
                txt: TrackYrCar,
                icon: 'assets/icons/loc_icon.svg',
                actionIcon: null,
                isBackButton: true,
              ),
              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  buildingsEnabled: false,
                  markers: markers,
                  polylines: Set<Polyline>.of(polylines.values),
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setState(() {
                      mapController = controller;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
