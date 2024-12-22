class BusRouteInfo {
  const BusRouteInfo({
    required this.msgHeader,
    required this.msgBody,
  });

  final MsgHeader msgHeader;
  final MsgBody msgBody;

  static BusRouteInfo fromJson(Map<String, dynamic> json) {
    return BusRouteInfo(
      msgHeader: MsgHeader.fromJson(json['msgHeader'] ?? {}),
      msgBody: MsgBody.fromJson(json['msgBody'] ?? {}),
    );
  }
}

class MsgHeader {
  const MsgHeader({
    required this.headerCd,
    required this.headerMsg,
    required this.itemCount,
  });

  final String headerCd;
  final String headerMsg;
  final int itemCount;

  static MsgHeader fromJson(Map<String, dynamic> json) {
    return MsgHeader(
      headerCd: json['headerCd'] ?? '',
      headerMsg: json['headerMsg'] ?? '',
      itemCount: json['itemCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerCd': headerCd,
      'headerMsg': headerMsg,
      'itemCount': itemCount,
    };
  }
}

class MsgBody {
  const MsgBody({
    required this.itemList,
  });

  final List<RouteInfoItem> itemList;

  static MsgBody fromJson(Map<String, dynamic> json) {
    return MsgBody(
      itemList: RouteInfoItem.fromJsonList(json['itemList'] ?? []),
    );
  }
}

class RouteInfoItem {
  const RouteInfoItem({
    required this.busRouteId,
    required this.busRouteNm,
    required this.busRouteAbrv,
    required this.length,
    required this.routeType,
    required this.stStationNm,
    required this.edStationNm,
    required this.term,
    required this.lastBusYn,
    required this.lastBusTm,
    required this.firstBusTm,
    required this.lastLowTm,
    required this.firstLowTm,
    required this.corpNm,
  });

  final int busRouteId;
  final String busRouteNm;
  final int busRouteAbrv;
  final double length;
  final int routeType;
  final String stStationNm;
  final String edStationNm;
  final int term;
  final String lastBusYn;
  final String lastBusTm;
  final String firstBusTm;
  final String lastLowTm;
  final String firstLowTm;
  final String corpNm;

  static List<RouteInfoItem> fromJsonList(List<dynamic> jsonList) {
    // ignore: unnecessary_lambdas
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static RouteInfoItem fromJson(Map<String, dynamic> json) {
    return RouteInfoItem(
      busRouteId: int.parse(json['busRouteId'] ?? '0'),
      busRouteNm: json['busRouteNm'] ?? '',
      busRouteAbrv: int.parse(json['busRouteAbrv'] ?? '0'),
      length: double.parse(json['length'] ?? '0'),
      routeType: int.parse(json['routeType'] ?? '0'),
      stStationNm: json['stStationNm'] ?? '',
      edStationNm: json['edStationNm'] ?? '',
      term: int.parse(json['term'] ?? '0'),
      lastBusYn: json['lastBusYn'] ?? '',
      lastBusTm: json['lastBusTm'] ?? '',
      firstBusTm: json['firstBusTm'] ?? '',
      lastLowTm: json['lastLowTm'] ?? '',
      firstLowTm: json['firstLowTm'] ?? '',
      corpNm: json['corpNm'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busRouteId': busRouteId,
      'busRouteNm': busRouteNm,
      'busRouteAbrv': busRouteAbrv,
      'length': length,
      'routeType': routeType,
      'stStationNm': stStationNm,
      'edStationNm': edStationNm,
      'term': term,
      'lastBusYn': lastBusYn,
      'lastBusTm': lastBusTm,
      'firstBusTm': firstBusTm,
      'lastLowTm': lastLowTm,
      'firstLowTm': firstLowTm,
      'corpNm': corpNm,
    };
  }
}
