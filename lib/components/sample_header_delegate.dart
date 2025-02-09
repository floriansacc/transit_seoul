import 'package:flutter/material.dart';
import 'dart:math' as math;

//////////////////////////////////////////////////////////////////////
///
/// SliverPersistentHeader의 위치를 계산해주는 위젯이다.
/// SliverPersistentHeader 활용했을 때 썼던 위젯이며 이제는 SliverAppBar로 대체했다.
///
//////////////////////////////////////////////////////////////////////
///
///

class SampleHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  SampleHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double currentHeight = maxExtent - shrinkOffset;
    return SizedBox(
      height: currentHeight.clamp(minHeight, maxExtent),
      child: child,
    );
  }

  @override
  bool shouldRebuild(SampleHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
