import 'package:bus_app/controllers/public_method.dart';
import 'package:bus_app/models/bus/bus_msg_header.dart';

class BusRoutePathList {
  const BusRoutePathList({
    required this.msgHeader,
    required this.msgBody,
  });

  final MsgHeader msgHeader;
  final MsgBody msgBody;

  static BusRoutePathList fromJson(Map<String, dynamic> json) {
    return BusRoutePathList(
      msgHeader: MsgHeader.fromJson(json['msgHeader'] ?? {}),
      msgBody: MsgBody.fromJson(json['msgBody'] ?? {}),
    );
  }
}

class MsgBody {
  const MsgBody({
    required this.itemList,
  });

  final List<RoutePathListItem> itemList;

  static MsgBody fromJson(Map<String, dynamic> json) {
    return MsgBody(
      itemList: RoutePathListItem.fromJsonList(json['itemList'] ?? []),
    );
  }
}

class RoutePathListItem {
  const RoutePathListItem({
    required this.no,
    required this.gpsX,
    required this.gpsY,
    required this.posX,
    required this.posY,
  });
  final int no;
  final double gpsX;
  final double gpsY;
  final double posX;
  final double posY;

  static List<RoutePathListItem> fromJsonList(List<dynamic> jsonList) {
    // ignore: unnecessary_lambdas
    return jsonList.map((json) => RoutePathListItem.fromJson(json)).toList();
  }

  static RoutePathListItem fromJson(Map<String, dynamic> json) {
    return RoutePathListItem(
      no: PublicMethod.parseInt(json['no']),
      gpsX: PublicMethod.parseDouble(json['gpsX']),
      gpsY: PublicMethod.parseDouble(json['gpsY']),
      posX: PublicMethod.parseDouble(json['posX']),
      posY: PublicMethod.parseDouble(json['posY']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'gpsX': gpsX,
      'gpsY': gpsY,
      'posX': posX,
      'posY': posY,
    };
  }
}
