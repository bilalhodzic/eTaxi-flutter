class AllRides {
  dynamic statuscode;
  Body? body;
  String? message;

  AllRides({this.statuscode, this.body, this.message});

  AllRides.fromJson(Map<String, dynamic> json) {
    statuscode = json['statuscode'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statuscode'] = this.statuscode;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Body {
  dynamic count;
  String? next;
  String? previous;
  List<Result>? result;

  Body({this.count, this.next, this.previous, this.result});

  Body.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
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
  dynamic standardFarePerKm;
  dynamic baseFare;
  dynamic additonalFare;
  dynamic subTotalFare;
  double? totalDiscount;
  dynamic totalFare;
  String? paymentMode;
  String? bookingStatus;
  String? createdAt;
  String? updatedAt;

  Result(
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

  Result.fromJson(Map<String, dynamic> json) {
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
