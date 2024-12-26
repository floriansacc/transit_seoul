import 'package:bus_app/models/bus/bus_msg_header.dart';

class BusStationList {
  const BusStationList({
    required this.msgHeader,
    required this.msgBody,
  });

  final MsgHeader msgHeader;
  final MsgBody msgBody;

  static BusStationList fromJson(Map<String, dynamic> json) {
    return BusStationList(
      msgHeader: MsgHeader.fromJson(json['msgHeader'] ?? {}),
      msgBody: MsgBody.fromJson(json['msgBody'] ?? {}),
    );
  }
}

class MsgBody {
  const MsgBody({
    required this.itemList,
  });

  final List<StationListItem> itemList;

  static MsgBody fromJson(Map<String, dynamic> json) {
    return MsgBody(
      itemList: StationListItem.fromJsonList(json['itemList'] ?? []),
    );
  }
}

class StationListItem {
  const StationListItem({
    required this.busRouteId,
    required this.busRouteNm,
    required this.busRouteAbrv,
    required this.seq,
    required this.section,
    required this.station,
    required this.arsId,
    required this.stationNm,
    required this.gpsX,
    required this.gpsY,
    required this.posX,
    required this.posY,
    required this.fullSectDist,
    required this.direction,
    required this.stationNo,
    required this.routeType,
    required this.beginTm,
    required this.lastTm,
    required this.trnstnid,
    required this.sectSpd,
    required this.transYn,
  });

  final int busRouteId;
  final int busRouteNm;
  final int busRouteAbrv;
  final int seq;
  final double section;
  final double station;
  final int arsId;
  final String stationNm;
  final double gpsX;
  final double gpsY;
  final double posX;
  final double posY;
  final int fullSectDist;
  final String direction;
  final int stationNo;
  final int routeType;
  final String beginTm;
  final String lastTm;
  final int trnstnid;
  final double sectSpd;
  final String transYn;

  static List<StationListItem> fromJsonList(List<dynamic> jsonList) {
    // ignore: unnecessary_lambdas
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static StationListItem fromJson(Map<String, dynamic> json) {
    return StationListItem(
      busRouteId: int.parse(json['busRouteId'] ?? '0'),
      busRouteNm: int.parse(json['busRouteNm'] ?? '0'),
      busRouteAbrv: int.parse(json['busRouteAbrv'] ?? '0'),
      seq: int.parse(json['seq'] ?? '0'),
      section: double.parse(json['section'] ?? '0'),
      station: double.parse(json['station'] ?? '0'),
      arsId: int.parse(json['arsId'] ?? '0'),
      stationNm: json['stationNm'] ?? '',
      gpsX: double.parse(json['gpsX'] ?? '0'),
      gpsY: double.parse(json['gpsY'] ?? '0'),
      posX: double.parse(json['posX'] ?? '0'),
      posY: double.parse(json['posY'] ?? '0'),
      fullSectDist: int.parse(json['fullSectDist'] ?? '0'),
      direction: json['direction'] ?? '',
      stationNo: int.parse(json['stationNo'] ?? '0'),
      routeType: int.parse(json['routeType'] ?? '0'),
      beginTm: json['beginTm'] ?? '',
      lastTm: json['lastTm'] ?? '',
      trnstnid: int.parse(json['trnstnid'] ?? '0'),
      sectSpd: double.parse(json['sectSpd'] ?? '0'),
      transYn: json['transYn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busRouteId': busRouteId,
      'busRouteNm': busRouteNm,
      'busRouteAbrv': busRouteAbrv,
      'seq': seq,
      'section': section,
      'station': station,
      'arsId': arsId,
      'stationNm': stationNm,
      'gpsX': gpsX,
      'gpsY': gpsY,
      'posX': posX,
      'posY': posY,
      'fullSectDist': fullSectDist,
      'direction': direction,
      'stationNo': stationNo,
      'routeType': routeType,
      'beginTm': beginTm,
      'lastTm': lastTm,
      'trnstnid': trnstnid,
      'sectSpd': sectSpd,
      'transYn': transYn,
    };
  }
}
