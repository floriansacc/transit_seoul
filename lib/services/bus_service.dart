import 'dart:convert';

import 'package:bus_app/controllers/api_exception.dart';
import 'package:bus_app/enums/firebase_collection.dart';
import 'package:bus_app/models/bus/bus_route_path_list.dart';
import 'package:bus_app/models/bus/bus_station_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/bus/bus_route_info.dart';
import '../styles/logger.dart';
import 'global_service.dart';

class BusService extends GlobalService {
  Future<BusRouteInfoItem?> getBusById(int busNumber) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      DocumentSnapshot<Map<String, dynamic>> busInfo = await db
          .collection(FirebaseCollection.busRouteList.title)
          .doc('$busNumber')
          .get();

      if (busInfo.exists) {
        return BusRouteInfoItem.fromJson(busInfo.data() ?? {});
      } else {
        return null;
      }
    } catch (e, s) {
      errorLog(e, s);
      debugPrint('catch of getBusById: $e');
      rethrow;
    }
  }

  Future<BusRouteInfo?> getRouteInfo(int busId) async {
    String endpoint = '/busRouteInfo/getRouteInfo?';

    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentReference<Map<String, dynamic>> fbDoc =
          db.collection(FirebaseCollection.routeInfoItem.title).doc('$busId');

      DocumentSnapshot<Map<String, dynamic>> busInfo = await fbDoc.get();

      if (busInfo.exists) {
        debugPrint('$busId from firebase RouteInfoItem');
        return BusRouteInfo.fromJson(busInfo.data() ?? {});
      } else {
        final Response response = await httpRequest(
          HttpMethod.get,
          apiUrl: ApiType.bus,
          path: endpoint,
          queryParameters: {'busRouteId': '$busId'},
        );

        if (response.statusCode != 200) {
          throw ApiException(response.statusCode, response.body);
        }

        final Map<String, dynamic> json = jsonDecode(response.body);

        fbDoc
            .set(json)
            .then((_) => debugPrint('$busId saved to firebase RouteInfoItem'));
        return BusRouteInfo.fromJson(json);
      }
    } catch (e, s) {
      errorLog(e, s);
      rethrow;
    }
  }

  Future<BusRoutePathList?> getRoutePathList(int busId) async {
    String endpoint = '/busRouteInfo/getRoutePath?';

    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentReference<Map<String, dynamic>> fbDoc =
          db.collection(FirebaseCollection.routePathList.title).doc('$busId');

      DocumentSnapshot<Map<String, dynamic>> routeInfo = await fbDoc.get();

      if (routeInfo.exists) {
        debugPrint('$busId from firebase RoutePathList');
        return BusRoutePathList.fromJson(routeInfo.data()!);
      } else {
        final Response response = await httpRequest(
          HttpMethod.get,
          apiUrl: ApiType.bus,
          path: endpoint,
          queryParameters: {'busRouteId': '$busId'},
        );

        if (response.statusCode != 200) {
          throw ApiException(response.statusCode, response.body);
        }

        final Map<String, dynamic> json = jsonDecode(response.body);

        fbDoc
            .set(json)
            .then((_) => debugPrint('$busId saved to firebase RoutePathList'));

        return BusRoutePathList.fromJson(json);
      }
    } catch (e, s) {
      errorLog(e, s);
      rethrow;
    }
  }

  Future<BusStationList?> getStationsByRouteList(int busId) async {
    String endpoint = '/busRouteInfo/getStaionByRoute?';

    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentReference<Map<String, dynamic>> fbDoc = db
          .collection(FirebaseCollection.stationsByRouteList.title)
          .doc('$busId');

      DocumentSnapshot<Map<String, dynamic>> stationsByRoute =
          await fbDoc.get();

      if (stationsByRoute.exists) {
        debugPrint('$busId from firebase StationsByRouteList');
        return BusStationList.fromJson(stationsByRoute.data() ?? {});
      } else {
        final Response response = await httpRequest(
          HttpMethod.get,
          apiUrl: ApiType.bus,
          path: endpoint,
          queryParameters: {'busRouteId': '$busId'},
        );

        if (response.statusCode != 200) {
          throw ApiException(response.statusCode, response.body);
        }

        final Map<String, dynamic> json = jsonDecode(response.body);

        fbDoc.set(json).then(
              (_) => debugPrint('$busId saved to firebase StationsByRouteList'),
            );

        return BusStationList.fromJson(json);
      }
    } catch (e, s) {
      errorLog(e, s);
      rethrow;
    }
  }

  // -------------------------------------------------------
  // get all bus route list
  // datas are already stored on Firebase
  // -------------------------------------------------------
  Future<BusRouteInfo?> getBusRouteList() async {
    String endpoint = '/busRouteInfo/getBusRouteList?';

    try {
      final Response response = await httpRequest(
        HttpMethod.get,
        apiUrl: ApiType.bus,
        path: endpoint,
      );

      if (response.statusCode != 200) {
        throw ApiException(response.statusCode, response.body);
      }

      final Map<String, dynamic> json = jsonDecode(response.body);

      return BusRouteInfo.fromJson(json);
    } catch (e, s) {
      errorLog(e, s);
      rethrow;
    }
  }
}
