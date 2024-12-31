import 'package:bus_app/components/animated_dot.dart';
import 'package:bus_app/components/custom_card.dart';
import 'package:bus_app/controllers/date_formatter.dart';
import 'package:bus_app/enums/bus_route_type_enum.dart';
import 'package:bus_app/enums/color_type.dart';
import 'package:bus_app/models/bus/bus_route_info.dart';
import 'package:bus_app/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:bus_app/styles/style_text.dart';
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

    final TextStyle? errorTitleStyle =
        StyleText.titleMedium(context, colorType: ColorType.error);

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
                  style:
                      StyleText.bodyMedium(context, colorType: ColorType.error),
                ),
              ] else if (busStatus.isInitial) ...[
                Text(
                  '버스 조회하세요',
                  style: StyleText.titleMedium(context),
                  textAlign: TextAlign.center,
                ),
              ] else if (busStatus.isLoading) ...[
                Text(
                  '검색중',
                  style: StyleText.titleMedium(context),
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

    final TextStyle? headlineStyle = StyleText.headlineSmall(context);

    final TextStyle? bodyStyle = StyleText.bodyMedium(context);

    final TextStyle? errorBodyStyle = StyleText.bodyMedium(
      context,
      fontWeight: FontWeight.w700,
      colorType: ColorType.error,
    );

    DateTime? firstBusTime = DateFormatter.toDate(busInfo?.firstBusTm);
    DateTime? lastBusTime = DateFormatter.toDate(busInfo?.lastBusTm);

    BusRouteTypeEnum? routeType = BusRouteTypeEnum.values
        .firstWhereOrNull((e) => e.code == busInfo?.routeType);

    Widget lastBusInfo() {
      DateTime now = DateTime.now();

      if (lastBusTime == null || firstBusTime == null) {
        return SizedBox();
      }

      if (busInfo?.lastBusYn == 'Y') {
        return Text(
          '막차 운행중',
          style: errorBodyStyle,
        );
      }

      if (now.isAfter(lastBusTime) || now.isBefore(firstBusTime)) {
        return Text(
          '운행 종료',
          style: errorBodyStyle,
        );
      } else if (now.difference(lastBusTime).inMinutes.abs() < 60 &&
          now.isBefore(lastBusTime)) {
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
              style: StyleText.bodyLarge(context),
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
                  style: StyleText.bodyMedium(
                    context,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Text(
              '(${busInfo?.length}km)',
              style: bodyStyle,
            ),
          ],
        ),
        Gap(10),
        Text(
          '배차간격: ${busInfo?.term}분',
          style: bodyStyle,
        ),
        if (firstBusTime != null)
          Text(
            '첫차 시간: ${firstBusTime.hour}시${firstBusTime.minute != 0 ? ' ${firstBusTime.minute}분' : ''}',
            style: bodyStyle,
          ),
        if (lastBusTime != null)
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '막차 시간: ${lastBusTime.hour}시${lastBusTime.minute != 0 ? ' ${lastBusTime.minute}분' : ''}',
                style: bodyStyle,
              ),
              lastBusInfo(),
            ],
          ),
      ],
    );
  }
}
