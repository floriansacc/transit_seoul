import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/components/confirm_button.dart';
import 'package:transit_seoul/components/custom_card.dart';
import 'package:transit_seoul/components/custom_search_bar.dart';
import 'package:transit_seoul/components/custom_text_form_field.dart';
import 'package:transit_seoul/enums/color_type.dart';
import 'package:transit_seoul/models/bus/bus_position.dart';
import 'package:transit_seoul/models/bus/bus_station_list.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/map_point_cubit/map_point_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';

class BusStopList extends StatefulWidget {
  const BusStopList({
    super.key,
    required this.isZoomOnMap,
  });

  final ValueNotifier<bool> isZoomOnMap;

  @override
  State<BusStopList> createState() => _BusStopListState();
}

class _BusStopListState extends State<BusStopList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  ValueNotifier<String> searchText = ValueNotifier<String>('');

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void validateSearch() {
    if (_formKey.currentState!.validate()) {
      searchText.value = textController.text;
    }
  }

  Future<void> displayStationOnMap(StationListItem station) async {
    await context.read<MapPointCubit>().addMarker(
          markerId: station.stationNo,
          markerName: station.stationNm,
          point: LatLng(station.gpsY, station.gpsX),
        );
  }

  void zoomToStop(StationListItem station) {
    widget.isZoomOnMap.value = false;
    context.read<MapPointCubit>().zoomOnMap(LatLng(station.gpsY, station.gpsX));
    widget.isZoomOnMap.value = true;
  }

  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();
    MapPointCubit mapPointCubit = context.watch<MapPointCubit>();

    List<StationListItem> stationList =
        busCubit.state.stationList?.msgBody.itemList ?? [];

    if (!busCubit.state.status.isSuccess && !busCubit.state.status.isRefresh) {
      return SizedBox();
    }

    return ValueListenableBuilder(
      valueListenable: searchText,
      builder: (context, searchValue, child) {
        return CustomCard(
          bgColor: busCubit.state.status.isSuccess && stationList.isEmpty
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.primaryContainer,
          content: Column(
            children: [
              if (busCubit.state.status.isSuccess && stationList.isEmpty)
                emptyStation(context, busCubit)
              else ...[
                Form(
                  key: _formKey,
                  child: CustomSearchBar(
                    buttonBgColor: StyleText.getColorContainer(
                      context,
                      colorType: ColorType.secondary,
                    ),
                    textFormField: CustomTextFormField(
                      hintText: '정류장 검색...',
                      borderColor:
                          Theme.of(context).colorScheme.onInverseSurface,
                      controller: textController,
                      textInputAction: TextInputAction.done,
                    ),
                    onTapSearch: validateSearch,
                  ),
                ),
                Gap(20),
                for (final (int i, StationListItem station)
                    in stationList.indexed) ...[
                  if (station.stationNm.contains(searchValue))
                    stopRow(
                      context,
                      station,
                      mapPointCubit: mapPointCubit,
                      busCubit: busCubit,
                      isFirst: i == 0,
                      // isBusComing:
                      //     busCubit.state.nextStationsIndex?.contains(i) == true,
                      busPos: busCubit.state.busPosition?.msgBody.itemList
                          .firstWhereOrNull(
                        (e) => e.sectionId == station.section,
                      ),
                    ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget stopRow(
    BuildContext context,
    StationListItem station, {
    required MapPointCubit mapPointCubit,
    required BusInfoCubit busCubit,
    required bool isFirst,
    // required bool isBusComing,
    required BusPositionItem? busPos,
  }) {
    bool isSelected = mapPointCubit.state.marker
            ?.any((e) => e.markerId == station.stationNo) ==
        true;

    return Column(
      children: [
        busComing(busPos, busCubit: busCubit, isFirst: isFirst),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(24),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            station.stationNm,
                            style: StyleText.bodyLarge(context),
                          ),
                        ),
                        Gap(8),
                      ],
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        if (station.beginTm != ':') ...[
                          Text(
                            '${station.beginTm}~${station.lastTm}',
                            style: StyleText.labelSmall(context),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                                  .withAlpha(100),
                            ),
                            child: SizedBox(
                              width: 1,
                              height: 15,
                            ),
                          ),
                        ],
                        Text(
                          '${station.stationNo}',
                          style: StyleText.labelSmall(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => zoomToStop(station),
                    icon: Icon(Icons.location_on),
                  ),
                  Flexible(
                    child: ConfirmButton(
                      description: isSelected ? '제거' : '표시',
                      borderSide: isSelected
                          ? BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            )
                          : BorderSide.none,
                      onTap: () async => displayStationOnMap(station),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      height: 48,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget emptyStation(BuildContext context, BusInfoCubit busCubit) {
    return Row(
      children: [
        Flexible(
          child: Text(
            '${busCubit.state.busId?.busRouteNm}번 버스에 해당되는 정류장이 없습니다.',
            style: StyleText.bodyLarge(context, colorType: ColorType.error),
          ),
        ),
      ],
    );
  }

  Widget busComing(
    BusPositionItem? bus, {
    required BusInfoCubit busCubit,
    required bool isFirst,
  }) {
    return Column(
      key: busCubit.state.busPosKey
          .firstWhereOrNull((key) => key.index == bus?.vehId)
          ?.globalKey,
      spacing: 6,
      children: [
        if (!isFirst)
          Container(
            width: double.infinity,
            height: 1,
            color:
                Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(100),
          ),
        Row(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                if (bus != null)
                  Row(
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.bus_alert,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      if (bus.islastyn)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: Text(
                                '막',
                                style: StyleText.labelSmall(
                                  context,
                                  colorType: ColorType.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Text(
                        '${bus.nextStTm}분 - ${bus.congetion.description}',
                        style: StyleText.labelSmall(context),
                      ),
                      Gap(8),
                      //  if (!isFirst)
                    ],
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
