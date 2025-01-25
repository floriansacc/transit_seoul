import 'dart:convert';

import 'package:transit_seoul/controllers/api_exception.dart';
import 'package:transit_seoul/enums/firebase_collection.dart';
import 'package:transit_seoul/models/bus/bus_id.dart';
import 'package:transit_seoul/models/bus/bus_route_path_list.dart';
import 'package:transit_seoul/models/bus/bus_station_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/bus/bus_route_info.dart';
import '../styles/logger.dart';
import 'global_service.dart';

class BusService extends GlobalService {
  Future<BusId?> getBusById(int busNumber) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      DocumentSnapshot<Map<String, dynamic>> busInfo = await db
          .collection(FirebaseCollection.busId.title)
          .doc('$busNumber')
          .get();

      if (busInfo.exists) {
        return BusId.fromJson(busInfo.data() ?? {});
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

      return BusRouteInfo.fromJson(json);
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

        // fbDoc
        //     .set(json)
        //     .then((_) => debugPrint('$busId saved to firebase RoutePathList'));

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

        // fbDoc.set(json).then(
        //       (_) => debugPrint('$busId saved to firebase StationsByRouteList'),
        //     );

        return BusStationList.fromJson(json);
      }
    } catch (e, s) {
      errorLog(e, s);
      rethrow;
    }
  }

  // -------------------------------------------------------
  // get all bus route list
  // datas are already stored on Firebase,
  // commented for safety
  // -------------------------------------------------------
  // Future<BusRouteInfo?> getBusRouteList() async {
  //   String endpoint = '/busRouteInfo/getBusRouteList?';

  //   try {
  //     final Response response = await httpRequest(
  //       HttpMethod.get,
  //       apiUrl: ApiType.bus,
  //       path: endpoint,
  //     );

  //     if (response.statusCode != 200) {
  //       throw ApiException(response.statusCode, response.body);
  //     }

  //     final Map<String, dynamic> json = jsonDecode(response.body);

  //     BusRouteInfo data = BusRouteInfo.fromJson(json);
  //     List<BusId> busIdList = [];
  //     for (final BusRouteInfoItem e in data.msgBody.itemList) {
  //       busIdList.add(
  //         BusId(
  //           busRouteId: e.busRouteId,
  //           busRouteNm: e.busRouteNm,
  //           busRouteAbrv: e.busRouteAbrv,
  //         ),
  //       );
  //     }
  //     FirebaseFirestore db = FirebaseFirestore.instance;

  //     CollectionReference<Map<String, dynamic>> fbDoc =
  //         db.collection(FirebaseCollection.busId.title);

  //     for (final BusId e in busIdList) {
  //       fbDoc.doc(e.busRouteNm.toString()).set(e.toJson());
  //       debugPrint('set doc for ${e.busRouteNm}');
  //     }
  //   } catch (e, s) {
  //     errorLog(e, s);
  //     rethrow;
  //   }
  //   return null;
  // }
}
