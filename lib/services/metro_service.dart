import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transit_seoul/enums/metro/subway_line_enum.dart';
import 'package:transit_seoul/models/metro/metro_realtime_model.dart';
import 'package:transit_seoul/services/global_service.dart';

class MetroService extends GlobalService {
  MetroService._privateConstructor();

  static final MetroService _instance = MetroService._privateConstructor();
  static MetroService get instance => _instance;

  Future<MetroRealtimeModel> getMetroPosition(
    SubwayLineEnum lineName, {
    int numOfElements = 5,
  }) async {
    String endpoint = '/realtimePosition/0/$numOfElements/${lineName.krName}';

    try {
      // FirebaseFirestore db = FirebaseFirestore.instance;

      final http.Response response = await httpRequest(
        HttpMethod.get,
        apiUrl: ApiType.metroInfo,
        path: endpoint,
        // queryParameters: {'busRouteId': '$busId'},
      );

      return MetroRealtimeModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> saveStationToFirebase() async {
  //   FirebaseFirestore db = FirebaseFirestore.instance;

  //   final String response =
  //       await rootBundle.loadString('assets/json/station_coord.json');
  //   final stationData = await json.decode(response)['DATA'];

  //   List<TestClass> test = TestClass.fromJsonList(stationData);

  //   print(test.length);

  //   CollectionReference<Map<String, dynamic>> fbDoc =
  //       db.collection(FirebaseCollection.subwayStation.title);

  //   for (final TestClass e in test) {
  //     fbDoc.doc(e.stationCd.toString()).update(e.toJson());
  //     debugPrint('update doc for ${e.stationCd}, with ${e.toJson()}');
  //   }
  // }
}
