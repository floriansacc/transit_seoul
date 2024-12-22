import 'dart:convert';

import 'package:http/http.dart';

import '../models/bus_route_info.dart';
import '../styles/logger.dart';
import 'global_service.dart';

class BusService extends GlobalService {
  Future<BusRouteInfo?> getRouteInfo(int busId) async {
    String endpoint = '/busRouteInfo/getRouteInfo?';

    try {
      final Response response = await httpRequest(
        HttpMethod.get,
        apiUrl: ApiType.bus,
        path: endpoint,
        queryParameters: {'busRouteId': '$busId'},
      );

      if (response.statusCode != 200) return null;

      final Map<String, dynamic> json = jsonDecode(response.body);

      return BusRouteInfo.fromJson(json);
    } catch (e, s) {
      errorLog(e, s);
      return null;
    }
  }
}
