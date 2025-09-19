import 'package:collection/collection.dart';
import 'package:transit_seoul/enums/metro/subway_line_enum.dart';
import 'package:transit_seoul/enums/metro/train_status_enum.dart';
import 'package:transit_seoul/models/metro/error_header_model.dart';

class MetroRealtimeModel {
  const MetroRealtimeModel({
    required this.errorMessage,
    required this.realtimePositionList,
  });

  final ErrorHeaderModel errorMessage;
  final List<MetroRealtimeItem>? realtimePositionList;

  static MetroRealtimeModel fromJson(Map<String, dynamic> json) {
    return MetroRealtimeModel(
      errorMessage: ErrorHeaderModel.fromJson(json['errorMessage']),
      realtimePositionList:
          MetroRealtimeItem.fromJsonList(json['realtimePositionList'] ?? []),
    );
  }
}

class MetroRealtimeItem {
  const MetroRealtimeItem({
    this.beginRow,
    this.endRow,
    this.curPage,
    this.pageRow,
    this.totalCount,
    this.rowNum,
    this.selectedCount,
    this.subwayId,
    this.subwayNm,
    this.statnId,
    this.statnNm,
    this.trainNo,
    this.lastRecptnDt,
    this.recptnDt,
    this.updnLine,
    this.statnTid,
    this.statnTnm,
    this.trainSttus,
    this.directAt,
    this.lstcarAt,
  });

  final int? beginRow;
  final int? endRow;
  final int? curPage;
  final int? pageRow;
  final int? totalCount;
  final int? rowNum;
  final int? selectedCount;
  final SubwayLineEnum? subwayId;
  final String? subwayNm;
  final String? statnId;
  final String? statnNm;
  final String? trainNo;
  final String? lastRecptnDt;
  final String? recptnDt;
  final String? updnLine;
  final String? statnTid;
  final String? statnTnm;
  final TrainStatusEnum? trainSttus;
  final String? directAt;
  final String? lstcarAt;

  static List<MetroRealtimeItem> fromJsonList(List<dynamic> jsonList) {
    // ignore: unnecessary_lambdas
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static MetroRealtimeItem fromJson(Map<String, dynamic> json) {
    return MetroRealtimeItem(
      beginRow: json['beginRow'],
      endRow: json['endRow'],
      curPage: json['curPage'],
      pageRow: json['pageRow'],
      totalCount: json['totalCount'],
      rowNum: json['rowNum'],
      selectedCount: json['selectedCount'],
      subwayId: SubwayLineEnum.values
          .firstWhereOrNull((e) => e.code == json['subwayId']),
      subwayNm: json['subwayNm'],
      statnId: json['statnId'],
      statnNm: json['statnNm'],
      trainNo: json['trainNo'],
      lastRecptnDt: json['lastRecptnDt'],
      recptnDt: json['recptnDt'],
      updnLine: json['updnLine'],
      statnTid: json['statnTid'],
      statnTnm: json['statnTnm'],
      trainSttus: TrainStatusEnum.values
          .firstWhereOrNull((e) => e.trainCode == json['trainSttus']),
      directAt: json['directAt'],
      lstcarAt: json['lstcarAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'beginRow': beginRow,
      'endRow': endRow,
      'curPage': curPage,
      'pageRow': pageRow,
      'totalCount': totalCount,
      'rowNum': rowNum,
      'selectedCount': selectedCount,
      'subwayId': subwayId,
      'subwayNm': subwayNm,
      'statnId': statnId,
      'statnNm': statnNm,
      'trainNo': trainNo,
      'lastRecptnDt': lastRecptnDt,
      'recptnDt': recptnDt,
      'updnLine': updnLine,
      'statnTid': statnTid,
      'statnTnm': statnTnm,
      'trainSttus': trainSttus,
      'directAt': directAt,
      'lstcarAt': lstcarAt,
    };
  }
}
