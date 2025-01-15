import 'package:transit_seoul/controllers/public_method.dart';

class BusId {
  const BusId({
    required this.busRouteId,
    required this.busRouteNm,
    required this.busRouteAbrv,
  });

  final int busRouteId;
  final int busRouteNm;
  final int busRouteAbrv;

  static BusId fromJson(Map<String, dynamic> json) {
    return BusId(
      busRouteId: PublicMethod.parseInt(json['busRouteId']),
      busRouteNm: PublicMethod.parseInt(json['busRouteNm']),
      busRouteAbrv: PublicMethod.parseInt(json['busRouteAbrv']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busRouteId': busRouteId,
      'busRouteNm': busRouteNm,
      'busRouteAbrv': busRouteAbrv,
    };
  }
}
