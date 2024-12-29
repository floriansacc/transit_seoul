import 'package:bus_app/controllers/public_method.dart';
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
      stStationNm: json['stStationNm'] ?? '',
      edStationNm: json['edStationNm'] ?? '',
      lastBusYn: json['lastBusYn'] ?? '',
      lastBusTm: json['lastBusTm'] ?? '',
      firstBusTm: json['firstBusTm'] ?? '',
      lastLowTm: json['lastLowTm'] ?? '',
      firstLowTm: json['firstLowTm'] ?? '',
      corpNm: json['corpNm'] ?? '',
      busRouteId: PublicMethod.parseInt(json['busRouteId']),
      busRouteNm: PublicMethod.parseInt(json['busRouteNm']),
      busRouteAbrv: PublicMethod.parseInt(json['busRouteAbrv']),
      routeType: PublicMethod.parseInt(json['routeType']),
      term: PublicMethod.parseInt(json['term']),
      length: PublicMethod.parseDouble(json['length']),
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
