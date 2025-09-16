import 'package:flutter/material.dart';
import 'package:transit_seoul/models/bus/bus_station_list.dart';
import 'package:transit_seoul/styles/style_text.dart';

class BusStopCard extends StatelessWidget {
  const BusStopCard({super.key, required this.station, this.onTapCard});

  final StationListItem station;
  final VoidCallback? onTapCard;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        station.stationNm,
                        style: StyleText.bodyLarge(context),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.location_on),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
