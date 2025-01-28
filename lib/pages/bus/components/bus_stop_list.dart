import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/components/confirm_button.dart';
import 'package:transit_seoul/components/custom_card.dart';
import 'package:transit_seoul/enums/color_type.dart';
import 'package:transit_seoul/models/bus/bus_station_list.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/map_point_cubit/map_point_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';

class BusStopList extends StatelessWidget {
  const BusStopList({super.key});

  Future<void> displayStationOnMap(
    BuildContext context,
    StationListItem station,
  ) async {
    await context.read<MapPointCubit>().addMarker(
          markerId: station.stationNo,
          markerName: station.stationNm,
          point: LatLng(station.gpsY, station.gpsX),
        );
  }

  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();
    MapPointCubit mapPointCubit = context.watch<MapPointCubit>();

    List<StationListItem> stationList =
        busCubit.state.stationList?.msgBody.itemList ?? [];

    if (!busCubit.state.status.isSuccess) {
      return SizedBox();
    }

    return CustomCard(
      bgColor: busCubit.state.status.isSuccess && stationList.isEmpty
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.primaryContainer,
      content: Column(
        spacing: 20,
        children: [
          if (busCubit.state.status.isSuccess && stationList.isEmpty)
            emptyStation(context, busCubit)
          else
            for (final (int i, StationListItem e) in stationList.indexed)
              stopRow(
                context,
                e,
                mapPointCubit: mapPointCubit,
                isLast: stationList.length - 1 == i,
              ),
        ],
      ),
    );
  }

  Widget stopRow(
    BuildContext context,
    StationListItem station, {
    required MapPointCubit mapPointCubit,
    required bool isLast,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  width: 1,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withAlpha(100),
                ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  children: [
                    Text(
                      station.stationNm,
                      style: StyleText.bodyLarge(context),
                    ),
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
                if (!isLast) Gap(8),
              ],
            ),
          ),
          Row(
            children: [
              ConfirmButton(
                description: mapPointCubit.state.marker
                            ?.any((e) => e.markerId == station.stationNo) ==
                        true
                    ? '제거'
                    : '표시',
                onTap: () async => displayStationOnMap(context, station),
                color: Theme.of(context).colorScheme.secondaryContainer,
                width: 60,
                height: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget emptyStation(BuildContext context, BusInfoCubit busCubit) {
    return Row(
      children: [
        Flexible(
          child: Text(
            '${busCubit.state.busId?.busRouteId}번 버스에 해당되는 정류장이 없습니다.',
            style: StyleText.bodyLarge(context, colorType: ColorType.error),
          ),
        ),
      ],
    );
  }
}
