import 'package:flutter/material.dart';

enum BusRouteTypeEnum {
  t1(1, '공항', Colors.red),
  t2(2, '마을', Colors.green),
  t3(3, '간선', Colors.blue),
  t4(4, '지선', Colors.green),
  t5(5, '순환', Colors.yellow),
  t6(6, '광역', Colors.red),
  t7(7, '인천', Colors.green);

  const BusRouteTypeEnum(this.code, this.description, this.color);

  final int code;
  final String description;
  final Color color;
}
