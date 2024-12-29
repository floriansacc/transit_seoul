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
    this.searchNumber,
  });

  final BusInfoStatus status;
  final BusId? busId;
  final BusRouteInfo? busInfo;
  final BusRoutePathList? routePath;
  final BusStationList? stationList;
  final int? searchNumber;

  BusInfoState copyWith({
    BusInfoStatus? status,
    BusId? busId,
    BusRouteInfo? busInfo,
    BusRoutePathList? routePath,
    BusStationList? stationList,
    int? searchNumber,
  }) {
    return BusInfoState(
      status: status ?? this.status,
      busId: busId ?? this.busId,
      busInfo: busInfo ?? this.busInfo,
      routePath: routePath ?? this.routePath,
      stationList: stationList ?? this.stationList,
      searchNumber: searchNumber ?? this.searchNumber,
    );
  }

  @override
  List<Object?> get props => [
        status,
        busId,
        busInfo,
        routePath,
        stationList,
        searchNumber,
      ];
}
