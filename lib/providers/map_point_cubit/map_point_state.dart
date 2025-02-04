part of 'map_point_cubit.dart';

enum MapPointStatus { initial, loading, success, fail }

extension MapPointStatusX on MapPointStatus {
  bool get isInitial => this == MapPointStatus.initial;
  bool get isLoading => this == MapPointStatus.loading;
  bool get isSuccess => this == MapPointStatus.success;
  bool get isFailed => this == MapPointStatus.fail;
}

class MapPointState extends Equatable {
  const MapPointState({
    this.status = MapPointStatus.initial,
    this.marker,
    this.zoomCoordinates,
    this.busMarker,
  });

  final MapPointStatus status;
  final Set<CustomMarker>? marker;
  final LatLng? zoomCoordinates;
  final Set<Marker>? busMarker;

  MapPointState copyWith({
    MapPointStatus? status,
    Set<CustomMarker>? marker,
    LatLng? zoomCoordinates,
    Set<Marker>? busMarker,
  }) {
    return MapPointState(
      status: status ?? this.status,
      marker: marker ?? this.marker,
      zoomCoordinates: zoomCoordinates ?? this.zoomCoordinates,
      busMarker: busMarker ?? this.busMarker,
    );
  }

  @override
  List<Object?> get props => [
        status,
        marker,
        zoomCoordinates,
        busMarker,
      ];
}
