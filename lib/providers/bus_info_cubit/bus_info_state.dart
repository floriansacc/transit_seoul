part of 'bus_info_cubit.dart';

enum BusInfoStatus { initial, loading, success, fail }

extension BusInfoStatusX on BusInfoStatus {
  bool get isInitial => this == BusInfoStatus.initial;
  bool get isLoading => this == BusInfoStatus.loading;
  bool get isSuccess => this == BusInfoStatus.success;
  bool get isFailed => this == BusInfoStatus.fail;
}

class BusInfoState extends Equatable {
  const BusInfoState({
    this.status = BusInfoStatus.initial,
    this.busId,
    this.busInfo,
    this.routePath,
    this.stationList,
    this.busPosition,
    this.searchNumber,
    this.mapKey,
    this.nextStationsIndex,
  });

  final BusInfoStatus status;
  final BusId? busId;
  final BusRouteInfo? busInfo;
  final BusRoutePathList? routePath;
  final BusStationList? stationList;
  final BusPosition? busPosition;
  final int? searchNumber;
  final Key? mapKey;
  final List<int>? nextStationsIndex;

  BusInfoState copyWith({
    BusInfoStatus? status,
    BusId? busId,
    BusRouteInfo? busInfo,
    BusRoutePathList? routePath,
    BusStationList? stationList,
    BusPosition? busPosition,
    int? searchNumber,
    Key? mapKey,
    List<int>? nextStationsIndex,
  }) {
    return BusInfoState(
      status: status ?? this.status,
      busId: busId ?? this.busId,
      busInfo: busInfo ?? this.busInfo,
      routePath: routePath ?? this.routePath,
      stationList: stationList ?? this.stationList,
      busPosition: busPosition ?? this.busPosition,
      searchNumber: searchNumber ?? this.searchNumber,
      mapKey: mapKey ?? this.mapKey,
      nextStationsIndex: nextStationsIndex ?? this.nextStationsIndex,
    );
  }

  @override
  List<Object?> get props => [
        status,
        busId,
        busInfo,
        routePath,
        stationList,
        busPosition,
        searchNumber,
        mapKey,
        nextStationsIndex,
      ];
}
