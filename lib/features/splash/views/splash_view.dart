import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speak_sphere/cores/cores.dart';
import 'package:speak_sphere/features/features.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _appTextController;
  late Animation<double> _appTextAnimation;

  late AnimationController _rotationController;

  late AnimationController _slideLeftController;
  late Animation<Offset> _slideLeftAnimation;

  late AnimationController _slideRightController;
  late Animation<Offset> _slideRightAnimation;

  late AnimationController _fadeInControllerVector1;
  late Animation<double> _fadeInAnimationVector1;

  late AnimationController _fadeInControllerVector2;
  late Animation<double> _fadeInAnimationVector2;

  @override
  void initState() {
    fadeInInit();
    rotationInit();
    slideInInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedObject(
                        appTextAnimation: _fadeInAnimationVector1,
                        object: speakVector,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedObject(
                            appTextAnimation: _appTextAnimation,
                            object: appIcon,
                          ),
                          const SizedBox(height: 10),
                          AnimatedObject(
                            appTextAnimation: _fadeInAnimationVector2,
                            object: speakTheWorld,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: -40,
              top: 50,
              child: RotationTransition(
                turns: _rotationController,
                child: AnimatedObject(
                  appTextAnimation: _appTextAnimation,
                  object: rotationVector,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: size.height * .5,
              child: SlideObject(
                slideAnimation: _slideLeftAnimation,
                child: AnimatedObject(
                  appTextAnimation: _appTextAnimation,
                  object: messageVector,
                ),
              ),
            ),
            Positioned(
              right: size.width * .03,
              bottom: size.height * .58,
              child: AnimatedObject(
                appTextAnimation: _fadeInAnimationVector1,
                object: vector3,
              ),
            ),
            Positioned(
              right: size.width * .05,
              bottom: size.height * .57,
              child: AnimatedObject(
                appTextAnimation: _fadeInAnimationVector2,
                object: vector5,
              ),
            ),
            Positioned(
              left: 0,
              bottom: size.height * .25,
              child: SlideObject(
                slideAnimation: _slideLeftAnimation,
                child: AnimatedObject(
                  appTextAnimation: _appTextAnimation,
                  object: maleVector,
                ),
              ),
            ),
            Positioned(
              bottom: size.height * .4,
              left: size.width * .36,
              child: AnimatedObject(
                appTextAnimation: _appTextAnimation,
                object: vector1,
              ),
            ),
            Positioned(
              bottom: size.height * .395,
              left: size.width * .38,
              child: AnimatedObject(
                appTextAnimation: _fadeInAnimationVector1,
                object: vector2,
              ),
            ),
            Positioned(
              bottom: size.height * .38,
              left: size.width * .375,
              child: AnimatedObject(
                appTextAnimation: _fadeInAnimationVector2,
                object: vector4,
              ),
            ),
            Positioned(
              bottom: size.height * .15,
              right: 0,
              child: SlideObject(
                slideAnimation: _slideRightAnimation,
                child: AnimatedObject(
                  appTextAnimation: _appTextAnimation,
                  object: femaleVector,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fadeInInit() {
    _appTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _appTextAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _appTextController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeInControllerVector1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeInAnimationVector1 = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeInControllerVector1,
        curve: Curves.easeInOut,
      ),
    );

    _fadeInControllerVector2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeInAnimationVector2 = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeInControllerVector2,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(
      const Duration(seconds: 1),
      () {
        _appTextController.forward();
        _slideLeftController.forward();
        _slideRightController.forward();
      },
    );

    _appTextController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _rotationController.repeat();

          Future.delayed(
            const Duration(milliseconds: 300),
            () {
              _fadeInControllerVector1.forward();
            },
          );
        }
      },
    );

    _fadeInControllerVector1.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(
            const Duration(milliseconds: 300),
            () {
              _fadeInControllerVector2.forward();
            },
          );
        }
      },
    );

    _fadeInControllerVector2.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 2),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const SelectInterestView(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  void slideInInit() {
    _slideLeftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideLeftAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _slideLeftController,
        curve: Curves.easeInOut,
      ),
    );

    _slideRightController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideRightAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _slideRightController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void rotationInit() {
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _appTextController.dispose();
    _rotationController.dispose();
    _slideLeftController.dispose();
    _slideRightController.dispose();
    _fadeInControllerVector1.dispose();
    _fadeInControllerVector2.dispose();
    super.dispose();
  }
}

class AnimatedObject extends StatelessWidget {
  const AnimatedObject({
    super.key,
    required this.appTextAnimation,
    required this.object,
  });

  final Animation<double> appTextAnimation;
  final String object;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appTextAnimation,
      builder: (context, Widget? child) {
        return Opacity(
          opacity: appTextAnimation.value,
          child: SvgPicture.asset(object),
        );
      },
    );
  }
}

class SlideObject extends StatelessWidget {
  const SlideObject({
    super.key,
    required this.slideAnimation,
    this.child,
  });
  final Animation<Offset> slideAnimation;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }
}
