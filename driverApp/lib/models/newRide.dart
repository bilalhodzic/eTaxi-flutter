class NewRide {
  String? id;
  String? customerId;
  String? customerName;
  String? when;
  String? bookingTime;
  PickupCoordinates? pickupCoordinates;
  String? pickupAddress;
  String? pickupDatetime;
  String? dropAddress;
  PickupCoordinates? dropCoordinates;
  String? dropDatetime;
  double? totalKmJourney;
  String? fareApplied;
  double? excessKm;
  int? standardFarePerKm;
  int? baseFare;
  int? additonalFare;
  int? subTotalFare;
  double? totalDiscount;
  int? totalFare;
  String? paymentMode;
  String? bookingStatus;
  String? createdAt;
  String? updatedAt;

  NewRide(
      {this.id,
      this.customerId,
      this.customerName,
      this.when,
      this.bookingTime,
      this.pickupCoordinates,
      this.pickupAddress,
      this.pickupDatetime,
      this.dropAddress,
      this.dropCoordinates,
      this.dropDatetime,
      this.totalKmJourney,
      this.fareApplied,
      this.excessKm,
      this.standardFarePerKm,
      this.baseFare,
      this.additonalFare,
      this.subTotalFare,
      this.totalDiscount,
      this.totalFare,
      this.paymentMode,
      this.bookingStatus,
      this.createdAt,
      this.updatedAt});

  NewRide.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    when = json['when'];
    bookingTime = json['bookingTime'];
    pickupCoordinates = json['pickupCoordinates'] != null
        ? new PickupCoordinates.fromJson(json['pickupCoordinates'])
        : null;
    pickupAddress = json['pickupAddress'];
    pickupDatetime = json['pickupDatetime'];
    dropAddress = json['dropAddress'];
    dropCoordinates = json['dropCoordinates'] != null
        ? new PickupCoordinates.fromJson(json['dropCoordinates'])
        : null;
    dropDatetime = json['dropDatetime'];
    totalKmJourney = json['totalKmJourney'];
    fareApplied = json['fareApplied'];
    excessKm = json['excessKm'];
    standardFarePerKm = json['standardFarePerKm'];
    baseFare = json['baseFare'];
    additonalFare = json['additonalFare'];
    subTotalFare = json['subTotalFare'];
    totalDiscount = json['totalDiscount'];
    totalFare = json['totalFare'];
    paymentMode = json['paymentMode'];
    bookingStatus = json['bookingStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['when'] = this.when;
    data['bookingTime'] = this.bookingTime;
    if (this.pickupCoordinates != null) {
      data['pickupCoordinates'] = this.pickupCoordinates!.toJson();
    }
    data['pickupAddress'] = this.pickupAddress;
    data['pickupDatetime'] = this.pickupDatetime;
    data['dropAddress'] = this.dropAddress;
    if (this.dropCoordinates != null) {
      data['dropCoordinates'] = this.dropCoordinates!.toJson();
    }
    data['dropDatetime'] = this.dropDatetime;
    data['totalKmJourney'] = this.totalKmJourney;
    data['fareApplied'] = this.fareApplied;
    data['excessKm'] = this.excessKm;
    data['standardFarePerKm'] = this.standardFarePerKm;
    data['baseFare'] = this.baseFare;
    data['additonalFare'] = this.additonalFare;
    data['subTotalFare'] = this.subTotalFare;
    data['totalDiscount'] = this.totalDiscount;
    data['totalFare'] = this.totalFare;
    data['paymentMode'] = this.paymentMode;
    data['bookingStatus'] = this.bookingStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class PickupCoordinates {
  String? latitude;
  String? longitude;

  PickupCoordinates({this.latitude, this.longitude});

  PickupCoordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}