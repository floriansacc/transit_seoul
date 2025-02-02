enum BusCongestionEnum {
  empty(0, '없음'),
  free(3, '여유'),
  medium(4, '보통'),
  full(5, '혼잡'),
  veryFull(6, '매우혼잡');

  const BusCongestionEnum(this.number, this.description);

  final int number;
  final String description;
}
