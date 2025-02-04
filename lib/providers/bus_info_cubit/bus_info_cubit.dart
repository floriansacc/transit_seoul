import 'package:bloc/bloc.dart';
import 'package:transit_seoul/models/bus/bus_id.dart';
import 'package:transit_seoul/models/bus/bus_position.dart';
import 'package:transit_seoul/models/bus/bus_route_info.dart';
import 'package:transit_seoul/models/bus/bus_route_path_list.dart';
import 'package:transit_seoul/models/bus/bus_station_list.dart';
import 'package:transit_seoul/services/bus_service.dart';
import 'package:transit_seoul/styles/logger.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'bus_info_state.dart';

class BusInfoCubit extends Cubit<BusInfoState> {
  BusInfoCubit(this._repository) : super(BusInfoState());

  final BusService _repository;

  void initializeMap() {
    emit(
      state.copyWith(
        status: BusInfoStatus.initial,
        mapKey: GlobalKey(),
      ),
    );
  }

  Future<void> getBusRouteInfo(
    int busNumber, {
    required bool getDetails,
  }) async {
    emit(
      state.copyWith(
        status: BusInfoStatus.loading,
        searchNumber: busNumber,
      ),
    );

    if (state.busId?.busRouteNm == busNumber) {
      debugPrint('bus $busNumber is already in cubit !');
      if (getDetails) {
        await getBusDetails();
      }
      return;
    }

    try {
      BusId? busId = await _repository.getBusById(busNumber);

      if (busId != null) {
        debugPrint('got bus id of bus $busNumber');
        BusRouteInfo? busInfo =
            await _repository.getRouteInfo(busId.busRouteId);

        debugPrint('got basic info of bus $busNumber');

        emit(
          state.copyWith(
            status: getDetails ? null : BusInfoStatus.success,
            busId: busId,
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

    int? busId = state.busId?.busRouteId;
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
      BusPosition? busPosition = await _repository.getBusPosition(busId);

      List<int> nextStops = getIndexOfBusPosition();

      emit(
        state.copyWith(
          status: BusInfoStatus.success,
          routePath: routePathList,
          stationList: stationList,
          busPosition: busPosition,
          nextStationsIndex: nextStops,
        ),
      );
    } catch (e, s) {
      logger.e('error getbusDetails', error: e, stackTrace: s);
      emit(state.copyWith(status: BusInfoStatus.fail));
    }
  }

  Future<void> refreshBusPosition() async {
    emit(state.copyWith(status: BusInfoStatus.refresh));
    int? busId = state.busId?.busRouteId;

    if (busId == null) {
      emit(state.copyWith(status: BusInfoStatus.fail));
      return;
    }

    try {
      BusPosition? busPosition = await _repository.getBusPosition(busId);

      emit(
        state.copyWith(
          status: BusInfoStatus.success,
          busPosition: busPosition,
        ),
      );
    } catch (e, s) {
      logger.e('error getBusPosition', error: e, stackTrace: s);
      emit(state.copyWith(status: BusInfoStatus.fail));
    }
  }

  List<int> getIndexOfBusPosition() {
    List<int> result = [];

    for (final BusPositionItem e in state.busPosition?.msgBody.itemList ?? []) {
      int stationId = (state.stationList?.msgBody.itemList ?? [])
          .indexWhere((stop) => stop.stationNo == e.nextStId);
      if (stationId >= 0) {
        result.add(stationId);
      }
    }

    return result;
  }
}
