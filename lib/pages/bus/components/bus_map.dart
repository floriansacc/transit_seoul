import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/models/bus/bus_route_path_list.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/settings_cubit/settings_cubit.dart';

class BusMap extends StatefulWidget {
  const BusMap({
    super.key,
    required this.shouldDrawLine,
    required this.isMapFullScreen,
  });

  final ValueNotifier<bool> shouldDrawLine;
  final ValueNotifier<bool> isMapFullScreen;

  @override
  State<BusMap> createState() => _BusMapState();
}

class _BusMapState extends State<BusMap> {
  final Key _mapKey = GlobalKey();

  late KakaoMapController mapController;

  final List<Polyline> polylines = [];

  ValueNotifier<bool> isMapControl = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    widget.shouldDrawLine.addListener(() async {
      if (widget.shouldDrawLine.value) {
        await drawBusLine();
      }
    });
    widget.isMapFullScreen.addListener(() async {
      await Future.delayed(Duration(milliseconds: 100));
      await getMapOnBusLine();
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    isMapControl.dispose();
    super.dispose();
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

    setState(() {});
    await mapController.fitBounds([
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    ]);
  }

  Future<void> drawBusLine() async {
    List<RoutePathListItem> routePath =
        context.read<BusInfoCubit>().state.routePath?.msgBody.itemList ?? [];

    for (final (int i, RoutePathListItem e) in routePath.indexed) {
      if (i > 0 && i % 2 == 0) {
        polylines.add(
          Polyline(
            strokeWidth: 3,
            strokeColor: Colors.black,
            strokeOpacity: 0.6,
            strokeStyle: StrokeStyle.solid,
            polylineId: '${e.no}',
            points: [
              LatLng(e.gpsY, e.gpsX),
              LatLng(routePath[i - 1].gpsY, routePath[i - 1].gpsX),
            ],
          ),
        );
      }
    }
    await getMapOnBusLine();
  }

  @override
  Widget build(BuildContext context) {
    // BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: MediaQuery.of(context).size.width,
        height: widget.isMapFullScreen.value
            ? MediaQuery.of(context).size.height - 200
            : (MediaQuery.of(context).size.width / 1.5) + 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(width: 2, color: Colors.black),
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
            Positioned(
              bottom: widget.isMapFullScreen.value ? null : 0,
              right: 0,
              top: widget.isMapFullScreen.value ? 0 : null,
              child: GestureDetector(
                onTap: () => widget.isMapFullScreen.value =
                    !widget.isMapFullScreen.value,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.isMapFullScreen.value
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      widget.isMapFullScreen.value
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      size: 30,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  KakaoMap kakaoMap(BuildContext context) {
    final SettingsCubit settings = context.read<SettingsCubit>();

    return KakaoMap(
      mapTypeControl: settings.state.isMapControl,
      zoomControl: settings.state.isMapControl,
      mapTypeControlPosition: ControlPosition.topLeft,
      zoomControlPosition: ControlPosition.left,
      key: _mapKey,
      polylines: polylines,
      onMapCreated: (controller) {
        mapController = controller;

        setState(() {});

        List<RoutePathListItem> routePath =
            context.read<BusInfoCubit>().state.routePath?.msgBody.itemList ??
                [];

        if (routePath.isNotEmpty) {
          drawBusLine();
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
