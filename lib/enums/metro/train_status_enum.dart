enum TrainStatusEnum {
  entering('0', '진입'),
  arriving('1', '도착'),
  departing('2', '출발'),
  departingPreviousStation('3', '전역출발');

  const TrainStatusEnum(this.trainCode, this.krDescription);

  final String trainCode;
  final String krDescription;
}
