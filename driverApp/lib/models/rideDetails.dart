class RideDetails {
  int? statuscode;
  Body? body;
  String? message;

  RideDetails({this.statuscode, this.body, this.message});

  RideDetails.fromJson(Map<String, dynamic> json) {
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
  String? cityId;
  String? cityName;
  FleetAssigned? fleetAssigned;
  String? assignedAt;
  double? totalKmJourney;
  String? fareApplied;
  int? excessKm;
  int? standardFarePerKm;
  int? baseFare;
  int? additonalFare;
  int? subTotalFare;
  int? totalDiscount;
  int? totalFare;
  String? paymentMode;
  String? paymentStatus;
  String? bookingStatus;
  String? cancellationReason;
  String? createdAt;
  String? updatedAt;

  Body(
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
      this.cityId,
      this.cityName,
      this.fleetAssigned,
      this.assignedAt,
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
      this.paymentStatus,
      this.bookingStatus,
      this.cancellationReason,
      this.createdAt,
      this.updatedAt});

  Body.fromJson(Map<String, dynamic> json) {
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
    cityId = json['cityId'];
    cityName = json['cityName'];
    fleetAssigned = json['fleetAssigned'] != null
        ? new FleetAssigned.fromJson(json['fleetAssigned'])
        : null;
    assignedAt = json['assignedAt'];
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
    paymentStatus = json['paymentStatus'];
    bookingStatus = json['bookingStatus'];
    cancellationReason = json['cancellationReason'];
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
    data['cityId'] = this.cityId;
    data['cityName'] = this.cityName;
    if (this.fleetAssigned != null) {
      data['fleetAssigned'] = this.fleetAssigned!.toJson();
    }
    data['assignedAt'] = this.assignedAt;
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
    data['paymentStatus'] = this.paymentStatus;
    data['bookingStatus'] = this.bookingStatus;
    data['cancellationReason'] = this.cancellationReason;
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

class FleetAssigned {
  String? id;
  String? brandName;
  String? vehicleType;
  String? vehicleTypeId;
  String? modelId;
  String? modelName;
  String? modelNumber;
  int? seatingCapacity;
  String? transmissionType;
  bool? airBag;
  String? fuelType;
  List<VehiclePhotos>? vehiclePhotos;
  String? color;
  String? vehicleYear;
  String? enginerNumber;
  String? chasisNumber;
  String? registerationNumber;
  String? status;
  String? createdAt;
  String? updatedAt;

  FleetAssigned(
      {this.id,
      this.brandName,
      this.vehicleType,
      this.vehicleTypeId,
      this.modelId,
      this.modelName,
      this.modelNumber,
      this.seatingCapacity,
      this.transmissionType,
      this.airBag,
      this.fuelType,
      this.vehiclePhotos,
      this.color,
      this.vehicleYear,
      this.enginerNumber,
      this.chasisNumber,
      this.registerationNumber,
      this.status,
      this.createdAt,
      this.updatedAt});

  FleetAssigned.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandName = json['brandName'];
    vehicleType = json['vehicleType'];
    vehicleTypeId = json['vehicleTypeId'];
    modelId = json['modelId'];
    modelName = json['modelName'];
    modelNumber = json['modelNumber'];
    seatingCapacity = json['seatingCapacity'];
    transmissionType = json['transmissionType'];
    airBag = json['airBag'];
    fuelType = json['fuelType'];
    if (json['vehiclePhotos'] != null) {
      vehiclePhotos = <VehiclePhotos>[];
      json['vehiclePhotos'].forEach((v) {
        vehiclePhotos!.add(new VehiclePhotos.fromJson(v));
      });
    }
    color = json['color'];
    vehicleYear = json['vehicleYear'];
    enginerNumber = json['enginerNumber'];
    chasisNumber = json['chasisNumber'];
    registerationNumber = json['registerationNumber'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brandName'] = this.brandName;
    data['vehicleType'] = this.vehicleType;
    data['vehicleTypeId'] = this.vehicleTypeId;
    data['modelId'] = this.modelId;
    data['modelName'] = this.modelName;
    data['modelNumber'] = this.modelNumber;
    data['seatingCapacity'] = this.seatingCapacity;
    data['transmissionType'] = this.transmissionType;
    data['airBag'] = this.airBag;
    data['fuelType'] = this.fuelType;
    if (this.vehiclePhotos != null) {
      data['vehiclePhotos'] =
          this.vehiclePhotos!.map((v) => v.toJson()).toList();
    }
    data['color'] = this.color;
    data['vehicleYear'] = this.vehicleYear;
    data['enginerNumber'] = this.enginerNumber;
    data['chasisNumber'] = this.chasisNumber;
    data['registerationNumber'] = this.registerationNumber;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class VehiclePhotos {
  String? id;
  String? imageUrl;
  String? caption;
  String? mimeType;
  String? dateCreated;

  VehiclePhotos(
      {this.id, this.imageUrl, this.caption, this.mimeType, this.dateCreated});

  VehiclePhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    caption = json['caption'];
    mimeType = json['mimeType'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['caption'] = this.caption;
    data['mimeType'] = this.mimeType;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}