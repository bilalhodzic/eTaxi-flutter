import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thrifty_cab/models/directions_model.dart';
import 'package:thrifty_cab/screens/taxi/home_taxi.dart';

enum BookingStage {
  PickUp,
  Destination,
  Vehicle,
  SearchingVehicle,
  Booked,
  VehicleOutstation,
}
enum TaxiMode { Local, OutStation }

class AppFlowProvider extends ChangeNotifier {
  BookingStage _stage = BookingStage.PickUp;
  BookingStage get stage => _stage;

  TaxiMode _taxiMode = TaxiMode.Local;
  TaxiMode get taxiMode => _taxiMode;

  LatLng? _currentLoc;
  LatLng? get currentLoc => _currentLoc;

  String? _currentAdd;
  String? get currentAdd => _currentAdd;

  LatLng? _destLoc;
  LatLng? get destLoc => _destLoc;

  String? _destAdd;
  String? get destAdd => _destAdd;

  Directions? _directions;
  Directions? get directions => _directions;

  bool _isMap = true;
  bool get isMap => _isMap;

  changeBookingStage(BookingStage currentStage) {
    _stage = currentStage;
    notifyListeners();
  }

  changeMapStatus(bool status) {
    _isMap = status;
    notifyListeners();
  }

  changeTaxiMode(TaxiMode mode) {
    _taxiMode = mode;
    notifyListeners();
  }

  Future setCurrentLoc(LatLng loc, String add) async {
    _currentLoc = loc;
    _currentAdd = add;
    await mapController!.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: loc, zoom: 15)));
    notifyListeners();
  }

  Future setDestinationLoc(LatLng loc, String add) async {
    _destLoc = loc;
    _destAdd = add;
    await mapController!.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: loc, zoom: 15)));
    notifyListeners();
  }

  Future setDirections(Directions dir) async {
    _directions = dir;
    await mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(directions!.bounds!, 100),
    );
    notifyListeners();
  }
}
