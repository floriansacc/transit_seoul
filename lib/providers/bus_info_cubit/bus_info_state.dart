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
    this.busInfo,
    this.routePath,
    this.stationList,
  });

  final BusInfoStatus status;
  final BusRouteInfoItem? busInfo;
  final BusRoutePathList? routePath;
  final BusStationList? stationList;

  BusInfoState copyWith({
    BusInfoStatus? status,
    BusRouteInfoItem? busInfo,
    BusRoutePathList? routePath,
    BusStationList? stationList,
  }) {
    return BusInfoState(
      status: status ?? this.status,
      busInfo: busInfo ?? this.busInfo,
      routePath: routePath ?? this.routePath,
      stationList: stationList ?? this.stationList,
    );
  }

  @override
  List<Object?> get props => [
        status,
        busInfo,
        routePath,
        stationList,
      ];
}
