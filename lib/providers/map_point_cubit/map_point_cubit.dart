import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

part 'map_point_state.dart';

class MapPointCubit extends Cubit<MapPointState> {
  MapPointCubit() : super(MapPointState());

  Future<void> addMarker({
    required String markerName,
    required LatLng point,
  }) async {
    emit(state.copyWith(status: MapPointStatus.initial));

    List<Marker> newLsit = List.from(state.marker ?? [])
      ..add(
        Marker(
          markerId: markerName,
          latLng: point,
          infoWindowContent: markerName,
          infoWindowFirstShow: true,
        ),
      );

    emit(state.copyWith(status: MapPointStatus.success, marker: newLsit));
  }
}
