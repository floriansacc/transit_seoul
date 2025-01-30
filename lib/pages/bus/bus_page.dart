import 'package:transit_seoul/components/custom_main_card.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/router/route_enum.dart';
import 'package:flutter/material.dart';

class BusPage extends StatefulWidget {
  const BusPage({
    super.key,
    this.controller,
  });

  final ScrollController? controller;

  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            CustomMainCard(
              onTap: () => PublicMethod.pushPage(
                context,
                RouteEnum.busInfo,
                extra: {'heroTag': 'bus_info_1'},
              ),
              imageUrl: 'assets/images/seoul_map_thumbnail.jpg',
              heroTag: 'bus_info_1',
              title: '노선 정보 조회하기',
              description:
                  '버스 노선을 조회하고 실시간 정보를 확인하는 서비스입니다. 자주 이용하시는 노선을 확인하러 갈까요?',
            ),
            CustomMainCard(
              onTap: () =>
                  PublicMethod.pushPage(context, RouteEnum.busAroundMe),
              imageUrl: 'assets/images/test_1.avif',
              title: '내 주변 노선 확인하기',
              description: '주변에 어떤 버스가 있고 어디까지 데려다줄 수 있는지를 알아봐주는 기능.',
              heroTag: '',
            ),
          ]),
        ),
      ],
    );
  }
}
