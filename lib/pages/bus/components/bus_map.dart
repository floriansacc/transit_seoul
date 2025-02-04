import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/models/bus/bus_position.dart';
import 'package:transit_seoul/models/bus/bus_route_path_list.dart';
import 'package:transit_seoul/models/kakao/custom_marker.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/map_point_cubit/map_point_cubit.dart';
import 'package:transit_seoul/providers/settings_cubit/settings_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';

class BusMap extends StatefulWidget {
  const BusMap({
    super.key,
    required this.shouldDrawLine,
    required this.isMapFullScreen,
    required this.isZoomOnMap,
    this.heroTag,
  });

  final ValueNotifier<bool> shouldDrawLine;
  final ValueNotifier<bool> isMapFullScreen;
  final ValueNotifier<bool> isZoomOnMap;
  final String? heroTag;

  @override
  State<BusMap> createState() => _BusMapState();
}

class _BusMapState extends State<BusMap> {
  KakaoMapController? mapController;

  final List<Polyline> polylines = [];

  ValueNotifier<bool> isMapControl = ValueNotifier<bool>(false);
  ValueNotifier<bool> hasBeenTouched = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    widget.shouldDrawLine.addListener(() async {
      if (widget.shouldDrawLine.value) {
        await drawBusLine();
      }
    });
    widget.isMapFullScreen.addListener(() async {
      if (hasBeenTouched.value) return;
      if (widget.isZoomOnMap.value) return;

      await Future.delayed(Duration(milliseconds: 150));
      await getMapOnBusLine();
    });

    widget.isZoomOnMap.addListener(() async {
      if (!widget.isZoomOnMap.value) return;

      LatLng? coordinates = context.read<MapPointCubit>().state.zoomCoordinates;
      if (coordinates != null) {
        await zoomOnCoordinates([coordinates]);
      }
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    isMapControl.dispose();
    hasBeenTouched.dispose();

    super.dispose();
  }

  Future<void> zoomOnCoordinates(List<LatLng> coordinateList) async {
    mapController?.fitBounds(coordinateList);
    await mapController?.setLevel(5);
  }

  Future<void> getMapOnBusLine() async {
    if (polylines.isEmpty) return;

    double minLat = double.infinity;
    double minLng = double.infinity;
    double maxLat = double.negativeInfinity;
    double maxLng = double.negativeInfinity;

    for (final Polyline e in polylines) {
      for (final LatLng point in e.points ?? []) {
        if (minLat > point.latitude) {
          minLat = point.latitude;
        }
        if (minLng > point.longitude) {
          minLng = point.longitude;
        }
        if (maxLat < point.latitude) {
          maxLat = point.latitude;
        }
        if (maxLng < point.longitude) {
          maxLng = point.longitude;
        }
      }
    }

    await mapController?.fitBounds([
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    ]);
    setState(() {});
  }

  Future<void> drawBusLine() async {
    List<RoutePathListItem> routePath =
        context.read<BusInfoCubit>().state.routePath?.msgBody.itemList ?? [];

    if (routePath.isEmpty) return;

    polylines.add(
      Polyline(
        strokeWidth: 2,
        strokeColor: Colors.black,
        strokeOpacity: 0.6,
        strokeStyle: StrokeStyle.solid,
        polylineId: '${routePath.first.no}',
        points: [
          for (final (RoutePathListItem e) in routePath) LatLng(e.gpsY, e.gpsX),
        ],
      ),
    );
    await getMapOnBusLine();
  }

  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    return BlocListener<BusInfoCubit, BusInfoState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          List<BusPositionItem> busList =
              state.busPosition?.msgBody.itemList ?? [];
          if (busList.isEmpty) return;

          mapController?.clearMarker();
          context.read<MapPointCubit>().addBusPositon(context);
        }
      },
      child: Hero(
        tag: widget.heroTag ?? '',
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMapFullScreen.value ? 0 : 16,
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: MediaQuery.of(context).size.width,
            height: widget.isMapFullScreen.value
                ? MediaQuery.of(context).size.height
                : (MediaQuery.of(context).size.width / 1.5) + 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: widget.isMapFullScreen.value
                  ? null
                  : Border.all(width: 2, color: Colors.black),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: kakaoMap(context),
                  ),
                ),
                if (busCubit.state.busId?.busRouteId != null)
                  Positioned(
                    top: widget.isMapFullScreen.value ? 132 : 4,
                    left: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withAlpha(150),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          '현재 : ${busCubit.state.busId?.busRouteNm}번',
                          style: StyleText.bodyMedium(
                            context,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 0,
                  top: widget.isMapFullScreen.value ? 120 : 0,
                  child: Row(
                    children: [
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withAlpha(150),
                          ),
                        ),
                        onPressed: () async {
                          context.read<MapPointCubit>().resetCustomMarker();
                          await getMapOnBusLine();
                          hasBeenTouched.value = false;
                          widget.isZoomOnMap.value = false;
                        },
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        icon: Icon(
                          Icons.restart_alt,
                          size: 24,
                        ),
                      ),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withAlpha(150),
                          ),
                        ),
                        onPressed: () => widget.isMapFullScreen.value =
                            !widget.isMapFullScreen.value,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        icon: Icon(
                          widget.isMapFullScreen.value
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  KakaoMap kakaoMap(BuildContext context) {
    final SettingsCubit settings = context.read<SettingsCubit>();

    final MapPointCubit mapPointCubit = context.watch<MapPointCubit>();

    Set<Marker> busMarker = mapPointCubit.state.busMarker ?? {};

    return KakaoMap(
      mapTypeControl: settings.state.isMapControl,
      zoomControl: settings.state.isMapControl,
      mapTypeControlPosition: ControlPosition.topLeft,
      zoomControlPosition: ControlPosition.left,
      key: context.read<BusInfoCubit>().state.mapKey,
      polylines: polylines,
      markers: [
        ...busMarker,
        for (final CustomMarker e in mapPointCubit.state.marker ?? []) e.marker,
      ],
      onMapCreated: (controller) {
        mapController = controller;

        List<RoutePathListItem> routePath =
            context.read<BusInfoCubit>().state.routePath?.msgBody.itemList ??
                [];

        if (routePath.isNotEmpty) {
          drawBusLine();
        }
      },
      onDragChangeCallback: (latLng, zoomLevel, dragType) {
        if (!hasBeenTouched.value) {
          hasBeenTouched.value = true;
        }
      },
      onMapTap: (latLng) {},
      center: LatLng(
        37.526126,
        126.922255,
      ),
    );
  }
}
