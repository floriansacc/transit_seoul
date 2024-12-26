class CoordToAddress {
  const CoordToAddress({
    required this.meta,
    required this.documents,
  });

  final MetaModel meta;
  final List<DocumentsModel> documents;

  static CoordToAddress fromJson(Map<String, dynamic> json) {
    return CoordToAddress(
      meta: MetaModel.fromJson(json['meta'] ?? {}),
      documents: DocumentsModel.fromJsonList(json['documents'] ?? []),
    );
  }
}

class MetaModel {
  const MetaModel({
    required this.totalCount,
  });

  final int totalCount;

  static MetaModel fromJson(Map<String, dynamic> json) {
    return MetaModel(
      totalCount: int.parse(json['total_count'] ?? '0'),
    );
  }
}

class DocumentsModel {
  const DocumentsModel({
    required this.address,
    required this.roadAddress,
  });

  final AddressModel address;
  final RoadAddressModel roadAddress;

  static List<DocumentsModel> fromJsonList(List<dynamic> jsonList) {
    // ignore: unnecessary_lambdas
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static DocumentsModel fromJson(Map<String, dynamic> json) {
    return DocumentsModel(
      address: AddressModel.fromJson(json['address'] ?? {}),
      roadAddress: RoadAddressModel.fromJson(
        json['road_address'] ?? {},
      ),
    );
  }
}

class AddressModel {
  const AddressModel({
    required this.addressName,
    required this.region1depthName,
    required this.region2depthName,
    required this.region3depthName,
    required this.mountainYn,
    required this.mainAddressNo,
    required this.subAddressNo,
  });

  final String addressName;
  final String region1depthName;
  final String region2depthName;
  final String region3depthName;
  final String mountainYn;
  final int mainAddressNo;
  final int subAddressNo;

  static AddressModel fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressName: json['address_name'] ?? '',
      region1depthName: json['region_1depth_name'] ?? '',
      region2depthName: json['region_2depth_name'] ?? '',
      region3depthName: json['region_3depth_name'] ?? '',
      mountainYn: json['mountain_yn'] ?? '',
      mainAddressNo: int.parse(json['main_address_no'] ?? '0'),
      subAddressNo: int.parse(json['sub_address_no'] ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressName': addressName,
      'region1depthName': region1depthName,
      'region2depthName': region2depthName,
      'region3depthName': region3depthName,
      'mountainYn': mountainYn,
      'mainAddressNo': mainAddressNo,
      'subAddressNo': subAddressNo,
    };
  }
}

class RoadAddressModel {
  const RoadAddressModel({
    required this.addressName,
    required this.region1depthName,
    required this.region2depthName,
    required this.region3depthName,
    required this.roadName,
    required this.undergroundYn,
    required this.mainBuildingNo,
    required this.subBuildingNo,
    required this.buildingName,
    required this.zoneNo,
  });

  final String addressName;
  final String region1depthName;
  final String region2depthName;
  final String region3depthName;
  final String roadName;
  final String undergroundYn;
  final int mainBuildingNo;
  final int subBuildingNo;
  final String buildingName;
  final int zoneNo;

  static RoadAddressModel fromJson(Map<String, dynamic> json) {
    return RoadAddressModel(
      addressName: json['address_name'] ?? '',
      region1depthName: json['region_1depth_name'] ?? '',
      region2depthName: json['region_2depth_name'] ?? '',
      region3depthName: json['region_3depth_name'] ?? '',
      roadName: json['road_name'] ?? '',
      undergroundYn: json['underground_yn'] ?? '',
      mainBuildingNo: int.parse(json['main_building_no'] ?? '0'),
      subBuildingNo: int.parse(json['sub_building_no'] ?? '0'),
      buildingName: json['building_name'] ?? '',
      zoneNo: int.parse(json['zone_no'] ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressName': addressName,
      'region1depthName': region1depthName,
      'region2depthName': region2depthName,
      'region3depthName': region3depthName,
      'roadName': roadName,
      'undergroundYn': undergroundYn,
      'mainBuildingNo': mainBuildingNo,
      'subBuildingNo': subBuildingNo,
      'buildingName': buildingName,
      'zoneNo': zoneNo,
    };
  }
}
