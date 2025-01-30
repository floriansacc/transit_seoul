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
                extra: {'heroTag': 'test_1'},
              ),
              imageUrl: 'assets/images/seoul_map_thumbnail.jpg',
              heroTag: 'test_1',
              title: '노선 정보 조회하기',
              description:
                  '버스 노선을 조회하고 실시간 정보를 확인하는 서비스입니다. 자주 이용하시는 노선을 확인하러 갈까요?',
            ),
          ]),
        ),
      ],
    );
  }
}
