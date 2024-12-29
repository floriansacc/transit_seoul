import 'package:bus_app/components/custom_card.dart';
import 'package:bus_app/models/bus/bus_route_info.dart';
import 'package:bus_app/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusDetail extends StatefulWidget {
  const BusDetail({super.key});

  @override
  State<BusDetail> createState() => _BusDetailState();
}

class _BusDetailState extends State<BusDetail> {
  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    BusRouteInfoItem? busInfo = busCubit.state.busInfo?.msgBody.itemList.first;

    BusInfoStatus busStatus = busCubit.state.status;

    final TextStyle? defaultTitleStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            );
    final TextStyle? defaultBodyeStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            );
    final TextStyle? errorStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            );

    return Column(
      children: [
        CustomCard(
          bgColor: busStatus.isFailed
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.primaryContainer,
          onTap: () {},
          content: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (busStatus.isFailed) ...[
                // Image.asset(''),
                busCubit.state.searchNumber != null
                    ? RichText(
                        text: TextSpan(
                          text: '${busCubit.state.searchNumber}',
                          style:
                              errorStyle?.copyWith(fontWeight: FontWeight.w700),
                          children: [
                            TextSpan(
                              text: '번 버스 조회가 실패하였습니다.',
                              style: defaultTitleStyle,
                            ),
                          ],
                        ),
                      )
                    : Text(
                        '조회가 실패하였습니다.',
                        style: defaultTitleStyle,
                      ),
                Text(
                  '다시 시도하거나 다른 버스를 조회해보세요.',
                  style: defaultBodyeStyle,
                ),
              ] else ...[
                Text('버스 번호: ${busInfo?.busRouteNm}'),
                // Text('버스 번호: ${busInfo?.}'),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
