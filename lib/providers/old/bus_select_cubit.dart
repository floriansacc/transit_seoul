// import 'package:bloc/bloc.dart';
// import 'package:transit_seoul/models/bus/bus_route_info.dart';
// import 'package:transit_seoul/services/bus_service.dart';
// import 'package:transit_seoul/styles/logger.dart';
// import 'package:equatable/equatable.dart';

// part 'bus_select_state.dart';

// class BusSelectCubit extends Cubit<BusSelectState> {
//   BusSelectCubit(this._repository) : super(BusSelectState());

//   final BusService _repository;

//   Future<void> getBusRouteInfo(int busNumber) async {
//     emit(state.copyWith(status: BusSelectStatus.loading));
//     try {
//       BusRouteInfoItem? busInfo = await _repository.getBusById(busNumber);

//       if (busInfo != null) {
//         emit(
//           state.copyWith(
//             status: BusSelectStatus.success,
//             busInfo: busInfo,
//           ),
//         );
//       } else {
//         emit(state.copyWith(status: BusSelectStatus.fail));
//         logger.i('no bus info for bus number $busNumber');
//       }
//     } catch (e, s) {
//       logger.e('error getBusRouteInfo', error: e, stackTrace: s);
//       emit(state.copyWith(status: BusSelectStatus.fail));
//     }
//   }
// }
