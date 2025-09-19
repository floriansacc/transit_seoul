enum SubwayLineEnum {
  line1('1001', '1호선'),
  line2('1002', '2호선'),
  line3('1003', '3호선'),
  line4('1004', '4호선'),
  line5('1005', '5호선'),
  line6('1006', '6호선'),
  line7('1007', '7호선'),
  line8('1008', '8호선'),
  line9('1009', '9호선'),
  gyeonguiJungang('1063', '경의중앙선'),
  airportRail('1065', '공항철도'),
  gyeongchun('1067', '경춘선'),
  suinBundang('1075', '수인분당선'),
  shinbundang('1077', '신분당선'),
  uiSinsul('1092', '우이신설선'),
  gtxA('1032', 'GTX-A');

  const SubwayLineEnum(this.code, this.krName);

  final String code;
  final String krName;
}
