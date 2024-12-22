// Custom branch Navigator container that provides animated transitions
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// when switching branches.
class PageWrapperOpacity extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const PageWrapperOpacity({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children.mapIndexed(
        (int index, Widget navigator) {
          return AnimatedScale(
            scale: index == currentIndex ? 1 : 0.9,
            duration: const Duration(milliseconds: 200),
            child: AnimatedOpacity(
              opacity: index == currentIndex ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: _branchNavigatorWrapper(index, navigator),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}
