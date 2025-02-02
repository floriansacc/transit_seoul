import 'package:collection/collection.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/enums/bus_congestion_enum.dart';
import 'package:transit_seoul/models/bus/bus_msg_header.dart';

class BusPosition {
  const BusPosition({
    required this.msgHeader,
    required this.msgBody,
  });

  final MsgHeader msgHeader;
  final MsgBody msgBody;

  static BusPosition fromJson(Map<String, dynamic> json) {
    return BusPosition(
      msgHeader: MsgHeader.fromJson(json['msgHeader'] ?? {}),
      msgBody: MsgBody.fromJson(json['msgBody'] ?? {}),
    );
  }
}

class MsgBody {
  const MsgBody({
    required this.itemList,
  });

  final List<BusPositionItem> itemList;

  static MsgBody fromJson(Map<String, dynamic> json) {
    return MsgBody(
      itemList: BusPositionItem.fromJsonList(json['itemList'] ?? []),
    );
  }
}

class BusPositionItem {
  const BusPositionItem({
    required this.sectOrd,
    required this.fullSectDist,
    required this.sectDist,
    required this.rtDist,
    required this.stopFlag,
    required this.sectionId,
    required this.dataTm,
    required this.gpsX,
    required this.gpsY,
    required this.vehId,
    required this.plainNo,
    required this.busType,
    required this.lastStTm,
    required this.nextStTm,
    required this.isRunYN,
    required this.trnstnid,
    required this.islastyn,
    required this.isFullFlag,
    required this.posX,
    required this.posY,
    required this.lastStnId,
    required this.congetion,
    required this.nextStId,
  });

  final int sectOrd;
  final double fullSectDist;
  final double sectDist;
  final double rtDist;
  final bool stopFlag;
  final int sectionId;
  final String dataTm;
  final double gpsX;
  final double gpsY;
  final int vehId;
  final String plainNo;
  final int busType;
  final double lastStTm;
  final double nextStTm;
  final bool isRunYN;
  final int trnstnid;
  final bool islastyn;
  final bool isFullFlag;
  final double posX;
  final double posY;
  final int lastStnId;
  final BusCongestionEnum congetion;
  final int nextStId;

  static BusPositionItem fromJson(Map<String, dynamic> json) {
    return BusPositionItem(
      sectOrd: PublicMethod.parseInt(json['sectOrd']),
      fullSectDist: PublicMethod.parseDouble(json['fullSectDist']),
      sectDist: PublicMethod.parseDouble(json['sectDist']),
      rtDist: PublicMethod.parseDouble(json['rtDist']),
      stopFlag: json['stopFlag'] == 1,
      sectionId: PublicMethod.parseInt(json['sectionId']),
      dataTm: json['dataTm'] ?? '',
      gpsX: PublicMethod.parseDouble(json['gpsX']),
      gpsY: PublicMethod.parseDouble(json['gpsY']),
      vehId: PublicMethod.parseInt(json['vehId']),
      plainNo: json['plainNo'] ?? '',
      busType: PublicMethod.parseInt(json['busType']),
      lastStTm: PublicMethod.parseDouble(json['lastStTm']),
      nextStTm: PublicMethod.parseDouble(json['nextStTm']),
      isRunYN: json['isrunyn'] == 1,
      trnstnid: PublicMethod.parseInt(json['trnstnid']),
      islastyn: json['islastyn'] == 1,
      isFullFlag: json['isFullFlag'] == 1,
      posX: PublicMethod.parseDouble(json['posX']),
      posY: PublicMethod.parseDouble(json['posY']),
      lastStnId: PublicMethod.parseInt(json['lastStnId']),
      congetion: BusCongestionEnum.values.firstWhereOrNull(
            (e) => e.number == PublicMethod.parseInt(json['congetion']),
          ) ??
          BusCongestionEnum.empty,
      nextStId: PublicMethod.parseInt(json['nextStId']),
    );
  }

  static List<BusPositionItem> fromJsonList(List<dynamic> jsonList) {
    // ignore: unnecessary_lambdas
    return jsonList.map((json) => fromJson(json)).toList();
  }
}
