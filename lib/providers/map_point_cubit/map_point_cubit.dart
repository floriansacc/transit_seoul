import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/models/bus/bus_position.dart';
import 'package:transit_seoul/models/kakao/custom_marker.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';

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

    Set<CustomMarker> newList = state.marker ?? {};

    if (newList.any((e) => e.markerId == markerId)) {
      debugPrint('remove marker $markerName');
      newList.removeWhere((e) => e.markerId == markerId);
    } else {
      debugPrint('add marker $markerName');
      newList.add(markerItem);
    }

    emit(state.copyWith(status: MapPointStatus.success, marker: newList));
  }

  void zoomOnMap(LatLng coordinates) {
    emit(state.copyWith(zoomCoordinates: coordinates));
  }

  Future<void> addBusPositon(BuildContext context) async {
    List<BusPositionItem> buses =
        context.read<BusInfoCubit>().state.busPosition?.msgBody.itemList ?? [];
    Set<Marker> markers = {};

    for (final BusPositionItem bus in buses) {
      Marker marker = Marker(
        markerId: '${bus.vehId}',
        latLng: LatLng(bus.gpsY, bus.gpsX),
        width: 30,
        height: 30,
        markerImageSrc:
            'https://cdn0.iconfinder.com/data/icons/geo-points/154/bus-512.png',
        infoWindowRemovable: true,
        infoWindowFirstShow: true,
      );

      markers.add(marker);
    }

    emit(state.copyWith(busMarker: markers));
  }

  void resetCustomMarker() {
    emit(state.copyWith(marker: {}));
  }
}
