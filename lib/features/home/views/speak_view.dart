import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_sphere/cores/cores.dart';

class SpeakView extends StatefulWidget {
  const SpeakView({super.key});

  @override
  State<SpeakView> createState() => _SpeakViewState();
}

class _SpeakViewState extends State<SpeakView> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _slideInAnimation;
  late Animation<double> _slideOutAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideInAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.125,
          curve: Curves.easeOut,
        ),
      ),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(_scaleController);

    _slideOutAnimation = Tween<double>(begin: -600.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.125,
          0.2,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );

    _scaleController.repeat(reverse: true);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            right: 10.0,
            left: 10.0,
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _slideInAnimation,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(),
                    SizedBox(height: 29),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Speak this sentence',
                        style: TextStyle(
                          fontFamily: josefinSans,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kText3Color,
                        ),
                      ),
                    ),
                  ],
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideInAnimation.value),
                    child: child,
                  );
                },
              ),
              const SizedBox(height: 29),
              Center(child: SvgPicture.asset(mic)),
              const SizedBox(height: 34),
              const Text(
                'Bonjour, Buchi, enchante',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: josefinSans,
                  decoration: TextDecoration.underline,
                  color: kText3Color,
                ),
              ),
              SizedBox(height: size.height * .18),
              AnimatedBuilder(
                animation: _scaleAnimation,
                child: SvgPicture.asset(micSpeak),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
              ),
              SizedBox(height: size.height * .18),
              AnimatedBuilder(
                animation: _slideOutAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: _ColumnedText(),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 56,
                      width: size.width,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: josefinSans,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_slideOutAnimation.value),
                    child: child,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}

class _ColumnedText extends StatelessWidget {
  const _ColumnedText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brilliant!',
          style: TextStyle(
            color: kText3Color,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: josefinSans,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Meaning:',
          style: TextStyle(
            color: kText3Color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: josefinSans,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Hello, Buchi, nice to meet you.',
          style: TextStyle(
            color: kText3Color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: josefinSans,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(arrowLeftIcon),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 15,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: containerBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: ((size.width * .9) * .6),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
