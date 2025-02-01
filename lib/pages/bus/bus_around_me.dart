import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/settings_cubit/settings_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';

class BusAroundMe extends StatefulWidget {
  const BusAroundMe({
    super.key,
    this.heroTag,
  });

  final String? heroTag;

  @override
  State<BusAroundMe> createState() => _BusAroundMeState();
}

class _BusAroundMeState extends State<BusAroundMe> {
  KakaoMapController? mapController;

  @override
  void dispose() {
    mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsCubit settings = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 주변 버스',
          style: StyleText.bodyLarge(context),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: 200,
        width: 200,
        child: KakaoMap(
          mapTypeControl: settings.state.isMapControl,
          zoomControl: settings.state.isMapControl,
          mapTypeControlPosition: ControlPosition.topLeft,
          zoomControlPosition: ControlPosition.left,
          key: context.read<BusInfoCubit>().state.mapKey,
          onMapCreated: (controller) {
            mapController = controller;

            setState(() {});
          },
          onMapTap: (latLng) {},
          center: LatLng(
            37.526126,
            126.922255,
          ),
        ),
      ),
    );
  }
}
