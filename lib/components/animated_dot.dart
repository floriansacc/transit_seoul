import 'package:flutter/material.dart';

class AnimatedDot extends StatefulWidget {
  const AnimatedDot({
    super.key,
    this.offsetYValue = 0.5,
    this.dotColor,
    this.height = 20,
  });

  final double offsetYValue;
  final Color? dotColor;
  final double height;

  @override
  State<AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<AnimatedDot>
    with TickerProviderStateMixin {
  late AnimationController _dotController1;
  late AnimationController _dotController2;
  late AnimationController _dotController3;
  late Animation<Offset> _dotAnimation1;
  late Animation<Offset> _dotAnimation2;
  late Animation<Offset> _dotAnimation3;

  ValueNotifier<bool> isColorChanged1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isColorChanged2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isColorChanged3 = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _dotController1 = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _dotController2 = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _dotController3 = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _dotAnimation1 = Tween<Offset>(
      begin: Offset(0, widget.offsetYValue),
      end: Offset(0, -widget.offsetYValue),
    ).animate(
      CurvedAnimation(
        parent: _dotController1,
        curve: Curves.easeInOut,
      ),
    );

    _dotAnimation2 = Tween<Offset>(
      begin: Offset(0, widget.offsetYValue),
      end: Offset(0, -widget.offsetYValue),
    ).animate(
      CurvedAnimation(
        parent: _dotController2,
        curve: Curves.easeInOut,
      ),
    );
    _dotAnimation3 = Tween<Offset>(
      begin: Offset(0, widget.offsetYValue),
      end: Offset(0, -widget.offsetYValue),
    ).animate(
      CurvedAnimation(
        parent: _dotController3,
        curve: Curves.easeInOut,
      ),
    );

    _dotController1.repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _dotController2.repeat(reverse: true);
      }
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _dotController3.repeat(reverse: true);
      }
    });

    _dotController1.addListener(() {
      _dotController1.value >= 0.5
          ? isColorChanged1.value = true
          : isColorChanged1.value = false;
    });
    _dotController2.addListener(() {
      _dotController2.value >= 0.5
          ? isColorChanged2.value = true
          : isColorChanged2.value = false;
    });
    _dotController3.addListener(() {
      _dotController3.value >= 0.5
          ? isColorChanged3.value = true
          : isColorChanged3.value = false;
    });
  }

  @override
  void dispose() {
    _dotController1.dispose();
    _dotController2.dispose();
    _dotController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: widget.height),
        _animatedDot(_dotAnimation1, isColorChanged1),
        _animatedDot(_dotAnimation2, isColorChanged2),
        _animatedDot(_dotAnimation3, isColorChanged3),
        SizedBox(height: widget.height),
      ],
    );
  }

  Widget _animatedDot(
    Animation<Offset> animation,
    ValueNotifier<bool> valueListened,
  ) {
    return SlideTransition(
      position: animation,
      child: ValueListenableBuilder(
        valueListenable: valueListened,
        builder: (context, value, child) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? widget.dotColor ?? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          );
        },
      ),
    );
  }
}
