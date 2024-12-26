class MsgHeader {
  const MsgHeader({
    required this.headerCd,
    required this.headerMsg,
    required this.itemCount,
  });

  final String headerCd;
  final String headerMsg;
  final int itemCount;

  static MsgHeader fromJson(Map<String, dynamic> json) {
    return MsgHeader(
      headerCd: json['headerCd'] ?? '',
      headerMsg: json['headerMsg'] ?? '',
      itemCount: json['itemCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerCd': headerCd,
      'headerMsg': headerMsg,
      'itemCount': itemCount,
    };
  }
}
