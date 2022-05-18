// class Profile {
//   int? statuscode;
//   Body? body;
//   String? message;

//   Profile({this.statuscode, this.body, this.message});

//   Profile.fromJson(Map<String, dynamic> json) {
//     statuscode = json['statuscode'];
//     body = json['body'] != null ? new Body.fromJson(json['body']) : null;
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['statuscode'] = this.statuscode;
//     if (this.body != null) {
//       data['body'] = this.body!.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }

// class Body {
//   String? id;
//   String? fullName;
//   String? address;
//   String? email;
//   String? cityId;
//   String? cityName;
//   String? phoneNumber;
//   String? employeeId;
//   String? alternatePhoneNumber;
//   String? gender;
//   Avatar? avatar;
//   List<KycDocuments>? kycDocuments;
//   String? licenseNumber;
//   Avatar? licenseImage;
//   String? status;
//   bool? acceptingBooking;
//   LastLocation? lastLocation;
//   String? lastLocationUpdatedAt;
//   FleetAssigned? fleetAssigned;
//   double? commission;
//   String? createdAt;
//   String? updatedAt;

//   Body(
//       {this.id,
//       this.fullName,
//       this.address,
//       this.email,
//       this.cityId,
//       this.cityName,
//       this.phoneNumber,
//       this.employeeId,
//       this.alternatePhoneNumber,
//       this.gender,
//       this.avatar,
//       this.kycDocuments,
//       this.licenseNumber,
//       this.licenseImage,
//       this.status,
//       this.acceptingBooking,
//       this.lastLocation,
//       this.lastLocationUpdatedAt,
//       this.fleetAssigned,
//       this.commission,
//       this.createdAt,
//       this.updatedAt});

//   Body.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     fullName = json['fullName'];
//     address = json['address'];
//     email = json['email'];
//     cityId = json['cityId'];
//     cityName = json['cityName'];
//     phoneNumber = json['phoneNumber'];
//     employeeId = json['employeeId'];
//     alternatePhoneNumber = json['alternatePhoneNumber'];
//     gender = json['gender'];
//     avatar =
//         json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
//     if (json['kycDocuments'] != null) {
//       kycDocuments = <KycDocuments>[];
//       json['kycDocuments'].forEach((v) {
//         kycDocuments!.add(new KycDocuments.fromJson(v));
//       });
//     }
//     licenseNumber = json['licenseNumber'];
//     licenseImage = json['licenseImage'] != null
//         ? new Avatar.fromJson(json['licenseImage'])
//         : null;
//     status = json['status'];
//     acceptingBooking = json['acceptingBooking'];
//     lastLocation = json['lastLocation'] != null
//         ? new LastLocation.fromJson(json['lastLocation'])
//         : null;
//     lastLocationUpdatedAt = json['lastLocationUpdatedAt'];
//     fleetAssigned = json['fleetAssigned'] != null
//         ? new FleetAssigned.fromJson(json['fleetAssigned'])
//         : null;
//     commission = json['commission'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['fullName'] = this.fullName;
//     data['address'] = this.address;
//     data['email'] = this.email;
//     data['cityId'] = this.cityId;
//     data['cityName'] = this.cityName;
//     data['phoneNumber'] = this.phoneNumber;
//     data['employeeId'] = this.employeeId;
//     data['alternatePhoneNumber'] = this.alternatePhoneNumber;
//     data['gender'] = this.gender;
//     if (this.avatar != null) {
//       data['avatar'] = this.avatar!.toJson();
//     }
//     if (this.kycDocuments != null) {
//       data['kycDocuments'] = this.kycDocuments!.map((v) => v.toJson()).toList();
//     }
//     data['licenseNumber'] = this.licenseNumber;
//     if (this.licenseImage != null) {
//       data['licenseImage'] = this.licenseImage!.toJson();
//     }
//     data['status'] = this.status;
//     data['acceptingBooking'] = this.acceptingBooking;
//     if (this.lastLocation != null) {
//       data['lastLocation'] = this.lastLocation!.toJson();
//     }
//     data['lastLocationUpdatedAt'] = this.lastLocationUpdatedAt;
//     if (this.fleetAssigned != null) {
//       data['fleetAssigned'] = this.fleetAssigned!.toJson();
//     }
//     data['commission'] = this.commission;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     return data;
//   }
// }

// class Avatar {
//   String? id;
//   String? imageUrl;
//   String? caption;
//   String? mimeType;
//   String? dateCreated;

//   Avatar(
//       {this.id, this.imageUrl, this.caption, this.mimeType, this.dateCreated});

//   Avatar.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     imageUrl = json['imageUrl'];
//     caption = json['caption'];
//     mimeType = json['mimeType'];
//     dateCreated = json['dateCreated'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['imageUrl'] = this.imageUrl;
//     data['caption'] = this.caption;
//     data['mimeType'] = this.mimeType;
//     data['dateCreated'] = this.dateCreated;
//     return data;
//   }
// }

// class KycDocuments {
//   String? id;
//   String? documentType;
//   List<Images>? images;

//   KycDocuments({this.id, this.documentType, this.images});

//   KycDocuments.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     documentType = json['documentType'];
//     if (json['images'] != null) {
//       images = <Images>[];
//       json['images'].forEach((v) {
//         images!.add(new Images.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['documentType'] = this.documentType;
//     if (this.images != null) {
//       data['images'] = this.images!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Images {
//   String? id;
//   String? imageUrl;
//   String? caption;
//   String? mimeType;
//   String? dateCreated;

//   Images(
//       {this.id, this.imageUrl, this.caption, this.mimeType, this.dateCreated});

//   Images.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     imageUrl = json['imageUrl'];
//     caption = json['caption'];
//     mimeType = json['mimeType'];
//     dateCreated = json['dateCreated'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['imageUrl'] = this.imageUrl;
//     data['caption'] = this.caption;
//     data['mimeType'] = this.mimeType;
//     data['dateCreated'] = this.dateCreated;
//     return data;
//   }
// }

// class LastLocation {
//   String? latitude;
//   String? longitude;

//   LastLocation({this.latitude, this.longitude});

//   LastLocation.fromJson(Map<String, dynamic> json) {
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     return data;
//   }
// }

// class FleetAssigned {
//   String? id;
//   String? brandName;
//   String? vehicleType;
//   String? vehicleTypeId;
//   String? modelId;
//   String? modelName;
//   String? modelNumber;
//   int? seatingCapacity;
//   String? transmissionType;
//   bool? airBag;
//   String? fuelType;
//   List<VehiclePhotos>? vehiclePhotos;
//   String? color;
//   String? vehicleYear;
//   String? enginerNumber;
//   String? chasisNumber;
//   String? registerationNumber;
//   String? status;
//   String? createdAt;
//   String? updatedAt;

//   FleetAssigned(
//       {this.id,
//       this.brandName,
//       this.vehicleType,
//       this.vehicleTypeId,
//       this.modelId,
//       this.modelName,
//       this.modelNumber,
//       this.seatingCapacity,
//       this.transmissionType,
//       this.airBag,
//       this.fuelType,
//       this.vehiclePhotos,
//       this.color,
//       this.vehicleYear,
//       this.enginerNumber,
//       this.chasisNumber,
//       this.registerationNumber,
//       this.status,
//       this.createdAt,
//       this.updatedAt});

//   FleetAssigned.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     brandName = json['brandName'];
//     vehicleType = json['vehicleType'];
//     vehicleTypeId = json['vehicleTypeId'];
//     modelId = json['modelId'];
//     modelName = json['modelName'];
//     modelNumber = json['modelNumber'];
//     seatingCapacity = json['seatingCapacity'];
//     transmissionType = json['transmissionType'];
//     airBag = json['airBag'];
//     fuelType = json['fuelType'];
//     if (json['vehiclePhotos'] != null) {
//       vehiclePhotos = <VehiclePhotos>[];
//       json['vehiclePhotos'].forEach((v) {
//         vehiclePhotos!.add(new VehiclePhotos.fromJson(v));
//       });
//     }
//     color = json['color'];
//     vehicleYear = json['vehicleYear'];
//     enginerNumber = json['enginerNumber'];
//     chasisNumber = json['chasisNumber'];
//     registerationNumber = json['registerationNumber'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['brandName'] = this.brandName;
//     data['vehicleType'] = this.vehicleType;
//     data['vehicleTypeId'] = this.vehicleTypeId;
//     data['modelId'] = this.modelId;
//     data['modelName'] = this.modelName;
//     data['modelNumber'] = this.modelNumber;
//     data['seatingCapacity'] = this.seatingCapacity;
//     data['transmissionType'] = this.transmissionType;
//     data['airBag'] = this.airBag;
//     data['fuelType'] = this.fuelType;
//     if (this.vehiclePhotos != null) {
//       data['vehiclePhotos'] =
//           this.vehiclePhotos!.map((v) => v.toJson()).toList();
//     }
//     data['color'] = this.color;
//     data['vehicleYear'] = this.vehicleYear;
//     data['enginerNumber'] = this.enginerNumber;
//     data['chasisNumber'] = this.chasisNumber;
//     data['registerationNumber'] = this.registerationNumber;
//     data['status'] = this.status;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     return data;
//   }
// }

// class VehiclePhotos {
//   String? id;
//   String? imageUrl;
//   String? caption;
//   String? mimeType;
//   String? dateCreated;

//   VehiclePhotos(
//       {this.id, this.imageUrl, this.caption, this.mimeType, this.dateCreated});

//   VehiclePhotos.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     imageUrl = json['imageUrl'];
//     caption = json['caption'];
//     mimeType = json['mimeType'];
//     dateCreated = json['dateCreated'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['imageUrl'] = this.imageUrl;
//     data['caption'] = this.caption;
//     data['mimeType'] = this.mimeType;
//     data['dateCreated'] = this.dateCreated;
//     return data;
//   }
// }
class Profile {
  int? statuscode;
  Body? body;
  String? message;

  Profile({this.statuscode, this.body, this.message});

  Profile.fromJson(Map<String, dynamic> json) {
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
  String? fullName;
  String? address;
  String? email;
  String? cityId;
  String? cityName;
  String? phoneNumber;
  String? employeeId;
  String? alternatePhoneNumber;
  String? gender;
  Avatar? avatar;
  List<KycDocuments>? kycDocuments;
  String? licenseNumber;
  LicenseImage? licenseImage;
  String? status;
  bool? acceptingBooking;
  LastLocation? lastLocation;
  String? lastLocationUpdatedAt;
  FleetAssigned? fleetAssigned;
  double? commission;
  String? createdAt;
  String? updatedAt;

  Body(
      {this.id,
      this.fullName,
      this.address,
      this.email,
      this.cityId,
      this.cityName,
      this.phoneNumber,
      this.employeeId,
      this.alternatePhoneNumber,
      this.gender,
      this.avatar,
      this.kycDocuments,
      this.licenseNumber,
      this.licenseImage,
      this.status,
      this.acceptingBooking,
      this.lastLocation,
      this.lastLocationUpdatedAt,
      this.fleetAssigned,
      this.commission,
      this.createdAt,
      this.updatedAt});

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    address = json['address'];
    email = json['email'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    phoneNumber = json['phoneNumber'];
    employeeId = json['employeeId'];
    alternatePhoneNumber = json['alternatePhoneNumber'];
    gender = json['gender'];
    avatar =
        json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    if (json['kycDocuments'] != null) {
      kycDocuments = <KycDocuments>[];
      json['kycDocuments'].forEach((v) {
        kycDocuments!.add(new KycDocuments.fromJson(v));
      });
    }
    licenseNumber = json['licenseNumber'];
    licenseImage = json['licenseImage'] != null
        ? new LicenseImage.fromJson(json['licenseImage'])
        : null;
    status = json['status'];
    acceptingBooking = json['acceptingBooking'];
    lastLocation = json['lastLocation'] != null
        ? new LastLocation.fromJson(json['lastLocation'])
        : null;
    lastLocationUpdatedAt = json['lastLocationUpdatedAt'];
    fleetAssigned = json['fleetAssigned'] != null
        ? new FleetAssigned.fromJson(json['fleetAssigned'])
        : null;
    commission = json['commission'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['email'] = this.email;
    data['cityId'] = this.cityId;
    data['cityName'] = this.cityName;
    data['phoneNumber'] = this.phoneNumber;
    data['employeeId'] = this.employeeId;
    data['alternatePhoneNumber'] = this.alternatePhoneNumber;
    data['gender'] = this.gender;
    if (this.avatar != null) {
      data['avatar'] = this.avatar!.toJson();
    }
    if (this.kycDocuments != null) {
      data['kycDocuments'] = this.kycDocuments!.map((v) => v.toJson()).toList();
    }
    data['licenseNumber'] = this.licenseNumber;
    if (this.licenseImage != null) {
      data['licenseImage'] = this.licenseImage!.toJson();
    }
    data['status'] = this.status;
    data['acceptingBooking'] = this.acceptingBooking;
    if (this.lastLocation != null) {
      data['lastLocation'] = this.lastLocation!.toJson();
    }
    data['lastLocationUpdatedAt'] = this.lastLocationUpdatedAt;
    if (this.fleetAssigned != null) {
      data['fleetAssigned'] = this.fleetAssigned!.toJson();
    }
    data['commission'] = this.commission;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Avatar {
  String? id;
  String? imageUrl;
  String? caption;
  String? mimeType;
  String? dateCreated;

  Avatar(
      {this.id, this.imageUrl, this.caption, this.mimeType, this.dateCreated});

  Avatar.fromJson(Map<String, dynamic> json) {
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

class KycDocuments {
  String? id;
  String? documentType;
  List<Images>? images;

  KycDocuments({this.id, this.documentType, this.images});

  KycDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentType = json['documentType'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['documentType'] = this.documentType;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LicenseImage {
  List<Images>? images;

  LicenseImage({this.images});

  LicenseImage.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LastLocation {
  String? latitude;
  String? longitude;

  LastLocation({this.latitude, this.longitude});

  LastLocation.fromJson(Map<String, dynamic> json) {
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

class Images {
  String? id;
  String? imageUrl;
  String? caption;
  String? mimeType;
  String? dateCreated;

  Images(
      {this.id, this.imageUrl, this.caption, this.mimeType, this.dateCreated});

  Images.fromJson(Map<String, dynamic> json) {
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
