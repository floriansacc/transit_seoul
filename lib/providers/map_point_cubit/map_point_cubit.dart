import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/models/kakao/custom_marker.dart';

part 'map_point_state.dart';

class MapPointCubit extends Cubit<MapPointState> {
  MapPointCubit() : super(MapPointState());

  Future<void> addMarker({
    required int markerId,
    required String markerName,
    required LatLng point,
  }) async {
    emit(state.copyWith(status: MapPointStatus.initial));

    // List<Marker> newList = List.from(state.marker ?? [])
    //   ..add(
    //     Marker(
    //       markerId: markerName,
    //       latLng: point,
    //       infoWindowContent: markerName,
    //       infoWindowFirstShow: true,
    //     ),
    //   );

    CustomMarker markerItem = CustomMarker(
      markerId: markerId,
      marker: Marker(
        markerId: '$markerId',
        infoWindowContent: markerName,
        latLng: point,
        draggable: false,
      ),
    );

    List<CustomMarker> newList = state.marker ?? [];

    if (newList.any((e) => e.markerId == markerId)) {
      debugPrint('remove marker $markerName');
      newList.removeWhere((e) => e.markerId == markerId);
    } else {
      debugPrint('add marker $markerName');
      newList.add(markerItem);
    }

    emit(state.copyWith(status: MapPointStatus.success, marker: newList));
  }
}
