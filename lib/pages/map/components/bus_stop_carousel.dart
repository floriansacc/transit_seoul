import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transit_seoul/models/bus/bus_station_list.dart';
import 'package:transit_seoul/pages/map/components/bus_stop_card.dart';

class BusStopCarousel extends StatefulWidget {
  const BusStopCarousel({
    super.key,
    required this.stationList,
    this.onTapCard,
  });

  final List<StationListItem> stationList;
  final Function(LatLng coord)? onTapCard;

  @override
  State<BusStopCarousel> createState() => _BusStopCarouselState();
}

class _BusStopCarouselState extends State<BusStopCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        for (final StationListItem e in widget.stationList)
          BusStopCard(
            station: e,
            onTapCard: () {
              if (widget.onTapCard != null) {
                widget.onTapCard!(LatLng(e.gpsY, e.gpsX));
              }
            },
          ),
      ],
      options: CarouselOptions(
        autoPlay: false,
        height: 100,
        onPageChanged: (index, reason) {
          if (widget.onTapCard != null) {
            StationListItem? item = widget.stationList[index];
            widget.onTapCard!(LatLng(item.gpsY, item.gpsX));
          }
        },
      ),
    );
  }
}
