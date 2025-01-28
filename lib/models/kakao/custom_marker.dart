import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class CustomMarker {
  const CustomMarker({
    required this.markerId,
    required this.marker,
  });

  final int markerId;
  final Marker marker;

  Map<String, dynamic> toJson() {
    return {
      'markerId': markerId,
      'marker': marker,
    };
  }
}
