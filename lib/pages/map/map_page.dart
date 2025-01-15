import 'package:transit_seoul/components/custom_search_bar.dart';
import 'package:transit_seoul/components/custom_text_form_field.dart';
import 'package:transit_seoul/controllers/geolocalisation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/controllers/public_method.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late KakaoMapController mapController;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final TextInputAction textInputAction = TextInputAction.search;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> getCenterToPos() async {
    Position position = await Geolocalisation.determinePosition();

    await mapController.getCenter();

    mapController.setCenter(LatLng(position.latitude, position.longitude));
    markers.add(
      Marker(
        markerId: 'myPosition',
        latLng: LatLng(position.latitude, position.longitude),
      ),
    );

    setState(() {});
  }

  Future<void> searchAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    AddressSearchRequest address = AddressSearchRequest(
      addr: controller.text,
      analyzeType: AnalyzeType.similar,
    );
    AddressSearchResponse response = await mapController.addressSearch(address);

    if (response.list.isEmpty) {
      if (mounted) {
        PublicMethod.toast(context, 'No result');
      }
      //TODO keyword search
      return;
    }

    markers.clear();

    List<LatLng> listLatLng = [];
    for (final SearchAddress item in response.list) {
      LatLng point = LatLng(
        double.parse(item.y ?? ''),
        double.parse(item.x ?? ''),
      );

      listLatLng.add(point);
      markers.add(
        Marker(
          markerId: controller.text,
          latLng: point,
          infoWindowContent: item.addressName!,
          infoWindowFirstShow: true,
        ),
      );
    }

    setState(() {});
    await mapController.fitBounds(listLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: CustomSearchBar(
                      textFormField: CustomTextFormField(
                        focusNode: focusNode,
                        controller: controller,
                        hintText: '주소 검색',
                        textInputAction: TextInputAction.done,
                      ),
                      onTapSearch: () async => searchAddress(),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: KakaoMap(
                      onMapCreated: (controller) async {
                        mapController = controller;

                        setState(() {});
                        await getCenterToPos();
                      },
                      onCenterChangeCallback: (latlng, zoomLevel) async {},
                      onDragChangeCallback:
                          (latLng, zoomLevel, dragType) async {},
                      onMapTap: (latLng) {
                        debugPrint('***** [JHC_DEBUG] ${latLng.toString()}');
                      },
                      markers: [
                        for (final Marker marker in markers) marker,
                      ],
                      center: LatLng(
                        37.526126,
                        126.922255,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PublicMethod.nextButtonIosKeyboard(
          context,
          displayCondition: focusNode.hasFocus,
          onTapFuction: () => FocusScope.of(context).unfocus(),
          buttonText: '닫기',
        ),
      ],
    );
  }
}
