import 'package:bus_app/controllers/geolocalisation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({super.key});

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  late KakaoMapController mapController;
  Position? position;

  @override
  void initState() {
    super.initState();
    print('bbbbbbb');
    Future.delayed(Duration(seconds: 2), () async {
      position = await Geolocalisation.determinePosition();
      print('determinePosition');
      setState(() {});
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: KakaoMap(
          onCenterChangeCallback: (latlng, zoomLevel) {
            mapController.setLevel(4);
            print('aaaaaaa');
          },
          onMapCreated: (controller) {
            mapController = controller;

            setState(() {});
          },
          onMapTap: (latLng) {
            debugPrint('***** [JHC_DEBUG] ${latLng.toString()}');
          },
          center: LatLng(
            position?.latitude ?? 37.526126,
            position?.longitude ?? 126.922255,
          ),
        ),
      ),
    );
  }
}
