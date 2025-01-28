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
  });

  final MapPointStatus status;
  final List<CustomMarker>? marker;

  MapPointState copyWith({
    MapPointStatus? status,
    List<CustomMarker>? marker,
  }) {
    return MapPointState(
      status: status ?? this.status,
      marker: marker ?? this.marker,
    );
  }

  @override
  List<Object?> get props => [status, marker];
}
