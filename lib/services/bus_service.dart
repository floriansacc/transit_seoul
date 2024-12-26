import 'dart:convert';

import 'package:bus_app/models/bus/bus_route_path_list.dart';
import 'package:bus_app/models/bus/bus_station_list.dart';
import 'package:http/http.dart';

import '../models/bus/bus_route_info.dart';
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

  Future<BusRoutePathList?> getRoutePathList(int busId) async {
    String endpoint = '/busRouteInfo/getRoutePath?';

    try {
      final Response response = await httpRequest(
        HttpMethod.get,
        apiUrl: ApiType.bus,
        path: endpoint,
        queryParameters: {'busRouteId': '$busId'},
      );

      if (response.statusCode != 200) return null;

      final Map<String, dynamic> json = jsonDecode(response.body);

      return BusRoutePathList.fromJson(json);
    } catch (e, s) {
      errorLog(e, s);
      return null;
    }
  }

  Future<BusRouteInfo?> getBusRouteList(int busId) async {
    String endpoint = '/busRouteInfo/getBusRouteList?';

    try {
      final Response response = await httpRequest(
        HttpMethod.get,
        apiUrl: ApiType.bus,
        path: endpoint,
      );

      if (response.statusCode != 200) return null;

      final Map<String, dynamic> json = jsonDecode(response.body);

      return BusRouteInfo.fromJson(json);
    } catch (e, s) {
      errorLog(e, s);
      return null;
    }
  }

  Future<BusStationList?> getStationsByRouteList(int busId) async {
    String endpoint = '/busRouteInfo/getStaionByRoute?';

    try {
      final Response response = await httpRequest(
        HttpMethod.get,
        apiUrl: ApiType.bus,
        path: endpoint,
        queryParameters: {'busRouteId': '$busId'},
      );

      if (response.statusCode != 200) return null;

      final Map<String, dynamic> json = jsonDecode(response.body);

      return BusStationList.fromJson(json);
    } catch (e, s) {
      errorLog(e, s);
      return null;
    }
  }
}
