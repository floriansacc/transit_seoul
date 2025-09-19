import 'package:flutter/material.dart';
import 'package:transit_seoul/components/confirm_button.dart';
import 'package:transit_seoul/enums/metro/subway_line_enum.dart';
import 'package:transit_seoul/models/metro/metro_realtime_model.dart';
import 'package:transit_seoul/services/metro_service.dart';

class MetroPage extends StatelessWidget {
  const MetroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ConfirmButton(
          description: 'test',
          onTap: () async {
            final MetroRealtimeModel test = await MetroService.instance
                .getMetroPosition(SubwayLineEnum.line2);

            for (final MetroRealtimeItem e in test.realtimePositionList ?? []) {
              print(e.toJson());
            }
          },
        ),
      ),
    );
  }
}
