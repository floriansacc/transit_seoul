import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:transit_seoul/controllers/geolocalisation.dart';
import 'package:transit_seoul/models/bus/bus_position.dart';
import 'package:transit_seoul/models/bus/bus_route_path_list.dart';
import 'package:transit_seoul/models/bus/bus_station_list.dart';
import 'package:transit_seoul/models/kakao/custom_marker.dart';
import 'package:transit_seoul/pages/map/components/bus_stop_carousel.dart';
import 'package:transit_seoul/pages/map/components/map_search.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/map_point_cubit/map_point_cubit.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late KakaoMapController mapController;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final TextInputAction textInputAction = TextInputAction.search;

  Set<Marker> posMarker = {};
  final List<Polyline> polylines = [];

  ValueNotifier<bool> isSearchOpen = ValueNotifier(false);
  final ValueNotifier<bool> shouldDrawLine = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    shouldDrawLine.addListener(() async {
      if (shouldDrawLine.value) {
        await drawBusLine();
      }
    });
  }

  @override
  void dispose() {
    isSearchOpen.dispose();
    mapController.dispose();
    shouldDrawLine.dispose();
    super.dispose();
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

    await mapController.fitBounds([
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    ]);
    setState(() {});
  }

  Future<void> getCenterToPos() async {
    Position position = await Geolocalisation.determinePosition();

    await mapController.getCenter();

    mapController.setCenter(LatLng(position.latitude, position.longitude));
    posMarker.add(
      Marker(
        markerId: 'myPosition',
        latLng: LatLng(position.latitude, position.longitude),
      ),
    );

    setState(() {});
  }

  Future<void> goToStation(LatLng coord) async {
    int currentLevel = await mapController.getLevel();

    if (currentLevel > 5) {
      await mapController.setLevel(5);
    }
    await mapController.panTo(coord);
  }

  // Future<void> searchFunction() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   AddressSearchResponse? addressSearch;
  //   KeywordSearchResponse? keyworkdSearch;

  //   List<LatLng> listLatLng = [];

  //   markers.clear();

  //   addressSearch = await getAddressSearch();

  //   if (addressSearch.list.isEmpty) {
  //     debugPrint('No result by address, search by keyword');
  //     keyworkdSearch = await getKeywordSearch();
  //     for (final KeywordAddress item in keyworkdSearch.list) {
  //       LatLng point = LatLng(
  //         double.parse(item.y ?? ''),
  //         double.parse(item.x ?? ''),
  //       );

  //       listLatLng.add(point);
  //       markers.add(
  //         Marker(
  //           markerId: controller.text,
  //           latLng: point,
  //           infoWindowContent: item.placeName!,
  //           infoWindowFirstShow: true,
  //         ),
  //       );
  //       if ((item.placeName ?? '').contains(controller.text)) break;
  //     }
  //   }

  //   for (final SearchAddress item in addressSearch.list) {
  //     LatLng point = LatLng(
  //       double.parse(item.y ?? ''),
  //       double.parse(item.x ?? ''),
  //     );

  //     listLatLng.add(point);
  //     markers.add(
  //       Marker(
  //         markerId: controller.text,
  //         latLng: point,
  //       ),
  //     );
  //   }

  //   setState(() {});
  //   await mapController.fitBounds(listLatLng);
  // }

  Future<AddressSearchResponse> getAddressSearch() async {
    AddressSearchRequest address = AddressSearchRequest(
      addr: controller.text,
      analyzeType: AnalyzeType.similar,
    );
    AddressSearchResponse response = await mapController.addressSearch(address);

    return response;
  }

  Future<KeywordSearchResponse> getKeywordSearch() async {
    KeywordSearchRequest keyword = KeywordSearchRequest(
      keyword: controller.text,
      page: 1,
      sort: SortBy.accuracy,
    );
    KeywordSearchResponse response = await mapController.keywordSearch(keyword);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          BlocListener<BusInfoCubit, BusInfoState>(
            listener: (context, state) {
              if (state.status.isSuccess) {
                List<BusPositionItem> busList =
                    state.busPosition?.msgBody.itemList ?? [];
                if (busList.isEmpty) return;

                mapController.clearMarker();
                context.read<MapPointCubit>().addBusPositon(context);
              }
            },
            child: BlocBuilder<MapPointCubit, MapPointState>(
              builder: (context, state) {
                Set<Marker> busMarker = state.busMarker ?? {};
                Set<CustomMarker> customMarker = state.marker ?? {};

                return KakaoMap(
                  onMapCreated: (controller) async {
                    mapController = controller;

                    setState(() {});
                    await getCenterToPos();
                  },
                  onCenterChangeCallback: (latlng, zoomLevel) async {},
                  onDragChangeCallback: (latLng, zoomLevel, dragType) async {},
                  onMapTap: (latLng) {
                    debugPrint('***** [JHC_DEBUG] ${latLng.toString()}');
                  },
                  markers: [
                    ...busMarker,
                    for (final CustomMarker e in customMarker) e.marker,
                  ],
                  polylines: polylines,
                  center: LatLng(
                    37.526126,
                    126.922255,
                  ),
                );
              },
            ),
          ),
          BlocBuilder<BusInfoCubit, BusInfoState>(
            builder: (context, state) {
              List<StationListItem> stationItems =
                  state.stationList?.msgBody.itemList ?? [];

              if (stationItems.isEmpty) {
                return SizedBox.shrink();
              }

              return Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: PointerInterceptor(
                  intercepting: true,
                  child: BusStopCarousel(
                    stationList: stationItems,
                    onTapCard: goToStation,
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: isSearchOpen,
            builder: (context, isOpen, child) => Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: isOpen
                  ? SizedBox.shrink()
                  : PointerInterceptor(
                      intercepting: true,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MapSearch(
                            isSearchOpen: isSearchOpen,
                            shouldDrawLine: shouldDrawLine,
                            isModal: false,
                            focusNode: focusNode,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            top: 20,
            left: 4,
            child: PointerInterceptor(
              intercepting: true,
              child: GestureDetector(
                onTap: () {
                  isSearchOpen.value = !isSearchOpen.value;
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(150),
                    shape: BoxShape.circle,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: isSearchOpen,
                    builder: (context, isOpen, child) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(isOpen ? Icons.search : Icons.search_off),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
