import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thrifty_cab/models/directions_model.dart';
import 'package:thrifty_cab/utils/api_keys.dart';
import 'package:http/http.dart' as http;

class DirectionServices {
  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng dest,
  }) async {
    Uri link = Uri(
        scheme: "https",
        host: 'maps.googleapis.com',
        path: 'maps/api/directions/json',
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${dest.latitude},${dest.longitude}',
          'key': GoogleMapApiKey,
        });

    print(link);
    final res = await http.Client().get(link).timeout(Duration(seconds: 15));
    print(res.body);
    if (res.statusCode == 200) {
      return Directions.fromMap(jsonDecode(res.body));
    }
    return null;
  }
}
