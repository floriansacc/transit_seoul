import 'package:bloc/bloc.dart';
import 'package:bus_app/models/bus/bus_route_info.dart';
import 'package:bus_app/models/bus/bus_route_path_list.dart';
import 'package:bus_app/models/bus/bus_station_list.dart';
import 'package:bus_app/services/bus_service.dart';
import 'package:bus_app/styles/logger.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'bus_info_state.dart';

class BusInfoCubit extends Cubit<BusInfoState> {
  BusInfoCubit(this._repository) : super(BusInfoState());

  final BusService _repository;

  Future<void> getBusRouteInfo(
    int busNumber, {
    required bool getDetails,
  }) async {
    emit(state.copyWith(status: BusInfoStatus.loading));

    if (state.busInfo?.busRouteId == busNumber) {
      debugPrint('bus $busNumber is already in cubit !');
      if (getDetails) {
        await getBusDetails();
      }
      return;
    }

    try {
      BusRouteInfoItem? busInfo = await _repository.getBusById(busNumber);

      if (busInfo != null) {
        emit(
          state.copyWith(
            status: getDetails ? null : BusInfoStatus.success,
            busInfo: busInfo,
          ),
        );
        if (getDetails) {
          await getBusDetails();
        }
      } else {
        emit(state.copyWith(status: BusInfoStatus.fail));
        logger.i('no bus info for bus number $busNumber');
      }
    } catch (e, s) {
      logger.e('error getBusRouteInfo', error: e, stackTrace: s);
      emit(state.copyWith(status: BusInfoStatus.fail));
    }
  }

  Future<void> getBusDetails() async {
    emit(state.copyWith(status: BusInfoStatus.loading));

    int? busId = state.busInfo?.busRouteId;
    if (busId == null) return;

    if (state.stationList?.msgBody.itemList
            .firstWhereOrNull((e) => e.busRouteId == busId) !=
        null) {
      debugPrint('details of bus $busId is already in cubit !');
      emit(state.copyWith(status: BusInfoStatus.success));
      return;
    }

    try {
      BusRoutePathList? routePathList =
          await _repository.getRoutePathList(busId);
      BusStationList? stationList =
          await _repository.getStationsByRouteList(busId);

      if (routePathList == null || stationList == null) {
        logger.i('no detailed info for bus number $busId');
        emit(state.copyWith(status: BusInfoStatus.success));
      } else {
        emit(
          state.copyWith(
            status: BusInfoStatus.success,
            routePath: routePathList,
            stationList: stationList,
          ),
        );
      }
    } catch (e, s) {
      logger.e('error getbusDetails', error: e, stackTrace: s);
      emit(state.copyWith(status: BusInfoStatus.fail));
    }
  }
}
