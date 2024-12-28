import 'package:bus_app/models/bus/bus_msg_header.dart';

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

class MsgBody {
  const MsgBody({
    required this.itemList,
  });

  final List<BusRouteInfoItem> itemList;

  static MsgBody fromJson(Map<String, dynamic> json) {
    return MsgBody(
      itemList: BusRouteInfoItem.fromJsonList(json['itemList'] ?? []),
    );
  }
}

class BusRouteInfoItem {
  const BusRouteInfoItem({
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
  final int busRouteNm;
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

  static List<BusRouteInfoItem> fromJsonList(List<dynamic> jsonList) {
    // ignore: unnecessary_lambdas
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static BusRouteInfoItem fromJson(Map<String, dynamic> json) {
    return BusRouteInfoItem(
      busRouteId: json['busRouteId'] is int
          ? json['busRouteId'] ?? 0
          : int.parse(json['busRouteId'] ?? '0'),
      busRouteNm: json['busRouteNm'] is int
          ? json['busRouteNm'] ?? 0
          : int.parse(json['busRouteNm'] ?? '0'),
      busRouteAbrv: json['busRouteAbrv'] is int
          ? json['busRouteAbrv'] ?? 0
          : int.parse(json['busRouteAbrv'] ?? '0'),
      length: json['length'] is int
          ? ((json['length'] ?? 0) as int).toDouble()
          : json['length'] is double
              ? json['length'] ?? 0
              : double.parse(json['length'] ?? '0'),
      routeType: json['routeType'] is int
          ? json['routeType'] ?? 0
          : int.parse(json['routeType'] ?? '0'),
      stStationNm: json['stStationNm'] ?? '',
      edStationNm: json['edStationNm'] ?? '',
      term: json['term'] is int
          ? json['term'] ?? 0
          : int.parse(json['term'] ?? '0'),
      lastBusYn: json['lastBusYn'] ?? '',
      lastBusTm: json['lastBusTm'] ?? '',
      firstBusTm: json['firstBusTm'] ?? '',
      lastLowTm: json['lastLowTm'] ?? '',
      firstLowTm: json['firstLowTm'] ?? '',
      corpNm: json['corpNm'] ?? '',
    );
  }

  static BusRouteInfoItem fromFirestore(Map<String, dynamic> json) {
    return BusRouteInfoItem(
      busRouteId: json['busRouteId'] ?? 0,
      busRouteNm: json['busRouteNm'] ?? 0,
      busRouteAbrv: json['busRouteAbrv'] ?? 0,
      length: json['length'] is int
          ? ((json['length'] ?? 0) as int).toDouble()
          : json['length'] ?? 0,
      routeType: json['routeType'] ?? 0,
      stStationNm: json['stStationNm'] ?? '',
      edStationNm: json['edStationNm'] ?? '',
      term: json['term'] ?? 0,
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
