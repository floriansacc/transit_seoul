import 'package:bus_app/components/animated_dot.dart';
import 'package:bus_app/components/custom_card.dart';
import 'package:bus_app/controllers/date_formatter.dart';
import 'package:bus_app/enums/bus_route_type_enum.dart';
import 'package:bus_app/models/bus/bus_route_info.dart';
import 'package:bus_app/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BusDetails extends StatefulWidget {
  const BusDetails({super.key});

  @override
  State<BusDetails> createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    BusInfoStatus busStatus = busCubit.state.status;

    final TextStyle? defaultTitleStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            );

    final TextStyle? errorTitleStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            );
    final TextStyle? errorBodyStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            );

    return Column(
      children: [
        CustomCard(
          bgColor: switch (busStatus) {
            BusInfoStatus.initial =>
              Theme.of(context).colorScheme.primaryContainer,
            BusInfoStatus.loading =>
              Theme.of(context).colorScheme.secondaryContainer,
            BusInfoStatus.fail => Theme.of(context).colorScheme.errorContainer,
            BusInfoStatus.success =>
              Theme.of(context).colorScheme.primaryContainer,
          },
          onTap: () {},
          content: Column(
            spacing: 12,
            crossAxisAlignment: busStatus.isInitial || busStatus.isLoading
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (busStatus.isFailed) ...[
                // Image.asset(''),
                busCubit.state.searchNumber != null
                    ? RichText(
                        text: TextSpan(
                          text: '${busCubit.state.searchNumber}',
                          style: errorTitleStyle?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: '번 버스 조회가 실패하였습니다.',
                              style: errorTitleStyle,
                            ),
                          ],
                        ),
                      )
                    : Text(
                        '조회가 실패하였습니다.',
                        style: errorTitleStyle,
                      ),
                Text(
                  '다시 시도하거나 다른 버스를 조회해보세요.',
                  style: errorBodyStyle,
                ),
              ] else if (busStatus.isInitial) ...[
                Text(
                  '버스 조회하세요',
                  style: defaultTitleStyle,
                  textAlign: TextAlign.center,
                ),
              ] else if (busStatus.isLoading) ...[
                Text(
                  '검색중',
                  style: defaultTitleStyle,
                ),
                AnimatedDot(),
              ] else if (busStatus.isSuccess) ...[
                successBody(context, busCubit),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget successBody(BuildContext context, BusInfoCubit busCubit) {
    BusRouteInfoItem? busInfo = busCubit.state.busInfo?.msgBody.itemList.first;

    final TextStyle? headlineStyle =
        Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            );

    final TextStyle? bodyLargeStyle =
        Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            );
    final TextStyle? bodyStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            );
    final TextStyle? bodyBoldStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            );

    final TextStyle? errorBodyStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w700,
            );

    DateTime? lastBusTime = DateFormatter.toDate(busInfo?.lastBusTm);

    BusRouteTypeEnum? routeType = BusRouteTypeEnum.values
        .firstWhereOrNull((e) => e.code == busInfo?.routeType);

    Widget lastBusInfo() {
      if (busInfo?.lastBusYn == 'Y') {
        return Text(
          '막차 운행중',
          style: errorBodyStyle,
        );
      }
      if (lastBusTime == null) {
        return SizedBox();
      }
      if (DateTime.now().isAfter(lastBusTime)) {
        return Text(
          '운행 종료',
          style: errorBodyStyle,
        );
      } else if (DateTime.now()
              .subtract(Duration(hours: 1))
              .isBefore(lastBusTime) &&
          DateTime.now().isBefore(lastBusTime)) {
        return Text(
          '곧 운행 종료',
          style: errorBodyStyle,
        );
      } else {
        return Text(
          '운행중',
          style: bodyStyle,
        );
      }
    }

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '버스 정보',
              style: headlineStyle,
            ),
          ],
        ),
        Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${busInfo?.busRouteNm}',
              style: bodyLargeStyle,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: routeType?.color,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Text(
                  '${routeType?.description}',
                  style: bodyBoldStyle,
                ),
              ),
            ),
          ],
        ),
        Gap(10),
        Text(
          '배차간격: ${busInfo?.term}분',
          style: bodyStyle,
        ),
        if (lastBusTime != null)
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '막차 시간: ${lastBusTime.hour}시',
                style: bodyStyle,
              ),
              lastBusInfo(),
            ],
          ),
      ],
    );
  }
}
