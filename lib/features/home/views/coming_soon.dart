import 'package:flutter/material.dart';
import 'package:speak_sphere/cores/cores.dart';
import 'package:speak_sphere/features/home/views/lesson_view.dart';

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    super.key,
    required this.slideInAnimation,
  });
  final Animation<double> slideInAnimation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: AnimatedBuilder(
        animation: slideInAnimation,
        builder: (context, _) {
          return Transform.translate(
            offset: Offset(0, -slideInAnimation.value),
            child: const VideoView(),
          );
        },
      ),
    );
  }
}
