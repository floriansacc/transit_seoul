import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class AnimatedPageWrapperSlide extends StatelessWidget {
  const AnimatedPageWrapperSlide({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children.mapIndexed(
        (int index, Widget navigator) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              const Offset begin = Offset(0.0, 1.0);
              const Offset end = Offset.zero;
              const Curve curve = Curves.easeOut;

              final Animatable<Offset> tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                key: navigator.key,
                position: animation.drive(tween),
                child: child,
              );
            },
            child: index == currentIndex
                ? _branchNavigatorWrapper(index, navigator)
                : const SizedBox.shrink(),
          );
        },
      ).toList(),
    );
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: true, // index == currentIndex,
          child: navigator,
        ),
      );
}

// Custom branch Navigator container that provides animated transitions
/// when switching branches.
class AnimatedPageWrapperOpacity extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedPageWrapperOpacity({
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
