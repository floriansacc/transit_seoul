// part of 'bus_select_cubit.dart';

// enum BusSelectStatus { initial, loading, success, fail }

// extension BusSelectStatusX on BusSelectStatus {
//   bool get isInitial => this == BusSelectStatus.initial;
//   bool get isLoading => this == BusSelectStatus.loading;
//   bool get isSuccess => this == BusSelectStatus.success;
//   bool get isFailed => this == BusSelectStatus.fail;
// }

// class BusSelectState extends Equatable {
//   const BusSelectState({
//     this.status = BusSelectStatus.initial,
//     this.busInfo,
//   });

//   final BusSelectStatus status;
//   final BusRouteInfoItem? busInfo;

//   BusSelectState copyWith({
//     BusSelectStatus? status,
//     BusRouteInfoItem? busInfo,
//   }) {
//     return BusSelectState(
//       status: status ?? this.status,
//       busInfo: busInfo ?? this.busInfo,
//     );
//   }

//   @override
//   List<Object?> get props => [status, busInfo];
// }
