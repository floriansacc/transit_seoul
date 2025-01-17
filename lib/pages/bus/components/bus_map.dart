import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/models/bus/bus_route_path_list.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';

class BusMap extends StatefulWidget {
  const BusMap({
    super.key,
    required this.shouldDrawLine,
  });

  final ValueNotifier shouldDrawLine;

  @override
  State<BusMap> createState() => _BusMapState();
}

class _BusMapState extends State<BusMap> {
  late KakaoMapController mapController;

  final List<Polyline> polylines = [];

  @override
  void initState() {
    super.initState();

    widget.shouldDrawLine.addListener(() async {
      if (widget.shouldDrawLine.value) {
        await drawBusLine();
      }
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> drawBusLine() async {
    BusInfoCubit busCubit = context.read<BusInfoCubit>();

    List<RoutePathListItem> routePath =
        busCubit.state.routePath?.msgBody.itemList ?? [];

    for (final e in routePath) {
      polylines.add(
        Polyline(
          strokeWidth: 3,
          strokeColor: Colors.black,
          strokeOpacity: 0.6,
          strokeStyle: StrokeStyle.solid,
          polylineId: '${e.no}',
          points: [
            LatLng(e.gpsY, e.gpsX),
          ],
        ),
      );
    }

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

  @override
  Widget build(BuildContext context) {
    // BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    return Container(
      clipBehavior: Clip.hardEdge,
      width: (MediaQuery.of(context).size.width / 1.5) + 2,
      height: (MediaQuery.of(context).size.width / 1.5) + 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: KakaoMap(
          polylines: polylines,
          onMapCreated: (controller) {
            mapController = controller;

            setState(() {});
          },
          onMapTap: (latLng) {
            // print(latLng);
            // polylines.add(
            //   Polyline(
            //     polylineId: 'clickLine',
            //     points: [latLng],
            //     strokeWidth: 3,
            //     strokeColor: const Color(0xffdb4040),
            //     strokeOpacity: 1,
            //     strokeStyle: StrokeStyle.solid,
            //   ),
            // );

            // if (routePath.isNotEmpty) {
            //   for (final e in routePath) {
            //     polylines.add(
            //       Polyline(
            //         strokeWidth: 3,
            //         strokeColor: Colors.black,
            //         strokeOpacity: 0.6,
            //         strokeStyle: StrokeStyle.solid,
            //         polylineId: '${e.no}',
            //         points: [
            //           LatLng(e.gpsY, e.gpsX),
            //         ],
            //       ),
            //     );
            //   }
            // }
            // setState(() {});
          },
          center: LatLng(
            37.526126,
            126.922255,
          ),
        ),
      ),
    );
  }
}
