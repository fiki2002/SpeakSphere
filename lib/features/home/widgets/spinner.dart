import 'package:flutter/material.dart';
import 'package:speak_sphere/cores/constants/palette.dart';

import 'dart:math' as math show sin, pi;

class Spinner extends StatefulWidget {
  const Spinner({super.key});

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();
    super.initState();
  }

  static const _itemCount = 12;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: const Size.square(30),
        child: Stack(
          children: List.generate(
            _itemCount,
            (i) {
              const position = 30 * .5;
              return Positioned.fill(
                left: position,
                top: position,
                child: Transform(
                  transform: Matrix4.rotationZ(30.0 * i * 0.0174533),
                  child: Align(
                    alignment: Alignment.center,
                    child: FadeTransition(
                      opacity: DelayTween(
                        begin: 0.0,
                        end: 1.0,
                        delay: i / _itemCount,
                      ).animate(_controller),
                      child: SizedBox.fromSize(
                        size: const Size.square(30 * 0.15),
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DelayTween extends Tween<double> {
  DelayTween({
    double? begin,
    double? end,
    required this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
