class SubwayStationItem {
  const SubwayStationItem({
    this.lineNum,
    this.stationNmChn,
    this.stationCd,
    this.stationNmJpn,
    this.stationNmEng,
    this.stationNm,
    this.frCode,
  });

  final String? lineNum;
  final String? stationNmChn;
  final String? stationCd;
  final String? stationNmJpn;
  final String? stationNmEng;
  final String? stationNm;
  final String? frCode;

  static List<SubwayStationItem> fromJsonList(List<dynamic> jsonList) {
    // ignore: unnecessary_lambdas
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static SubwayStationItem fromJson(Map<String, dynamic> json) {
    return SubwayStationItem(
      lineNum: json['line_num'],
      stationNmChn: json['station_nm_chn'],
      stationCd: json['station_cd'],
      stationNmJpn: json['station_nm_jpn'],
      stationNmEng: json['station_nm_eng'],
      stationNm: json['station_nm'],
      frCode: json['fr_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lineNum': lineNum,
      'stationNmChn': stationNmChn,
      'stationCd': stationCd,
      'stationNmJpn': stationNmJpn,
      'stationNmEng': stationNmEng,
      'stationNm': stationNm,
      'frCode': frCode,
    };
  }
}
