import 'package:bus_app/controllers/public_method.dart';
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
  final int section;
  final int station;
  final double arsId;
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
      beginTm: json['beginTm'] ?? '',
      lastTm: json['lastTm'] ?? '',
      transYn: json['transYn'] ?? '',
      stationNm: json['stationNm'] ?? '',
      busRouteId: PublicMethod.parseInt(json['busRouteId']),
      busRouteNm: PublicMethod.parseInt(json['busRouteNm']),
      busRouteAbrv: PublicMethod.parseInt(json['busRouteAbrv']),
      seq: PublicMethod.parseInt(json['seq']),
      fullSectDist: PublicMethod.parseInt(json['fullSectDist']),
      direction: json['direction'] ?? '',
      stationNo: PublicMethod.parseDouble(json['stationNo']).toInt(),
      routeType: PublicMethod.parseInt(json['routeType']),
      trnstnid: PublicMethod.parseInt(json['trnstnid']),
      section: PublicMethod.parseInt(json['section']),
      station: PublicMethod.parseInt(json['station']),
      arsId: PublicMethod.parseDouble(json['arsId']),
      gpsX: PublicMethod.parseDouble(json['gpsX']),
      gpsY: PublicMethod.parseDouble(json['gpsY']),
      posX: PublicMethod.parseDouble(json['posX']),
      posY: PublicMethod.parseDouble(json['posY']),
      sectSpd: PublicMethod.parseDouble(json['sectSpd']),
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
